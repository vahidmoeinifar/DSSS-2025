#ifndef DECISIONENGINE_H
#define DECISIONENGINE_H

#include <QObject>
#include <QProcess>
#include <QVariantList>
#include <QVariantMap>
#include <QStringList>
#include <QElapsedTimer>
#include <QTime>
#include "HistoryManager.h"

class HistoryManager;

struct AgentData {
    double value;
    double confidence;

    AgentData(double v = 0.0, double c = 1.0) : value(v), confidence(c) {}

    bool operator==(const AgentData& other) const {
        return qFuzzyCompare(value, other.value) && qFuzzyCompare(confidence, other.confidence);
    }
};
struct ComparisonResult {
    QString algorithm;
    double value;
    double executionTime;
    int rank;
};
Q_DECLARE_METATYPE(AgentData)
Q_DECLARE_METATYPE(ComparisonResult)

class DecisionEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double fusedValue READ fusedValue NOTIFY fusedValueChanged)
    Q_PROPERTY(QString scriptBasePath READ scriptBasePath WRITE setScriptBasePath NOTIFY scriptBasePathChanged)
    Q_PROPERTY(bool isComparing READ isComparing NOTIFY isComparingChanged)
    Q_PROPERTY(int comparisonCount READ comparisonCount NOTIFY comparisonCountChanged)
    Q_PROPERTY(double comparisonMean READ comparisonMean NOTIFY comparisonStatsChanged)
    Q_PROPERTY(double comparisonStdDev READ comparisonStdDev NOTIFY comparisonStatsChanged)
    Q_PROPERTY(QString bestAlgorithm READ bestAlgorithm NOTIFY comparisonStatsChanged)
    Q_PROPERTY(QString fastestAlgorithm READ fastestAlgorithm NOTIFY comparisonStatsChanged)
    Q_PROPERTY(QVariantList comparisonModel READ getComparisonResults NOTIFY comparisonResultsChanged)
    Q_PROPERTY(int comparisonProgressCurrent READ getComparisonProgressCurrent NOTIFY comparisonProgressChanged)
    Q_PROPERTY(int comparisonProgressTotal READ getComparisonProgressTotal NOTIFY comparisonProgressChanged)


public:
    explicit DecisionEngine(QObject *parent = nullptr);
    ~DecisionEngine();

    Q_INVOKABLE HistoryManager* historyManager() const { return m_historyManager; }

    // Property getters
    double fusedValue() const;
    QString scriptBasePath() const;
    void setScriptBasePath(const QString &path);
    bool isComparing() const;
    int comparisonCount() const;
    double comparisonMean() const;
    double comparisonStdDev() const;
    QString bestAlgorithm() const;
    QString fastestAlgorithm() const;

    Q_INVOKABLE void addAgentValue(double value);
    Q_INVOKABLE void clearValues();
    Q_INVOKABLE void runFusion(const QVariantList &agentValues);
    Q_INVOKABLE void runFusionWithConfidence(const QVariantList &agentValues, const QVariantList &confidences);
    Q_INVOKABLE void runFusion(const QVariantList &agentValues, const QString &scriptName);
    Q_INVOKABLE void runFusionWithConfidence(const QVariantList &agentValues,
                                             const QVariantList &confidences,
                                             const QString &scriptName);
    Q_INVOKABLE void runComparison(const QVariantList &agentValues, const QStringList &scripts);
    Q_INVOKABLE void runComparisonWithConfidence(const QVariantList &agentValues,
                                                 const QVariantList &confidences,
                                                 const QStringList &scripts);
    Q_INVOKABLE QStringList availableScripts() const;
    Q_INVOKABLE bool validateScript(const QString &scriptName) const;
    Q_INVOKABLE void exportComparisonCSV(const QString &filePath);
    Q_INVOKABLE QVariantList getAgentsWithConfidence() const;
    Q_INVOKABLE double getAgentConfidence(int index) const;
    Q_INVOKABLE void setAgentConfidence(int index, double confidence);
    Q_INVOKABLE QVariantList getComparisonResults() const;
    Q_INVOKABLE QVariantList comparisonResults() const;
    Q_INVOKABLE void addAgent(double value, double confidence = 1.0);
    Q_INVOKABLE void updateAgentConfidence(int index, double confidence);

    void finishComparison();
    int getComparisonProgressTotal() const;
    int getComparisonProgressCurrent() const;

signals:
    void fusedValueChanged();
    void pythonError(const QString &error);
    void scriptBasePathChanged();
    void isComparingChanged();
    void comparisonCountChanged();
    void comparisonProgress(int current, int total);
    void comparisonFinished();
    void comparisonStatsChanged();
    void comparisonResultsChanged();
    void agentsChanged();
    void agentConfidenceChanged(int index);
    void comparisonProgressChanged();

private slots:
    void onPythonFinished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    double m_fusedValue;
    QProcess *m_python;
    QString m_scriptBasePath;
    QVariantList m_agentValues;
    QByteArray m_pythonOutput;
    QList<AgentData> m_agents;
    QMap<QString, qint64> m_executionTimes;
    QElapsedTimer m_executionTimer;
    QMap<QString, QTime> m_startTimes;
    QVariantList m_agentConfidences;
    // Comparison state
    bool m_isComparing;
    QStringList m_pendingScripts;
    QString m_currentScript;
    QVariantMap m_comparisonResults;  // scriptName -> fusedValue

    // Helper methods
    void startComparison();
    void updateComparisonStats();

    // Statistics
    double m_meanValue;
    double m_stdDevValue;
    QString m_bestAlgorithm;
    QString m_fastestAlgorithm;
    int m_comparisonProgressTotal;
    int m_comparisonProgressCurrent;

    QJsonObject createJsonForPython(const QVariantList &values,
                                    const QVariantList &confidences = QVariantList());
    void sendToPython(const QJsonObject &jsonData, const QString &scriptName);
    HistoryManager* m_historyManager;
    QString m_currentFusionScript;
    QVariantList m_currentAgentConfidences;
    QString m_currentSingleScript;  // For single fusion tracking


};

#endif // DECISIONENGINE_H
