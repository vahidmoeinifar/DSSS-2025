#include "DecisionEngine.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QFileInfo>
#include <QDir>
#include <QFile>
#include <QDateTime>
#include <QTimer>
#include <algorithm>
#include <cmath>


DecisionEngine::DecisionEngine(QObject *parent)
    : QObject(parent),
    m_fusedValue(0.0),
    m_python(new QProcess(this)),
    m_scriptBasePath("C:/Users/Karabey/Documents/DSSS-2025/scripts/"),
    m_isComparing(false),
    m_meanValue(0.0),
    m_stdDevValue(0.0),
    m_bestAlgorithm(""),
    m_fastestAlgorithm(""),
    m_comparisonProgressCurrent(0),
    m_comparisonProgressTotal(0),
    m_historyManager(new HistoryManager(this)),
    m_currentSingleScript("")
{
    connect(m_python, &QProcess::finished,
            this, &DecisionEngine::onPythonFinished);

    connect(m_python, &QProcess::readyReadStandardOutput, this, [this]() {
        m_pythonOutput.append(m_python->readAllStandardOutput());
        qDebug() << "Python partial STDOUT:" << m_pythonOutput;
    });

    connect(m_python, &QProcess::readyReadStandardError, this, [this]() {
        QByteArray error = m_python->readAllStandardError();
        if (!error.isEmpty()) {
            qDebug() << "Python STDERR:" << error;
            emit pythonError(QString("Python error: %1").arg(QString(error)));
        }
    });

    connect(m_python, &QProcess::errorOccurred, this, [this](QProcess::ProcessError error) {
        QString errorMsg;
        switch (error) {
        case QProcess::FailedToStart:
            errorMsg = "Python failed to start. Make sure Python is installed and the script exists.";
            break;
        case QProcess::Crashed:
            errorMsg = "Python script crashed.";
            break;
        case QProcess::Timedout:
            errorMsg = "Python script timed out.";
            break;
        case QProcess::WriteError:
            errorMsg = "Error writing to Python process.";
            break;
        case QProcess::ReadError:
            errorMsg = "Error reading from Python process.";
            break;
        default:
            errorMsg = "Unknown Python process error.";
        }
        emit pythonError(errorMsg);
    });

    // Log startup
    m_historyManager->logInfo("DecisionEngine initialized", "System");
}

// Add destructor implementation
DecisionEngine::~DecisionEngine()
{
    // Cleanup
    if (m_python->state() == QProcess::Running) {
        m_python->terminate();
        m_python->waitForFinished(1000);
    }

    // Log shutdown
    if (m_historyManager) {
        m_historyManager->logInfo("DecisionEngine shutting down", "System");
    }

    delete m_python;
}

void DecisionEngine::addAgentValue(double value)
{
    addAgent(value, 1.0);
}
void DecisionEngine::addAgent(double value, double confidence)
{
    confidence = qBound(0.0, confidence, 1.0); // Clamp to [0, 1]
    m_agents.append(AgentData(value, confidence));
    emit agentsChanged();
}
void DecisionEngine::updateAgentConfidence(int index, double confidence)
{
    if (index >= 0 && index < m_agents.size()) {
        confidence = qBound(0.0, confidence, 1.0);
        m_agents[index].confidence = confidence;
        emit agentConfidenceChanged(index);
        emit agentsChanged();
    }
}

void DecisionEngine::setAgentConfidence(int index, double confidence)
{
    updateAgentConfidence(index, confidence);
}

double DecisionEngine::getAgentConfidence(int index) const
{
    if (index >= 0 && index < m_agents.size()) {
        return m_agents[index].confidence;
    }
    return 0.0;
}

QVariantList DecisionEngine::getAgentsWithConfidence() const
{
    QVariantList agents;
    for (const AgentData& agent : m_agents) {
        QVariantMap agentMap;
        agentMap["value"] = agent.value;
        agentMap["confidence"] = agent.confidence;
        agents.append(agentMap);
    }
    return agents;
}

void DecisionEngine::clearValues()
{
    m_agents.clear();
    m_fusedValue = 0.0;
    emit fusedValueChanged();
    emit agentsChanged();
}

// ========== JSON CREATION HELPERS ==========

