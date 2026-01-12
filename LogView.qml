import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform 1.1

Rectangle {
    color: "transparent"

    property HistoryManager historyManager

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            MyButton {
                mainColor: elementsColor
                Layout.fillWidth: true
                _height: 30
                text: "🔄 Refresh Logs"
                font.pixelSize: 11
                onClicked: {
                    logTextArea.text = historyManager.getLogs(500)
                }
            }

            MyButton {
                mainColor: removeColor
                Layout.fillWidth: true
                _height: 30
                text: "🗑️ Clear Logs"
                font.pixelSize: 11
                onClicked: historyManager.clearLogs()
            }

            MyButton {
                mainColor: lightGreenColor
                Layout.fillWidth: true
                _height: 30
                text: "💾 Save Logs"
                font.pixelSize: 11
                onClicked: saveLogsDialog.open()
            }
        }

        // Log Level Filter
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: "Log Level:"
                font.pixelSize: 11
                color: textColor
            }

            MyCombobox {
                id: logLevelCombo
                model: ["All", "INFO", "WARNING", "ERROR", "DEBUG"]
                Layout.preferredWidth: 100
                onCurrentTextChanged: filterLogs()
            }

            CheckBox {
                id: autoRefreshCheck
                text: "Auto-refresh"
                checked: true
                font.pixelSize: 11
                indicator.width: 16
                indicator.height: 16

                contentItem: Text {
                    text: autoRefreshCheck.text
                    font: autoRefreshCheck.font
                    color: textColor
                    leftPadding: autoRefreshCheck.indicator.width + 5
                }
            }
        }

        // Log Display
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: darkScreenColor
            radius: 5
            border.color: elementsColor
            border.width: 1

            ScrollView {
                anchors.fill: parent
                anchors.margins: 5

                TextArea {
                    id: logTextArea
                    text: historyManager.getLogs(500)
                    font.family: "Monospace"
                    font.pixelSize: 10
                    color: textColor
                    readOnly: true
                    selectByMouse: true
                    wrapMode: Text.WrapAnywhere

                    background: Rectangle {
                        color: "transparent"
                    }
                }
            }
        }

        // Log Entry Count
        Text {
            text: "Log lines: " + (logTextArea.text.split('\n').length - 1)
            font.pixelSize: 11
            color: textColorDisable
        }
    }

    // Auto-refresh timer
    Timer {
        interval: 2000
        running: autoRefreshCheck.checked
        repeat: true
        onTriggered: {
            if (!logTextArea.focus) {
                logTextArea.text = historyManager.getLogs(500)
                filterLogs()
            }
        }
    }

    // Connect to log updates
    Connections {
        target: historyManager
        function onLogAdded(logLine) {
            if (autoRefreshCheck.checked) {
                var lines = logTextArea.text.split('\n')
                lines.push(logLine)
                if (lines.length > 500) {
                    lines = lines.slice(lines.length - 500)
                }
                logTextArea.text = lines.join('\n')
                filterLogs()
            }
        }
    }

    // Save Logs Dialog
    FileDialog {
        id: saveLogsDialog
        title: "Save Logs"
        fileMode: FileDialog.SaveFile
        defaultSuffix: "txt"
        nameFilters: ["Text files (*.txt)", "Log files (*.log)", "All files (*)"]

        onAccepted: {
            var filePath = saveLogsDialog.file.toString()
            if (filePath.startsWith("file:///")) {
                filePath = filePath.substring(8)
            } else if (filePath.startsWith("file://")) {
                filePath = filePath.substring(7)
            }

            var file = Qt.createQmlObject('import QtQuick 2.0; QtObject {}', parent)
            var success = false

            try {
                var xhr = new XMLHttpRequest()
                xhr.open("PUT", Qt.resolvedUrl("file:///" + filePath))
                xhr.send(logTextArea.text)
                success = true
            } catch (e) {
                console.error("Failed to save logs:", e)
            }

            if (success) {
                showMessage("Logs saved successfully", lightGreenColor)
            } else {
                showMessage("Failed to save logs", removeColor)
            }
        }
    }

    function filterLogs() {
        var allLines = logTextArea.text.split('\n')
        var filteredLines = []
        var level = logLevelCombo.currentText

        for (var i = 0; i < allLines.length; i++) {
            var line = allLines[i]
            if (level === "All" ||
                (level === "INFO" && line.includes("[INFO]")) ||
                (level === "WARNING" && line.includes("[WARNING]")) ||
                (level === "ERROR" && line.includes("[ERROR]")) ||
                (level === "DEBUG" && line.includes("[DEBUG]"))) {
                filteredLines.push(line)
            }
        }

        logTextArea.text = filteredLines.join('\n')
    }

    function showMessage(msg, color) {
        console.log(msg)
    }

    Component.onCompleted: {
        logTextArea.text = historyManager.getLogs(500)
        filterLogs()
    }
}
