#include "HistoryManager.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>
#include <QUuid>
#include <QStandardPaths>
#include <QDateTime>
#include <algorithm>
#include <cmath>

// Default file paths
const QString HistoryManager::DEFAULT_HISTORY_FILE = "gdss_history.json";
const QString HistoryManager::DEFAULT_LOG_FILE = "gdss_log.txt";

HistoryManager::HistoryManager(QObject *parent)
    : QObject(parent),
    m_maxEntries(DEFAULT_MAX_ENTRIES),
    m_loggingEnabled(true)
{
    // Set default file paths in user's documents folder
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QDir documentsDir(documentsPath);

    // Create GDSS folder if it doesn't exist
    QString gdssFolder = documentsDir.filePath("GDSS");
    if (!documentsDir.exists("GDSS")) {
        documentsDir.mkdir("GDSS");
    }

    m_historyFilePath = QDir(gdssFolder).filePath(DEFAULT_HISTORY_FILE);
    m_logFilePath = QDir(gdssFolder).filePath(DEFAULT_LOG_FILE);

    // Load existing history
    loadHistoryFromFile();

    // Log startup
    logInfo("HistoryManager initialized", "System");
}

HistoryManager::~HistoryManager()
{
    // Save history before destruction
    saveHistoryToFile();
}

// Configuration methods
void HistoryManager::setHistoryFilePath(const QString &path)
{
    if (m_historyFilePath != path) {
        saveHistoryToFile();

        m_historyFilePath = path;
        loadHistoryFromFile();
    }
}

void HistoryManager::setLogFilePath(const QString &path)
{
    m_logFilePath = path;
}

void HistoryManager::setMaxHistoryEntries(int maxEntries)
{
    m_maxEntries = qMax(100, maxEntries); // Minimum 100 entries

    // Trim if we have more entries than the new limit
    if (m_entries.size() > m_maxEntries) {
        m_entries = m_entries.mid(m_entries.size() - m_maxEntries);
        saveHistoryToFile();
        emit historyChanged();
    }
}

// History management
void HistoryManager::saveFusionResult(const QVariantList &agents,
                                      const QVariantList &confidences,
                                      const QString &algorithm,
                                      double result,
                                      double confidence,
                                      double executionTime,
                                      const QString &notes)
{
    HistoryEntry entry;
    entry.id = generateId();
    entry.timestamp = QDateTime::currentDateTime();
    entry.agents = agents;
    entry.confidences = confidences;
    entry.algorithm = algorithm;
    entry.result = result;
    entry.confidence = confidence;
    entry.executionTime = executionTime;
    entry.notes = notes;
    entry.status = "success";
    entry.errorMessage = "";

    // Add to history
    m_entries.append(entry);

    // Trim if exceeding max entries
    if (m_entries.size() > m_maxEntries) {
        m_entries.removeFirst();
    }

    // Save to file
    saveHistoryToFile();

    // Log the operation
    logInfo(QString("Fusion completed: %1 with %2 agents, result: %3")
                .arg(algorithm)
                .arg(agents.size())
                .arg(result, 0, 'f', 4),
            "Fusion");

    // Emit signals
    emit historyChanged();
    emit newEntryAdded(entry.toVariantMap());
}

void HistoryManager::saveErrorResult(const QVariantList &agents,
                                     const QVariantList &confidences,
                                     const QString &algorithm,
                                     const QString &errorMessage,
                                     double executionTime)
{
    HistoryEntry entry;
    entry.id = generateId();
    entry.timestamp = QDateTime::currentDateTime();
    entry.agents = agents;
    entry.confidences = confidences;
    entry.algorithm = algorithm;
    entry.result = 0.0;
    entry.confidence = 0.0;
    entry.executionTime = executionTime;
    entry.notes = "";
    entry.status = "error";
    entry.errorMessage = errorMessage;

    // Add to history
    m_entries.append(entry);

    // Trim if exceeding max entries
    if (m_entries.size() > m_maxEntries) {
        m_entries.removeFirst();
    }

    // Save to file
    saveHistoryToFile();

    // Log the error
    logError(QString("Fusion failed: %1 - %2")
                 .arg(algorithm)
                 .arg(errorMessage),
             "Fusion");

    // Emit signals
    emit historyChanged();
    emit newEntryAdded(entry.toVariantMap());
}