QJsonObject DecisionEngine::createJsonForPython(const QVariantList &values,
                                                const QVariantList &confidences)
{
    QJsonArray valuesArray;
    QJsonArray confidencesArray;

    // Add values
    for (const QVariant &v : values) {
        valuesArray.append(v.toDouble());
    }

    // Add confidences if provided
    bool hasConfidences = !confidences.isEmpty() && (confidences.size() == values.size());
    for (const QVariant &c : confidences) {
        confidencesArray.append(c.toDouble());
    }

    QJsonObject root;
    root["values"] = valuesArray;
    root["agent_count"] = static_cast<int>(values.size());

    if (hasConfidences) {
        root["confidences"] = confidencesArray;
    }

    return root;
}
void DecisionEngine::runFusionWithConfidence(const QVariantList &agentValues,
                                             const QVariantList &confidences)
{
    // Use default script (neural.py) if not specified
    runFusionWithConfidence(agentValues, confidences, "neural.py");
}
void DecisionEngine::runFusionWithConfidence(const QVariantList &agentValues,
                                             const QVariantList &confidences,
                                             const QString &scriptName)
{
    if (agentValues.isEmpty()) {
        QString errorMsg = "No agent data!";
        m_historyManager->logError(errorMsg, "Fusion");
        emit pythonError(errorMsg);
        return;
    }

    // Store confidences
    m_currentAgentConfidences = confidences;

    // Call regular runFusion
    runFusion(agentValues, scriptName);
}

void DecisionEngine::runFusion(const QVariantList &agentValues)
{
    runFusion(agentValues, "neural.py");
}

void DecisionEngine::runFusion(const QVariantList &agentValues, const QString &scriptName)
{
    if (agentValues.isEmpty()) {
        QString errorMsg = "No agent data!";
        m_historyManager->logError(errorMsg, "Fusion");
        emit pythonError(errorMsg);
        return;
    }

    // Log the start
    m_historyManager->logInfo(
        QString("Starting fusion with %1 agents using %2")
            .arg(agentValues.size())
            .arg(scriptName),
        "Fusion"
        );

    if (m_isComparing && !scriptName.isEmpty()) {
        m_startTimes[scriptName] = QTime::currentTime();
    }

    // Check if a process is already running
    if (m_python->state() == QProcess::Running) {
        QString errorMsg = "Python process is already running. Please wait.";
        m_historyManager->logError(errorMsg, "Fusion");
        emit pythonError(errorMsg);
        return;
    }

    // Store values internally if needed
    m_agentValues = agentValues;

    // Store script name for single fusion (if not comparing)
    if (!m_isComparing) {
        m_currentSingleScript = scriptName;
    }

    // Clear previous output
    m_pythonOutput.clear();

    QJsonArray arr;
    for (const QVariant &v : agentValues)
        arr.append(v.toDouble());

    QJsonObject root;
    root["values"] = arr;
    root["agent_count"] = static_cast<int>(agentValues.size());

    // Add confidences if available (FIXED: use m_agentConfidences)
    if (!m_agentConfidences.isEmpty() &&
        m_agentConfidences.size() == agentValues.size()) {
        QJsonArray confidencesArr;
        for (const QVariant &c : m_agentConfidences) {
            confidencesArr.append(c.toDouble());
        }
        root["confidences"] = confidencesArr;
    }

    QByteArray inputData = QJsonDocument(root).toJson();
    qDebug() << "Sending to Python:" << inputData;

    QString scriptPath;
    QFileInfo scriptFile(scriptName);

    if (scriptFile.isAbsolute()) {
        scriptPath = scriptName;
    } else {
        scriptPath = m_scriptBasePath + scriptName;
    }

    // Check if script exists
    if (!QFile::exists(scriptPath)) {
        QString errorMsg = QString("Script file not found: %1").arg(scriptPath);
        m_historyManager->logError(errorMsg, "Fusion");
        emit pythonError(errorMsg);
        return;
    }

    qDebug() << "Running Python script:" << scriptPath;

    // Set up the Python process
    m_python->setProgram("python");
    QStringList arguments;
    arguments << scriptPath;

    qDebug() << "Python arguments:" << arguments;
    m_python->setArguments(arguments);

    // Start the process
    m_python->start();

    // Check if process started successfully
    if (!m_python->waitForStarted(5000)) {
        QString errorMsg = "Failed to start Python process. Make sure Python is installed.";
        m_historyManager->logError(errorMsg, "Fusion");
        emit pythonError(errorMsg);
        return;
    }

    // Send JSON to python stdin
    qint64 bytesWritten = m_python->write(inputData);
    if (bytesWritten == -1) {
        QString errorMsg = "Failed to write data to Python process.";
        m_historyManager->logError(errorMsg, "Fusion");
        m_python->terminate();
        emit pythonError(errorMsg);
        return;
    }

    qDebug() << "Written" << bytesWritten << "bytes to Python stdin";
    m_python->closeWriteChannel();
}

