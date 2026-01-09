#ifndef DECISIONENGINE_H
#define DECISIONENGINE_H

#include <QObject>
#include <QProcess>
#include <QVariantList>
#include <QVariantMap>
#include <QStringList>
#include <QElapsedTimer>

// Forward declaration for comparison result struct
struct ComparisonResult {
    QString algorithm;
    double value;
    double executionTime;
    int rank;
};
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
    Q_INVOKABLE void runFusion(const QVariantList &agentValues, const QString &scriptName);
    Q_INVOKABLE void runComparison(const QVariantList &agentValues, const QStringList &scripts);
    Q_INVOKABLE QStringList availableScripts() const;
    Q_INVOKABLE bool validateScript(const QString &scriptName) const;
    Q_INVOKABLE void exportComparisonCSV(const QString &filePath);

    // For QML model access
    Q_INVOKABLE QVariantList getComparisonResults() const;

    Q_INVOKABLE QVariantList comparisonResults() const;

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

    void comparisonProgressChanged();

private slots:
    void onPythonFinished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    double m_fusedValue;
    QProcess *m_python;
    QString m_scriptBasePath;
    QVariantList m_agentValues;
    QByteArray m_pythonOutput;

    QMap<QString, qint64> m_executionTimes;
    QElapsedTimer m_executionTimer;
    QMap<QString, QTime> m_startTimes;

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

};

#endif // DECISIONENGINE_H