QVariantList HistoryManager::getHistoryEntries() const
{
    QVariantList entries;

    // Return in reverse chronological order (newest first)
    for (int i = m_entries.size() - 1; i >= 0; --i) {
        entries.append(m_entries[i].toVariantMap());
    }

    return entries;
}

QVariantMap HistoryManager::getEntry(const QString &id) const
{
    for (const HistoryEntry &entry : m_entries) {
        if (entry.id == id) {
            return entry.toVariantMap();
        }
    }
    return QVariantMap();
}

void HistoryManager::clearHistory()
{
    m_entries.clear();
    saveHistoryToFile();

    logInfo("History cleared", "History");
    emit historyCleared();
    emit historyChanged();
}

void HistoryManager::removeEntry(const QString &id)
{
    for (int i = 0; i < m_entries.size(); ++i) {
        if (m_entries[i].id == id) {
            m_entries.removeAt(i);
            saveHistoryToFile();

            logInfo(QString("Removed history entry: %1").arg(id), "History");
            emit entryRemoved(id);
            emit historyChanged();
            return;
        }
    }
}

// Logging methods
void HistoryManager::log(LogLevel level, const QString &message, const QString &context)
{
    if (!m_loggingEnabled && level != LOG_ERROR) {
        return; // Only log errors when disabled
    }

    QString timestamp = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss.zzz");
    QString levelStr = logLevelToString(level);
    QString logLine;

    if (context.isEmpty()) {
        logLine = QString("[%1] [%2] %3")
        .arg(timestamp)
            .arg(levelStr)
            .arg(message);
    } else {
        logLine = QString("[%1] [%2] [%3] %4")
        .arg(timestamp)
            .arg(levelStr)
            .arg(context)
            .arg(message);
    }

    // Console output (with colors for terminals that support it)
    QString coloredLog = QString("%1%2%3")
                             .arg(getLogLevelColor(level))
                             .arg(logLine)
                             .arg("\033[0m"); // Reset color

    qDebug().noquote() << coloredLog;

    // Append to log file
    appendToLogFile(logLine);

    // Emit signal for UI
    emit logAdded(logLine);
}

void HistoryManager::logInfo(const QString &message, const QString &context)
{
    log(LOG_INFO, message, context);
}

void HistoryManager::logWarning(const QString &message, const QString &context)
{
    log(LOG_WARNING, message, context);
}

void HistoryManager::logError(const QString &message, const QString &context)
{
    log(LOG_ERROR, message, context);
}

void HistoryManager::logDebug(const QString &message, const QString &context)
{
    log(LOG_DEBUG, message, context);
}

QString HistoryManager::getLogs(int maxLines) const
{
    QFile logFile(m_logFilePath);
    if (!logFile.exists()) {
        return "No log file found.";
    }

    if (!logFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return QString("Cannot open log file: %1").arg(logFile.errorString());
    }

    QTextStream in(&logFile);
    QStringList lines;

    while (!in.atEnd()) {
        lines.append(in.readLine());
    }

    logFile.close();

    // Return the last maxLines
    int start = qMax(0, lines.size() - maxLines);
    QStringList recentLines = lines.mid(start);

    return recentLines.join("\n");
}

void HistoryManager::clearLogs()
{
    QFile logFile(m_logFilePath);
    if (logFile.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text)) {
        QTextStream out(&logFile);
        out << QString("[%1] Log file cleared\n")
                   .arg(QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss"));
        logFile.close();
    }

    logInfo("Logs cleared", "System");
    emit logAdded("[Logs cleared]");
}