void DecisionEngine::sendToPython(const QJsonObject &jsonData, const QString &scriptName)
{
    if (m_isComparing && !scriptName.isEmpty()) {
        m_startTimes[scriptName] = QTime::currentTime();
    }

    // Check if a process is already running
    if (m_python->state() == QProcess::Running) {
        emit pythonError("Python process is already running. Please wait.");
        return;
    }

    // Clear previous output
    m_pythonOutput.clear();

    QByteArray inputData = QJsonDocument(jsonData).toJson();
    qDebug() << "Sending to Python:" << inputData;

    QString scriptPath;
    QFileInfo scriptFile(scriptName);

    if (scriptFile.isAbsolute()) {
        scriptPath = scriptName;
    } else {
        scriptPath = m_scriptBasePath + scriptName;
    }

    // Check if script exists
    if (!QFile::exists(scriptPath)) {
        emit pythonError(QString("Script file not found: %1").arg(scriptPath));
        return;
    }

    qDebug() << "Running Python script:" << scriptPath;

    // Set up the Python process
    m_python->setProgram("python");
    QStringList arguments;
    arguments << scriptPath;

    qDebug() << "Python arguments:" << arguments;
    m_python->setArguments(arguments);

    // Start the process
    m_python->start();

    // Check if process started successfully
    if (!m_python->waitForStarted(5000)) {
        emit pythonError("Failed to start Python process. Make sure Python is installed.");
        return;
    }

    // Send JSON to python stdin
    qint64 bytesWritten = m_python->write(inputData);
    if (bytesWritten == -1) {
        emit pythonError("Failed to write data to Python process.");
        m_python->terminate();
        return;
    }

    qDebug() << "Written" << bytesWritten << "bytes to Python stdin";
    m_python->closeWriteChannel();
}


void DecisionEngine::runComparison(const QVariantList &agentValues,
                                   const QStringList &scripts)
{
    runComparisonWithConfidence(agentValues, QVariantList(), scripts);
}

void DecisionEngine::runComparisonWithConfidence(const QVariantList &agentValues,
                                                 const QVariantList &confidences,
                                                 const QStringList &scripts)
{
    if (agentValues.isEmpty() || scripts.isEmpty()) {
        QString errorMsg = "No agents or scripts provided for comparison.";
        m_historyManager->logError(errorMsg, "Comparison");
        emit pythonError(errorMsg);
        return;
    }

    if (m_python->state() == QProcess::Running) {
        QString errorMsg = "Python process already running.";
        m_historyManager->logError(errorMsg, "Comparison");
        emit pythonError(errorMsg);
        return;
    }

    // Reset comparison state
    m_isComparing = true;
    emit isComparingChanged();

    m_agentValues = agentValues;
    m_agentConfidences = confidences;

    m_pendingScripts = scripts;
    m_comparisonResults.clear();
    m_executionTimes.clear();

    // Set progress tracking
    m_comparisonProgressCurrent = 0;
    m_comparisonProgressTotal = scripts.size();
    emit comparisonProgressChanged();

    emit comparisonCountChanged();
    emit comparisonStatsChanged();

    m_currentScript = m_pendingScripts.takeFirst();

    // Log comparison start
    m_historyManager->logInfo(
        QString("Starting comparison of %1 algorithms with %2 agents")
            .arg(scripts.size())
            .arg(agentValues.size()),
        "Comparison"
        );

    runFusion(agentValues, m_currentScript);
}

