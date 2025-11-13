#ifndef DECISIONENGINE_H
#define DECISIONENGINE_H

#include <QObject>
#include <QVariantList>

class DecisionEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double fusedValue READ fusedValue NOTIFY fusedValueChanged)

public:
    explicit DecisionEngine(QObject *parent = nullptr);

    Q_INVOKABLE void addAgentValue(double value);
    Q_INVOKABLE void clearValues();
    Q_INVOKABLE void computeFusion();

    double fusedValue() const;

signals:
    void fusedValueChanged();

private:
    QVariantList m_agentValues;
    double m_fusedValue;
};

#endif // DECISIONENGINE_H
