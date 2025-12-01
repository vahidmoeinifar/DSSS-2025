#include "DecisionEngine.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

DecisionEngine::DecisionEngine(QObject *parent)
    : QObject(parent),
    m_fusedValue(0.0),
    m_python(new QProcess(this))
{
    connect(m_python, &QProcess::finished,
            this, &DecisionEngine::onPythonFinished);
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
    if (agentValues.isEmpty()) {
        emit pythonError("No agent data!");
        return;
    }

    // Store values internally if needed
    m_agentValues = agentValues;

    QJsonArray arr;
    for (const QVariant &v : agentValues)
        arr.append(v.toDouble());

    QJsonObject root;
    root["values"] = arr;

    QByteArray inputData = QJsonDocument(root).toJson();

    // Prepare Python call
    m_python->setProgram("python");
    m_python->setArguments({"fuse.py"});
    m_python->start();

    // Send JSON into python stdin
    m_python->write(inputData);
    m_python->closeWriteChannel();
}

void DecisionEngine::onPythonFinished(int exitCode, QProcess::ExitStatus status)
{
    if (status != QProcess::NormalExit) {
        emit pythonError("Python crashed.");
        return;
    }

    QByteArray output = m_python->readAllStandardOutput();
    QJsonDocument doc = QJsonDocument::fromJson(output);

    if (!doc.isObject()) {
        emit pythonError("Python returned invalid JSON.");
        return;
    }

    m_fusedValue = doc["fused"].toDouble();
    emit fusedValueChanged();
}

double DecisionEngine::fusedValue() const
{
    return m_fusedValue;
}