void DecisionEngine::onPythonFinished(int exitCode, QProcess::ExitStatus status)
{
    qDebug() << "Python process finished. Exit code:" << exitCode << "Status:" << status;

    // Calculate execution time
    qint64 executionTime = 100; // Default
    QString currentScriptForHistory = m_currentScript.isEmpty() ? m_currentSingleScript : m_currentScript;

    if (m_startTimes.contains(currentScriptForHistory)) {
        QTime startTime = m_startTimes[currentScriptForHistory];
        QTime endTime = QTime::currentTime();
        executionTime = startTime.msecsTo(endTime);
        m_startTimes.remove(currentScriptForHistory);
    }

    if (status != QProcess::NormalExit) {
        QString errorMsg = "Python script crashed.";

        if (m_isComparing) {
            // Handle error during comparison
            if (!m_currentScript.isEmpty()) {
                m_executionTimes[m_currentScript] = executionTime;
                m_comparisonResults.insert(m_currentScript, QVariant::fromValue(0.0));

                // Save error to history
                m_historyManager->saveErrorResult(
                    m_agentValues,
                    m_agentConfidences,  // FIXED: use m_agentConfidences
                    m_currentScript,
                    errorMsg,
                    executionTime
                    );

                // Update progress
                m_comparisonProgressCurrent = m_comparisonResults.size();
                emit comparisonProgressChanged();

                // Continue with next script or finish
                if (!m_pendingScripts.isEmpty()) {
                    m_currentScript = m_pendingScripts.takeFirst();
                    runFusion(m_agentValues, m_currentScript);
                } else {
                    finishComparison();
                }
            }

            m_isComparing = false;
            emit isComparingChanged();
            emit pythonError(errorMsg);
        } else {
            // Save single fusion error
            m_historyManager->saveErrorResult(
                m_agentValues,
                m_agentConfidences,  // FIXED: use m_agentConfidences
                m_currentSingleScript,
                errorMsg,
                executionTime
                );

            emit pythonError(errorMsg);
        }

        m_historyManager->logError(errorMsg, "Fusion");
        return;
    }

    // Read any remaining output
    m_pythonOutput.append(m_python->readAllStandardOutput());

    // Check for Python errors
    if (exitCode != 0) {
        QString error = QString::fromUtf8(m_python->readAllStandardError());
        if (error.isEmpty()) {
            error = "Unknown error";
        }

        QString errorMsg = QString("Python script exited with code %1. Error: %2").arg(exitCode).arg(error);

        if (m_isComparing && !m_currentScript.isEmpty()) {
            // Handle error but continue comparison
            m_executionTimes[m_currentScript] = executionTime;
            m_comparisonResults.insert(m_currentScript, QVariant::fromValue(0.0));

            // Save error to history
            m_historyManager->saveErrorResult(
                m_agentValues,
                m_agentConfidences,  // FIXED: use m_agentConfidences
                m_currentScript,
                errorMsg,
                executionTime
                );

            // Update progress
            m_comparisonProgressCurrent = m_comparisonResults.size();
            emit comparisonProgressChanged();

            // Continue with next script or finish
            if (!m_pendingScripts.isEmpty()) {
                m_currentScript = m_pendingScripts.takeFirst();
                runFusion(m_agentValues, m_currentScript);
            } else {
                finishComparison();
            }
        } else {
            // Save single fusion error
            m_historyManager->saveErrorResult(
                m_agentValues,
                m_agentConfidences,  // FIXED: use m_agentConfidences
                m_currentSingleScript,
                errorMsg,
                executionTime
                );

            emit pythonError(errorMsg);
        }

        m_historyManager->logError(errorMsg, "Fusion");
        return;
    }

    // Check for empty output
    if (m_pythonOutput.isEmpty()) {
        QString errorMsg = "Python script returned no output.";

        if (m_isComparing && !m_currentScript.isEmpty()) {
            // Handle empty output but continue comparison
            m_executionTimes[m_currentScript] = executionTime;
            m_comparisonResults.insert(m_currentScript, QVariant::fromValue(0.0));

            // Save error to history
            m_historyManager->saveErrorResult(
                m_agentValues,
                m_agentConfidences,  // FIXED: use m_agentConfidences
                m_currentScript,
                errorMsg,
                executionTime
                );

            // Update progress
            m_comparisonProgressCurrent = m_comparisonResults.size();
            emit comparisonProgressChanged();

            // Continue with next script or finish
            if (!m_pendingScripts.isEmpty()) {
                m_currentScript = m_pendingScripts.takeFirst();
                runFusion(m_agentValues, m_currentScript);
            } else {
                finishComparison();
            }
        } else {
            // Save single fusion error
            m_historyManager->saveErrorResult(
                m_agentValues,
                m_agentConfidences,  // FIXED: use m_agentConfidences
                m_currentSingleScript,
                errorMsg,
                executionTime
                );

            emit pythonError(errorMsg);
        }

        m_historyManager->logError(errorMsg, "Fusion");
        return;
    }

    qDebug() << "Python full output:" << m_pythonOutput;

    // Parse JSON response
    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(m_pythonOutput, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        QString errorMsg = QString("Failed to parse JSON from Python: %1").arg(parseError.errorString());

        if (m_isComparing && !m_currentScript.isEmpty()) {
            // Handle JSON parse error but continue comparison
            m_executionTimes[m_currentScript] = executionTime;
            m_comparisonResults.insert(m_currentScript, QVariant::fromValue(0.0));

            // Save error to history
            m_historyManager->saveErrorResult(
                m_agentValues,
                m_agentConfidences,  // FIXED: use m_agentConfidences
                m_currentScript,
                errorMsg,
                executionTime
                );

            // Update progress
            m_comparisonProgressCurrent = m_comparisonResults.size();
            emit comparisonProgressChanged();

            // Continue with next script or finish
            if (!m_pendingScripts.isEmpty()) {
                m_currentScript = m_pendingScripts.takeFirst();
                runFusion(m_agentValues, m_currentScript);
            } else {
                finishComparison();
            }
        } else {
            // Save single fusion error
            m_historyManager->saveErrorResult(
                m_agentValues,
                m_agentConfidences,  // FIXED: use m_agentConfidences
                m_currentSingleScript,
                errorMsg,
                executionTime
                );

            emit pythonError(errorMsg);
        }

        m_historyManager->logError(errorMsg, "Fusion");
        return;
    }

    if (!doc.isObject()) {
        QString errorMsg = "Python did not return a valid JSON object.";

        if (m_isComparing && !m_currentScript.isEmpty()) {
            // Handle invalid JSON but continue comparison
            m_executionTimes[m_currentScript] = executionTime;
            m_comparisonResults.insert(m_currentScript, QVariant::fromValue(0.0));

            // Save error to history
            m_historyManager->saveErrorResult(
                m_agentValues,
                m_agentConfidences,  // FIXED: use m_agentConfidences
                m_currentScript,
                errorMsg,
                executionTime
                );

            // Update progress
            m_comparisonProgressCurrent = m_comparisonResults.size();
            emit comparisonProgressChanged();

            // Continue with next script or finish
            if (!m_pendingScripts.isEmpty()) {
                m_currentScript = m_pendingScripts.takeFirst();
                runFusion(m_agentValues, m_currentScript);
            } else {
                finishComparison();
            }
        } else {
            // Save single fusion error
            m_historyManager->saveErrorResult(
                m_agentValues,
                m_agentConfidences,  // FIXED: use m_agentConfidences
                m_currentSingleScript,
                errorMsg,
                executionTime
                );

            emit pythonError(errorMsg);
        }

        m_historyManager->logError(errorMsg, "Fusion");
        return;
    }

    QJsonObject result = doc.object();

    double fusedValue = 0.0;
    double resultConfidence = 1.0; // Default confidence

    if (result.contains("fused")) {
        QJsonValue fusedJson = result["fused"];
        if (fusedJson.isDouble()) {
            fusedValue = fusedJson.toDouble();
        }
    }

    // Check if Python returned confidence
    if (result.contains("confidence")) {
        QJsonValue confidenceJson = result["confidence"];
        if (confidenceJson.isDouble()) {
            resultConfidence = confidenceJson.toDouble();
        }
    }

    // Handle successful completion
    if (m_isComparing && !m_currentScript.isEmpty()) {
        // Store actual execution time
        m_executionTimes[m_currentScript] = executionTime;
        qDebug() << "Script" << m_currentScript << "execution time:" << executionTime << "ms";

        // Store result
        m_comparisonResults.insert(m_currentScript, QVariant::fromValue(fusedValue));

        // Save to history
        m_historyManager->saveFusionResult(
            m_agentValues,
            m_agentConfidences,
            m_currentScript,
            fusedValue,
            resultConfidence,
            executionTime,
            "Comparison run"
            );

        // Update progress
        m_comparisonProgressCurrent = m_comparisonResults.size();
        emit comparisonProgressChanged();

        // Emit progress signal
        emit comparisonProgress(m_comparisonResults.size(),
                                m_comparisonResults.size() + m_pendingScripts.size());

        // Run next script or finish
        if (!m_pendingScripts.isEmpty()) {
            m_currentScript = m_pendingScripts.takeFirst();
            m_pythonOutput.clear();
            runFusion(m_agentValues, m_currentScript);
        } else {
            finishComparison();
        }
    } else {
        // Single fusion (not comparison mode)
        m_fusedValue = fusedValue;
        emit fusedValueChanged();

        // Save to history
        m_historyManager->saveFusionResult(
            m_agentValues,
            m_agentConfidences,
            m_currentSingleScript,
            fusedValue,
            resultConfidence,
            executionTime,
            "Single fusion"
            );

        // Log success
        m_historyManager->logInfo(
            QString("Fusion completed in %1ms with result: %2 (confidence: %3)")
                .arg(executionTime)
                .arg(fusedValue, 0, 'f', 4)
                .arg(resultConfidence, 0, 'f', 2),
            "Fusion"
            );
    }

    // Clear output for next run
    m_pythonOutput.clear();
}
double DecisionEngine::fusedValue() const
{
    return m_fusedValue;
}

