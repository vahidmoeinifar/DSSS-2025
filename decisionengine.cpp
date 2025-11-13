#include "DecisionEngine.h"

DecisionEngine::DecisionEngine(QObject *parent)
    : QObject(parent), m_fusedValue(0.0)
{
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

void DecisionEngine::computeFusion()
{
    if (m_agentValues.isEmpty())
        return;

    double sum = 0.0;
    for (const auto &v : m_agentValues)
        sum += v.toDouble();

    m_fusedValue = sum / m_agentValues.size();
    emit fusedValueChanged();
}

double DecisionEngine::fusedValue() const
{
    return m_fusedValue;
}
