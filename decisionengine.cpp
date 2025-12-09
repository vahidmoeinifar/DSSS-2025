#include "DecisionEngine.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QFileInfo>
#include <QDir>
#include <QFile>

DecisionEngine::DecisionEngine(QObject *parent)
    : QObject(parent),
    m_fusedValue(0.0),
    m_python(new QProcess(this)),
    m_scriptBasePath("C:/Users/Karabey/Documents/DSSS-2025/scripts/")
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
        emit pythonError("Python script crashed.");
        return;
    }

    // Read any remaining output
    m_pythonOutput.append(m_python->readAllStandardOutput());

    if (exitCode != 0) {
        QString error = QString::fromUtf8(m_python->readAllStandardError());
        if (error.isEmpty()) {
            error = "Unknown error";
        }
        emit pythonError(QString("Python script exited with code %1. Error: %2").arg(exitCode).arg(error));
        return;
    }

    if (m_pythonOutput.isEmpty()) {
        emit pythonError("Python script returned no output.");
        return;
    }

    qDebug() << "Python full output:" << m_pythonOutput;

    // Parse JSON response
    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(m_pythonOutput, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        emit pythonError(QString("Failed to parse JSON from Python: %1").arg(parseError.errorString()));
        return;
    }

    if (!doc.isObject()) {
        emit pythonError("Python did not return a valid JSON object.");
        return;
    }

    QJsonObject result = doc.object();

    if (!result.contains("fused")) {
        emit pythonError("Python result does not contain 'fused' field.");
        return;
    }

    // Get fused value
    QJsonValue fusedValue = result["fused"];
    if (!fusedValue.isDouble()) {
        emit pythonError("'fused' field is not a valid number.");
        return;
    }

    m_fusedValue = fusedValue.toDouble();
    emit fusedValueChanged();

    // Clear output for next run
    m_pythonOutput.clear();

    qDebug() << "Fusion successful. Result:" << m_fusedValue;
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