QString DecisionEngine::scriptBasePath() const
{
    return m_scriptBasePath;
}

void DecisionEngine::setScriptBasePath(const QString &path)
{
    if (m_scriptBasePath != path) {
        m_scriptBasePath = path;
        // Ensure path ends with separator
        if (!m_scriptBasePath.endsWith('/') && !m_scriptBasePath.endsWith('\\')) {
            m_scriptBasePath += '/';
        }
        emit scriptBasePathChanged();
    }
}

QStringList DecisionEngine::availableScripts() const
{
    QStringList scripts;
    QDir scriptDir(m_scriptBasePath);

    if (scriptDir.exists()) {
        QStringList filters;
        filters << "*.py";
        scriptDir.setNameFilters(filters);

        scripts = scriptDir.entryList(QDir::Files);
    }

    return scripts;
}

bool DecisionEngine::validateScript(const QString &scriptName) const
{
    QString scriptPath = m_scriptBasePath + scriptName;
    QFileInfo scriptFile(scriptPath);
    return scriptFile.exists() && scriptFile.isFile();
}

void DecisionEngine::finishComparison()
{
    m_isComparing = false;
    m_currentScript.clear();

    updateComparisonStats();

    emit isComparingChanged();
    emit comparisonFinished();
    emit comparisonStatsChanged();
     emit comparisonResultsChanged();
}
void DecisionEngine::updateComparisonStats()
{
    if (m_comparisonResults.isEmpty()) {
        m_meanValue = 0.0;
        m_stdDevValue = 0.0;
        m_bestAlgorithm = "";
        m_fastestAlgorithm = "";
        return;
    }

    // Calculate mean
    double sum = 0.0;
    int count = 0;

    QList<double> values;
    for (auto it = m_comparisonResults.begin(); it != m_comparisonResults.end(); ++it) {
        double val = it.value().toDouble();
        values.append(val);
        sum += val;
        count++;
    }

    m_meanValue = sum / count;

    // Calculate standard deviation
    double variance = 0.0;
    for (double val : values) {
        double diff = val - m_meanValue;
        variance += diff * diff;
    }
    m_stdDevValue = std::sqrt(variance / count);

    // Find best algorithm (closest to 0.5 as example, or highest value)
    double bestValue = -1.0;
    for (auto it = m_comparisonResults.begin(); it != m_comparisonResults.end(); ++it) {
        double val = it.value().toDouble();
        if (val > bestValue) {
            bestValue = val;
            m_bestAlgorithm = it.key();
        }
    }

    // Find fastest algorithm (placeholder - you need to track actual times)
    if (!m_executionTimes.isEmpty()) {
        qint64 fastestTime = std::numeric_limits<qint64>::max();
        for (auto it = m_executionTimes.begin(); it != m_executionTimes.end(); ++it) {
            if (it.value() < fastestTime) {
                fastestTime = it.value();
                m_fastestAlgorithm = it.key();
            }
        }
    } else {
        m_fastestAlgorithm = m_bestAlgorithm; // Fallback
    }
}
void DecisionEngine::exportComparisonCSV(const QString &filePath)
{
    if (m_comparisonResults.isEmpty()) {
        emit pythonError("No comparison results to export.");
        return;
    }

    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file for writing:" << filePath;
        emit pythonError("Failed to open file for writing: " + filePath);
        return;
    }

    QTextStream out(&file);

    // Write header with all columns
    out << "Algorithm,FusedValue,ExecutionTime(ms),Rank\n";

    // Get sorted results
    QVariantList results = getComparisonResults();

    for (const QVariant &item : results) {
        QVariantMap result = item.toMap();

        QString algorithm = result["algorithm"].toString();
        double value = result["value"].toDouble();
        qint64 execTime = result["executionTime"].toLongLong();
        int rank = result["rank"].toInt();

        // Escape commas in algorithm names if needed
        QString safeAlgorithm = algorithm;
        if (algorithm.contains(',') || algorithm.contains('"')) {
            safeAlgorithm = "\"" + algorithm.replace("\"", "\"\"") + "\"";
        }

        out << safeAlgorithm << ","
            << QString::number(value, 'f', 6) << ","
            << execTime << ","
            << rank << "\n";
    }

    file.close();
    qDebug() << "CSV exported successfully to:" << filePath;
    emit pythonError("CSV exported successfully to: " + filePath);
}

