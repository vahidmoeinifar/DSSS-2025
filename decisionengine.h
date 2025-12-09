#ifndef DECISIONENGINE_H
#define DECISIONENGINE_H

#include <QObject>
#include <QProcess>
#include <QVariantList>

class DecisionEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double fusedValue READ fusedValue NOTIFY fusedValueChanged)
    Q_PROPERTY(QString scriptBasePath READ scriptBasePath WRITE setScriptBasePath NOTIFY scriptBasePathChanged)

public:
    explicit DecisionEngine(QObject *parent = nullptr);

    double fusedValue() const;
    QString scriptBasePath() const;
    void setScriptBasePath(const QString &path);

    Q_INVOKABLE void addAgentValue(double value);
    Q_INVOKABLE void clearValues();
    Q_INVOKABLE void runFusion(const QVariantList &agentValues);
    Q_INVOKABLE void runFusion(const QVariantList &agentValues, const QString &scriptName);
    Q_INVOKABLE QStringList availableScripts() const;
    Q_INVOKABLE bool validateScript(const QString &scriptName) const;

signals:
    void fusedValueChanged();
    void pythonError(const QString &message);
    void scriptBasePathChanged();

private slots:
    void onPythonFinished(int exitCode, QProcess::ExitStatus status);

private:
    double m_fusedValue;
    QVariantList m_agentValues;
    QProcess *m_python;
    QByteArray m_pythonOutput;
    QString m_scriptBasePath;
};

#endif // DECISIONENGINE_H