// Export/Import methods
bool HistoryManager::exportHistoryToJson(const QString &filePath)
{
    QJsonArray entriesArray;

    for (const HistoryEntry &entry : m_entries) {
        QJsonObject entryObj;
        entryObj["id"] = entry.id;
        entryObj["timestamp"] = entry.timestamp.toString(Qt::ISODate);
        entryObj["algorithm"] = entry.algorithm;
        entryObj["result"] = entry.result;
        entryObj["confidence"] = entry.confidence;
        entryObj["executionTime"] = entry.executionTime;
        entryObj["agentCount"] = entry.agents.size();
        entryObj["status"] = entry.status;
        entryObj["errorMessage"] = entry.errorMessage;
        entryObj["notes"] = entry.notes;

        // Add agents array
        QJsonArray agentsArray;
        for (const QVariant &agent : entry.agents) {
            agentsArray.append(agent.toDouble());
        }
        entryObj["agents"] = agentsArray;

        // Add confidences array
        QJsonArray confidencesArray;
        for (const QVariant &confidence : entry.confidences) {
            confidencesArray.append(confidence.toDouble());
        }
        entryObj["confidences"] = confidencesArray;

        entriesArray.append(entryObj);
    }

    QJsonObject root;
    root["version"] = "1.0";
    root["exportDate"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    root["totalEntries"] = m_entries.size();
    root["entries"] = entriesArray;

    QJsonDocument doc(root);

    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        logError(QString("Cannot export history: %1").arg(file.errorString()), "Export");
        return false;
    }

    file.write(doc.toJson(QJsonDocument::Indented));
    file.close();

    logInfo(QString("History exported to: %1 (%2 entries)")
                .arg(filePath)
                .arg(m_entries.size()),
            "Export");

    return true;
}
bool HistoryManager::exportHistoryToCsv(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        logError(QString("Cannot export CSV: %1").arg(file.errorString()), "Export");
        return false;
    }

    QTextStream out(&file);

    // Write CSV header
    out << "Timestamp,Algorithm,Result,Confidence,ExecutionTime(ms),AgentCount,Status,ErrorMessage,Notes\n";

    // Write data
    for (const HistoryEntry &entry : m_entries) {
        // Escape quotes in strings for CSV
        QString errorMsg = entry.errorMessage;
        QString notes = entry.notes;

        // Replace single quotes with two single quotes for CSV
        errorMsg.replace("\"", "\"\"");
        notes.replace("\"", "\"\"");

        QString line = QString("\"%1\",\"%2\",%3,%4,%5,%6,\"%7\",\"%8\",\"%9\"\n")
                           .arg(entry.timestamp.toString("yyyy-MM-dd HH:mm:ss"))
                           .arg(entry.algorithm)
                           .arg(entry.result, 0, 'f', 6)
                           .arg(entry.confidence, 0, 'f', 4)
                           .arg(entry.executionTime, 0, 'f', 2)
                           .arg(entry.agents.size())
                           .arg(entry.status)
                           .arg(errorMsg)
                           .arg(notes);

        out << line;
    }

    file.close();

    logInfo(QString("History exported to CSV: %1 (%2 entries)")
                .arg(filePath)
                .arg(m_entries.size()),
            "Export");

    return true;
}
bool HistoryManager::importHistoryFromJson(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        logError(QString("Cannot import history: %1").arg(file.errorString()), "Import");
        return false;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        logError(QString("JSON parse error: %1").arg(parseError.errorString()), "Import");
        return false;
    }

    if (!doc.isObject()) {
        logError("Invalid JSON format", "Import");
        return false;
    }

    QJsonObject root = doc.object();
    QJsonArray entriesArray = root["entries"].toArray();

    QList<HistoryEntry> importedEntries;

    for (const QJsonValue &entryValue : entriesArray) {
        QJsonObject entryObj = entryValue.toObject();

        HistoryEntry entry;
        entry.id = entryObj["id"].toString(generateId());
        entry.timestamp = QDateTime::fromString(entryObj["timestamp"].toString(), Qt::ISODate);
        entry.algorithm = entryObj["algorithm"].toString();
        entry.result = entryObj["result"].toDouble();
        entry.confidence = entryObj["confidence"].toDouble(1.0);
        entry.executionTime = entryObj["executionTime"].toDouble();
        entry.status = entryObj["status"].toString("success");
        entry.errorMessage = entryObj["errorMessage"].toString();
        entry.notes = entryObj["notes"].toString();

        // Parse agents
        QJsonArray agentsArray = entryObj["agents"].toArray();
        for (const QJsonValue &agentValue : agentsArray) {
            entry.agents.append(agentValue.toDouble());
        }

        // Parse confidences
        QJsonArray confidencesArray = entryObj["confidences"].toArray();
        for (const QJsonValue &confidenceValue : confidencesArray) {
            entry.confidences.append(confidenceValue.toDouble(1.0));
        }

        importedEntries.append(entry);
    }

    // Add imported entries
    m_entries.append(importedEntries);

    // Trim if exceeding max entries
    if (m_entries.size() > m_maxEntries) {
        m_entries = m_entries.mid(m_entries.size() - m_maxEntries);
    }

    // Save to file
    saveHistoryToFile();

    logInfo(QString("Imported %1 entries from: %2")
                .arg(importedEntries.size())
                .arg(filePath),
            "Import");

    emit historyChanged();
    return true;
}