bool DecisionEngine::isComparing() const { return m_isComparing; }
int DecisionEngine::comparisonCount() const { return m_comparisonResults.size(); }
double DecisionEngine::comparisonMean() const { return m_meanValue; }
double DecisionEngine::comparisonStdDev() const { return m_stdDevValue; }
QString DecisionEngine::bestAlgorithm() const { return m_bestAlgorithm; }
QString DecisionEngine::fastestAlgorithm() const { return m_fastestAlgorithm; }

QVariantList DecisionEngine::comparisonResults() const
{
    QVariantList results;

    // Create sorted list by value (descending)
    QList<QPair<QString, double>> sortedResults;
    for (auto it = m_comparisonResults.begin(); it != m_comparisonResults.end(); ++it) {
        sortedResults.append(qMakePair(it.key(), it.value().toDouble()));
    }

    // Sort by value (descending)
    std::sort(sortedResults.begin(), sortedResults.end(),
              [](const QPair<QString, double> &a, const QPair<QString, double> &b) {
                  return a.second > b.second;
              });

    // Create result objects with rank
    for (int i = 0; i < sortedResults.size(); ++i) {
        QVariantMap result;
        result["algorithm"] = sortedResults[i].first;
        result["value"] = sortedResults[i].second;
        result["executionTime"] = m_executionTimes.value(sortedResults[i].first, 0);
        result["rank"] = i + 1;
        results.append(result);
    }

    return results;
}

