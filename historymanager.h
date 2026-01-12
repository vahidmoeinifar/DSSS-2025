#ifndef HISTORYMANAGER_H
#define HISTORYMANAGER_H

#include <QObject>
#include <QDateTime>
#include <QVariantList>
#include <QVariantMap>
#include <QString>
#include <QFile>
#include <QTextStream>
#include <QDir>

// Log levels
enum LogLevel {
    LOG_INFO,
    LOG_WARNING,
    LOG_ERROR,
    LOG_DEBUG
};

// History entry structure
struct HistoryEntry {
    QString id;
    QDateTime timestamp;
    QVariantList agents;
    QVariantList confidences;
    QString algorithm;
    double result;
    double confidence;
    double executionTime;
    QString notes;
    QString status;
    QString errorMessage;

    // Convert to QVariantMap for QML
    QVariantMap toVariantMap() const {
        QVariantMap map;
        map["id"] = id;
        map["timestamp"] = timestamp.toString("yyyy-MM-dd HH:mm:ss");
        map["timestamp_iso"] = timestamp.toString(Qt::ISODate);
        map["algorithm"] = algorithm;
        map["result"] = result;
        map["confidence"] = confidence;
        map["executionTime"] = executionTime;
        map["agentCount"] = agents.size();
        map["agents"] = agents;
        map["confidences"] = confidences;
        map["notes"] = notes;
        map["status"] = status;
        map["errorMessage"] = errorMessage;
        return map;
    }
};

class HistoryManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList historyEntries READ getHistoryEntries NOTIFY historyChanged)
    Q_PROPERTY(int entryCount READ getEntryCount NOTIFY historyChanged)
    Q_PROPERTY(bool loggingEnabled READ isLoggingEnabled WRITE setLoggingEnabled NOTIFY loggingEnabledChanged)

public:
    explicit HistoryManager(QObject *parent = nullptr);
    ~HistoryManager();

    // Configuration
    void setHistoryFilePath(const QString &path);
    void setLogFilePath(const QString &path);
    void setMaxHistoryEntries(int maxEntries);

    // History management
    Q_INVOKABLE void saveFusionResult(const QVariantList &agents,
                                      const QVariantList &confidences,
                                      const QString &algorithm,
                                      double result,
                                      double confidence = 1.0,
                                      double executionTime = 0.0,
                                      const QString &notes = "");

    Q_INVOKABLE void saveErrorResult(const QVariantList &agents,
                                     const QVariantList &confidences,
                                     const QString &algorithm,
                                     const QString &errorMessage,
                                     double executionTime = 0.0);

    Q_INVOKABLE QVariantList getHistoryEntries() const;
    Q_INVOKABLE QVariantMap getEntry(const QString &id) const;
    Q_INVOKABLE void clearHistory();
    Q_INVOKABLE void removeEntry(const QString &id);

    // Logging
    Q_INVOKABLE void log(LogLevel level, const QString &message, const QString &context = "");
    Q_INVOKABLE void logInfo(const QString &message, const QString &context = "");
    Q_INVOKABLE void logWarning(const QString &message, const QString &context = "");
    Q_INVOKABLE void logError(const QString &message, const QString &context = "");
    Q_INVOKABLE void logDebug(const QString &message, const QString &context = "");

    Q_INVOKABLE QString getLogs(int maxLines = 100) const;
    Q_INVOKABLE void clearLogs();

    // Export/Import
    Q_INVOKABLE bool exportHistoryToJson(const QString &filePath);
    Q_INVOKABLE bool exportHistoryToCsv(const QString &filePath);
    Q_INVOKABLE bool importHistoryFromJson(const QString &filePath);

    // Statistics
    Q_INVOKABLE QVariantMap getStatistics() const;
    Q_INVOKABLE double getAverageResult() const;
    Q_INVOKABLE QVariantMap getAlgorithmStatistics() const;

    // Property getters
    int getEntryCount() const;
    bool isLoggingEnabled() const;
    void setLoggingEnabled(bool enabled);

signals:
    void historyChanged();
    void newEntryAdded(const QVariantMap &entry);
    void entryRemoved(const QString &id);
    void historyCleared();

    void logAdded(const QString &logLine);
    void loggingEnabledChanged();

private:
    // File operations
    bool loadHistoryFromFile();
    bool saveHistoryToFile();
    void appendToLogFile(const QString &logLine);

    // Helper methods
    QString generateId() const;
    QString logLevelToString(LogLevel level) const;
    QString getLogLevelColor(LogLevel level) const;

    // Data storage
    QList<HistoryEntry> m_entries;
    QString m_historyFilePath;
    QString m_logFilePath;
    int m_maxEntries;
    bool m_loggingEnabled;

    // Default paths
    static const QString DEFAULT_HISTORY_FILE;
    static const QString DEFAULT_LOG_FILE;
    static const int DEFAULT_MAX_ENTRIES = 1000;
};

#endif // HISTORYMANAGER_H