// Statistics methods
QVariantMap HistoryManager::getStatistics() const
{
    QVariantMap stats;

    if (m_entries.isEmpty()) {
        stats["totalEntries"] = 0;
        stats["successCount"] = 0;
        stats["errorCount"] = 0;
        stats["averageResult"] = 0.0;
        stats["averageConfidence"] = 0.0;
        stats["averageExecutionTime"] = 0.0;
        return stats;
    }

    int successCount = 0;
    int errorCount = 0;
    double totalResult = 0.0;
    double totalConfidence = 0.0;
    double totalExecutionTime = 0.0;

    for (const HistoryEntry &entry : m_entries) {
        if (entry.status == "success") {
            successCount++;
            totalResult += entry.result;
            totalConfidence += entry.confidence;
            totalExecutionTime += entry.executionTime;
        } else {
            errorCount++;
        }
    }

    stats["totalEntries"] = m_entries.size();
    stats["successCount"] = successCount;
    stats["errorCount"] = errorCount;
    stats["successRate"] = successCount * 100.0 / m_entries.size();

    if (successCount > 0) {
        stats["averageResult"] = totalResult / successCount;
        stats["averageConfidence"] = totalConfidence / successCount;
        stats["averageExecutionTime"] = totalExecutionTime / successCount;
    } else {
        stats["averageResult"] = 0.0;
        stats["averageConfidence"] = 0.0;
        stats["averageExecutionTime"] = 0.0;
    }

    // Date range
    if (!m_entries.isEmpty()) {
        stats["firstEntry"] = m_entries.first().timestamp.toString("yyyy-MM-dd");
        stats["lastEntry"] = m_entries.last().timestamp.toString("yyyy-MM-dd");
    }

    return stats;
}

double HistoryManager::getAverageResult() const
{
    if (m_entries.isEmpty()) return 0.0;

    double total = 0.0;
    int count = 0;

    for (const HistoryEntry &entry : m_entries) {
        if (entry.status == "success") {
            total += entry.result;
            count++;
        }
    }

    return count > 0 ? total / count : 0.0;
}

QVariantMap HistoryManager::getAlgorithmStatistics() const
{
    QVariantMap algoStats;
    QMap<QString, QVariantMap> algorithmData;

    for (const HistoryEntry &entry : m_entries) {
        if (entry.status != "success") continue;

        QString algo = entry.algorithm;

        if (!algorithmData.contains(algo)) {
            QVariantMap data;
            data["count"] = 0;
            data["totalResult"] = 0.0;
            data["totalTime"] = 0.0;
            algorithmData[algo] = data;
        }

        QVariantMap data = algorithmData[algo];
        data["count"] = data["count"].toInt() + 1;
        data["totalResult"] = data["totalResult"].toDouble() + entry.result;
        data["totalTime"] = data["totalTime"].toDouble() + entry.executionTime;
        algorithmData[algo] = data;
    }

    for (auto it = algorithmData.begin(); it != algorithmData.end(); ++it) {
        QString algo = it.key();
        QVariantMap data = it.value();

        int count = data["count"].toInt();
        double avgResult = data["totalResult"].toDouble() / count;
        double avgTime = data["totalTime"].toDouble() / count;

        QVariantMap stats;
        stats["usageCount"] = count;
        stats["usagePercentage"] = count * 100.0 / m_entries.size();
        stats["averageResult"] = avgResult;
        stats["averageExecutionTime"] = avgTime;

        algoStats[algo] = stats;
    }

    return algoStats;
}

// Property getters
int HistoryManager::getEntryCount() const
{
    return m_entries.size();
}

bool HistoryManager::isLoggingEnabled() const
{
    return m_loggingEnabled;
}

void HistoryManager::setLoggingEnabled(bool enabled)
{
    if (m_loggingEnabled != enabled) {
        m_loggingEnabled = enabled;
        logInfo(QString("Logging %1").arg(enabled ? "enabled" : "disabled"), "System");
        emit loggingEnabledChanged();
    }
}