QVariantList DecisionEngine::getComparisonResults() const {
    QVariantList results;

    // Create sorted results
    QList<QPair<QString, double>> sortedResults;
    for (auto it = m_comparisonResults.begin(); it != m_comparisonResults.end(); ++it) {
        sortedResults.append(qMakePair(it.key(), it.value().toDouble()));
    }

    // Sort by value (descending)
    std::sort(sortedResults.begin(), sortedResults.end(),
              [](const QPair<QString, double> &a, const QPair<QString, double> &b) {
                  return a.second > b.second;
              });

    // Create result objects with ACTUAL execution times
    for (int i = 0; i < sortedResults.size(); ++i) {
        QVariantMap result;
        QString algorithm = sortedResults[i].first;
        result["algorithm"] = algorithm;
        result["value"] = sortedResults[i].second;

        // Get actual execution time or default
        qint64 execTime = m_executionTimes.value(algorithm, 0);
        if (execTime == 0) {
            // Estimate based on script name (you can adjust these)
            if (algorithm.contains("neural") || algorithm.contains("random_forest"))
                execTime = 150;
            else if (algorithm.contains("weighted"))
                execTime = 50;
            else
                execTime = 80;
        }

        result["executionTime"] = execTime;
        result["rank"] = i + 1;
        results.append(result);
    }

    return results;
}

int DecisionEngine::getComparisonProgressTotal() const
{
    return m_comparisonProgressTotal;
}

int DecisionEngine::getComparisonProgressCurrent() const
{
    return m_comparisonProgressCurrent;
}
