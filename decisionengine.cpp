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
    m_comparisonProgressTotal(0)
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
}

void DecisionEngine::addAgentValue(double value)
{
    m_agentValues.append(value);
}

void DecisionEngine::clearValues()
{
    m_agentValues.clear();
    m_fusedValue = 0.0;
    emit fusedValueChanged();
}

void DecisionEngine::runFusion(const QVariantList &agentValues)
{
    // Use default script if none specified
    runFusion(agentValues, "neural.py");
}

void DecisionEngine::runFusion(const QVariantList &agentValues, const QString &scriptName)
{
    if (agentValues.isEmpty()) {
        emit pythonError("No agent data!");
        return;
    }

    if (m_isComparing && !scriptName.isEmpty()) {
        m_startTimes[scriptName] = QTime::currentTime();
    }

    // Check if a process is already running
    if (m_python->state() == QProcess::Running) {
        emit pythonError("Python process is already running. Please wait.");
        return;
    }

    // Store values internally if needed
    m_agentValues = agentValues;

    // Clear previous output
    m_pythonOutput.clear();

    QJsonArray arr;
    for (const QVariant &v : agentValues)
        arr.append(v.toDouble());

    QJsonObject root;
    root["values"] = arr;
    root["agent_count"] = static_cast<int>(agentValues.size());

    QByteArray inputData = QJsonDocument(root).toJson();
    qDebug() << "Sending to Python:" << inputData;

    QString scriptPath;

    // Check if scriptName is an absolute path or relative path
    QFileInfo scriptFile(scriptName);

    if (scriptFile.isAbsolute()) {
        // It's an absolute path (custom script)
        scriptPath = scriptName;
    } else {
        // It's a relative path (built-in script)
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

    // Prepare arguments - FIXED: Don't quote the path, just pass it directly
    QStringList arguments;
    arguments << scriptPath;

    qDebug() << "Python arguments:" << arguments;
    m_python->setArguments(arguments);

    // Start the process - FIXED: This line had the error
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

void DecisionEngine::onPythonFinished(int exitCode, QProcess::ExitStatus status)
{
    qDebug() << "Python process finished. Exit code:" << exitCode << "Status:" << status;

    if (status != QProcess::NormalExit) {
        if (m_isComparing) {
            // Handle error during comparison
            if (!m_currentScript.isEmpty()) {
                // Calculate execution time for failed script
                qint64 execTime = 100;
                if (m_startTimes.contains(m_currentScript)) {
                    QTime startTime = m_startTimes[m_currentScript];
                    QTime endTime = QTime::currentTime();
                    execTime = startTime.msecsTo(endTime);
                    m_startTimes.remove(m_currentScript);
                }
                m_executionTimes[m_currentScript] = execTime;
                m_comparisonResults.insert(m_currentScript, QVariant::fromValue(0.0));

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
            emit pythonError("Python script crashed during comparison.");
        } else {
            emit pythonError("Python script crashed.");
        }
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

        if (m_isComparing && !m_currentScript.isEmpty()) {
            // Handle error but continue comparison
            qint64 execTime = 100;
            if (m_startTimes.contains(m_currentScript)) {
                QTime startTime = m_startTimes[m_currentScript];
                QTime endTime = QTime::currentTime();
                execTime = startTime.msecsTo(endTime);
                m_startTimes.remove(m_currentScript);
            }

            m_executionTimes[m_currentScript] = execTime;
            m_comparisonResults.insert(m_currentScript, QVariant::fromValue(0.0));

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
            emit pythonError(QString("Python script exited with code %1. Error: %2").arg(exitCode).arg(error));
        }
        return;
    }

    // Check for empty output
    if (m_pythonOutput.isEmpty()) {
        if (m_isComparing && !m_currentScript.isEmpty()) {
            // Handle empty output but continue comparison
            qint64 execTime = 100;
            if (m_startTimes.contains(m_currentScript)) {
                QTime startTime = m_startTimes[m_currentScript];
                QTime endTime = QTime::currentTime();
                execTime = startTime.msecsTo(endTime);
                m_startTimes.remove(m_currentScript);
            }

            m_executionTimes[m_currentScript] = execTime;
            m_comparisonResults.insert(m_currentScript, QVariant::fromValue(0.0));

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
            emit pythonError("Python script returned no output.");
        }
        return;
    }

    qDebug() << "Python full output:" << m_pythonOutput;

    // Parse JSON response
    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(m_pythonOutput, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        if (m_isComparing && !m_currentScript.isEmpty()) {
            // Handle JSON parse error but continue comparison
            qint64 execTime = 100;
            if (m_startTimes.contains(m_currentScript)) {
                QTime startTime = m_startTimes[m_currentScript];
                QTime endTime = QTime::currentTime();
                execTime = startTime.msecsTo(endTime);
                m_startTimes.remove(m_currentScript);
            }

            m_executionTimes[m_currentScript] = execTime;
            m_comparisonResults.insert(m_currentScript, QVariant::fromValue(0.0));

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
            emit pythonError(QString("Failed to parse JSON from Python: %1").arg(parseError.errorString()));
        }
        return;
    }

    if (!doc.isObject()) {
        if (m_isComparing && !m_currentScript.isEmpty()) {
            // Handle invalid JSON but continue comparison
            qint64 execTime = 100;
            if (m_startTimes.contains(m_currentScript)) {
                QTime startTime = m_startTimes[m_currentScript];
                QTime endTime = QTime::currentTime();
                execTime = startTime.msecsTo(endTime);
                m_startTimes.remove(m_currentScript);
            }

            m_executionTimes[m_currentScript] = execTime;
            m_comparisonResults.insert(m_currentScript, QVariant::fromValue(0.0));

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
            emit pythonError("Python did not return a valid JSON object.");
        }
        return;
    }

    QJsonObject result = doc.object();

    double fusedValue = 0.0;
    if (result.contains("fused")) {
        QJsonValue fusedJson = result["fused"];
        if (fusedJson.isDouble()) {
            fusedValue = fusedJson.toDouble();
        }
    }

    // Handle successful completion
    if (m_isComparing && !m_currentScript.isEmpty()) {
        // Calculate actual execution time
        qint64 execTime = 100; // Default fallback

        if (m_startTimes.contains(m_currentScript)) {
            QTime startTime = m_startTimes[m_currentScript];
            QTime endTime = QTime::currentTime();
            execTime = startTime.msecsTo(endTime);
            m_startTimes.remove(m_currentScript);
            qDebug() << "Script" << m_currentScript << "execution time:" << execTime << "ms";
        }

        // Store actual execution time
        m_executionTimes[m_currentScript] = execTime;

        // Store result
        m_comparisonResults.insert(m_currentScript, QVariant::fromValue(fusedValue));

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

void DecisionEngine::runComparison(const QVariantList &agentValues,
                                   const QStringList &scripts)
{
    if (agentValues.isEmpty() || scripts.isEmpty()) {
        emit pythonError("No agents or scripts provided for comparison.");
        return;
    }

    if (m_python->state() == QProcess::Running) {
        emit pythonError("Python process already running.");
        return;
    }

    // Reset comparison state
    m_isComparing = true;
    emit isComparingChanged();

    m_agentValues = agentValues;
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
    runFusion(agentValues, m_currentScript);
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
