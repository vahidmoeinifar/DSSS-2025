#ifndef DECISIONENGINE_H
#define DECISIONENGINE_H

#include <QObject>
#include <QVariantList>
#include <QProcess>

class DecisionEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double fusedValue READ fusedValue NOTIFY fusedValueChanged)

public:
    explicit DecisionEngine(QObject *parent = nullptr);

    Q_INVOKABLE void addAgentValue(double value);
    Q_INVOKABLE void clearValues();
    Q_INVOKABLE void runFusion();

    double fusedValue() const;

signals:
    void fusedValueChanged();
    void pythonError(QString msg);

private slots:
    void onPythonFinished(int exitCode, QProcess::ExitStatus status);

private:
    QVariantList m_agentValues;
    double m_fusedValue;

    QProcess *m_python;
};

#endif // DECISIONENGINE_H