// Private helper methods
bool HistoryManager::loadHistoryFromFile()
{
    QFile file(m_historyFilePath);
    if (!file.exists()) {
        logInfo("No existing history file found", "History");
        return true; // Not an error if file doesn't exist
    }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        logError(QString("Cannot open history file: %1").arg(file.errorString()), "History");
        return false;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        logError(QString("History file parse error: %1").arg(parseError.errorString()), "History");
        return false;
    }

    if (!doc.isArray()) {
        logError("History file is not a valid JSON array", "History");
        return false;
    }

    QJsonArray entriesArray = doc.array();
    m_entries.clear();

    for (const QJsonValue &entryValue : entriesArray) {
        QJsonObject entryObj = entryValue.toObject();

        HistoryEntry entry;
        entry.id = entryObj["id"].toString(generateId());
        entry.timestamp = QDateTime::fromString(entryObj["timestamp"].toString(), Qt::ISODate);
        entry.algorithm = entryObj["algorithm"].toString();
        entry.result = entryObj["result"].toDouble();
        entry.confidence = entryObj["confidence"].toDouble(1.0);
        entry.executionTime = entryObj["executionTime"].toDouble(0.0);
        entry.notes = entryObj["notes"].toString();
        entry.status = entryObj["status"].toString("success");
        entry.errorMessage = entryObj["errorMessage"].toString();

        // Parse agents
        QJsonArray agentsArray = entryObj["agents"].toArray();
        for (const QJsonValue &agentValue : agentsArray) {
            entry.agents.append(agentValue.toDouble());
        }

        // Parse confidences
        QJsonArray confidencesArray = entryObj["confidences"].toArray();
        if (confidencesArray.isEmpty()) {
            // Backward compatibility: if no confidences array, create default ones
            for (int i = 0; i < entry.agents.size(); ++i) {
                entry.confidences.append(1.0);
            }
        } else {
            for (const QJsonValue &confidenceValue : confidencesArray) {
                entry.confidences.append(confidenceValue.toDouble(1.0));
            }
        }

        m_entries.append(entry);
    }

    logInfo(QString("Loaded %1 history entries from %2")
                .arg(m_entries.size())
                .arg(m_historyFilePath),
            "History");

    return true;
}

bool HistoryManager::saveHistoryToFile()
{
    QJsonArray entriesArray;

    for (const HistoryEntry &entry : m_entries) {
        QJsonObject entryObj;
        entryObj["id"] = entry.id;
        entryObj["timestamp"] = entry.timestamp.toString(Qt::ISODate);
        entryObj["algorithm"] = entry.algorithm;
        entryObj["result"] = entry.result;
        entryObj["confidence"] = entry.confidence;
        entryObj["executionTime"] = entry.executionTime;
        entryObj["notes"] = entry.notes;
        entryObj["status"] = entry.status;
        entryObj["errorMessage"] = entry.errorMessage;

        // Add agents array
        QJsonArray agentsArray;
        for (const QVariant &agent : entry.agents) {
            agentsArray.append(agent.toDouble());
        }
        entryObj["agents"] = agentsArray;

        // Add confidences array
        QJsonArray confidencesArray;
        for (const QVariant &confidence : entry.confidences) {
            confidencesArray.append(confidence.toDouble());
        }
        entryObj["confidences"] = confidencesArray;

        entriesArray.append(entryObj);
    }

    QJsonDocument doc(entriesArray);

    // Create directory if it doesn't exist
    QFileInfo fileInfo(m_historyFilePath);
    QDir dir = fileInfo.dir();
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QFile file(m_historyFilePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        logError(QString("Cannot save history file: %1").arg(file.errorString()), "History");
        return false;
    }

    file.write(doc.toJson(QJsonDocument::Indented));
    file.close();

    return true;
}

void HistoryManager::appendToLogFile(const QString &logLine)
{
    // Create directory if it doesn't exist
    QFileInfo fileInfo(m_logFilePath);
    QDir dir = fileInfo.dir();
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QFile file(m_logFilePath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)) {
        QTextStream out(&file);
        out << logLine << "\n";
        file.close();
    }
}

QString HistoryManager::generateId() const
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

QString HistoryManager::logLevelToString(LogLevel level) const
{
    switch (level) {
    case LOG_INFO: return "INFO";
    case LOG_WARNING: return "WARNING";
    case LOG_ERROR: return "ERROR";
    case LOG_DEBUG: return "DEBUG";
    default: return "UNKNOWN";
    }
}

QString HistoryManager::getLogLevelColor(LogLevel level) const
{
    switch (level) {
    case LOG_INFO: return "\033[37m";      // White
    case LOG_WARNING: return "\033[33m";   // Yellow
    case LOG_ERROR: return "\033[31m";     // Red
    case LOG_DEBUG: return "\033[36m";     // Cyan
    default: return "\033[0m";            // Reset
    }
}
