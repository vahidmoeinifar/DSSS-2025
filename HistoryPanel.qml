import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform 1.1
import GDSS 1.0

Popup {
    id: historyPanel
    width: 900
    height: 700
    modal: true
    focus: true
    dim: true
    anchors.centerIn: Overlay.overlay

    property DecisionEngine engine
    property var historyManager: engine ? engine.historyManager() : null


    background: Rectangle {
        color: bgColor
        radius: 8
        border.color: elementsColor
        border.width: 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        // Header
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "📚 History & Logs"
                font.pixelSize: 20
                font.bold: true
                color: textColor
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "transparent"
            }

            MyButton {
                mainColor: removeColor
                _width: 30
                _height: 30
                text: "\uf00d"
                font.family: fontAwsomeRegular.name
                font.pixelSize: 12
                onClicked: historyPanel.close()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: elementsColor
        }

        // Tab Bar
        TabBar {
            id: tabBar
            Layout.fillWidth: true

            background: Rectangle {
                color: Qt.darker(bgColor, 1.2)
            }

            TabButton {
                text: "📊 History"
                font.pixelSize: 12
                background: Rectangle {
                    color: parent.checked ? elementsColor : "transparent"
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.checked ? textColor : textColorDisable
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            TabButton {
                text: "📝 Logs"
                font.pixelSize: 12
                background: Rectangle {
                    color: parent.checked ? elementsColor : "transparent"
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.checked ? textColor : textColorDisable
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            TabButton {
                text: "📈 Statistics"
                font.pixelSize: 12
                background: Rectangle {
                    color: parent.checked ? elementsColor : "transparent"
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.checked ? textColor: textColorDisable
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Tab Content
        StackLayout {
            id: stackLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            // Tab 1: History
            Rectangle {
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    // History controls
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        MyButton {
                            text: "🔄 Refresh"
                            Layout.fillWidth: true
                            onClicked: refreshHistory()
                        }

                        MyButton {
                            text: "🗑️ Clear History"
                            Layout.fillWidth: true
                            mainColor: removeColor
                            onClicked: {
                                   console.log("Clear History button clicked")
                                   clearHistoryDialog.open()
                               }
                        }

                        MyButton {
                            text: "📤 Export"
                            Layout.fillWidth: true
                            mainColor: successColor
                            onClicked: exportMenu.open()
                        }
                    }

                    // History list
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Qt.darker(bgColor, 1.1)
                        radius: 5
                        border.color: elementsColor
                        border.width: 1

                        ListView {
                            id: historyListView
                            anchors.fill: parent
                            anchors.margins: 5
                            clip: true
                            model: []

                            ScrollBar.vertical: ScrollBar {
                                policy: ScrollBar.AlwaysOn
                                width: 8
                            }

                            delegate: Rectangle {
                                width: historyListView.width - 20
                                height: 60
                                radius: 3
                                color: index % 2 === 0 ? Qt.darker(bgColor, 1.2) : Qt.darker(bgColor, 1.3)

                                property var _entryData: modelData

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 10

                                    // Status indicator
                                    Rectangle {
                                        width: 8
                                        height: 8
                                        radius: 4
                                        color: _entryData.status === "success" ? successColor : removeColor
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    // Main content
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2

                                        RowLayout {
                                            Text {
                                                text: _entryData.algorithm || "Unknown"
                                                font.pixelSize: 12
                                                font.bold: true
                                                color: textColor
                                                elide: Text.ElideRight
                                                Layout.fillWidth: true
                                            }

                                            Text {
                                                text: _entryData.timestamp || ""
                                                font.pixelSize: 10
                                                color: textColorDisable
                                            }
                                        }

                                        RowLayout {
                                            Text {
                                                text: "Result: " + (_entryData.result || 0).toFixed(4)
                                                font.pixelSize: 11
                                                color: yellowColor
                                                font.bold: true
                                            }

                                            Text {
                                                text: "Agents: " + (_entryData.agentCount || 0)
                                                font.pixelSize: 10
                                                color: textColorDisable
                                                Layout.fillWidth: true
                                            }

                                            Text {
                                                text: (_entryData.executionTime || 0).toFixed(0) + "ms"
                                                font.pixelSize: 10
                                                color: cyanColor
                                            }
                                        }

                                        // Notes/Error
                                        Text {
                                            text: _entryData.status === "error" ?
                                                  "❌ " + (_entryData.errorMessage || "Error") :
                                                  (_entryData.notes || "")
                                            font.pixelSize: 9
                                            color: _entryData.status === "error" ? magentaColor : textColorDisable
                                            elide: Text.ElideRight
                                            visible: text.length > 0
                                        }
                                    }

                                    // View details button
                                    MyButton {
                                        mainColor: elementsColor
                                        _width: 60
                                        _height: 24
                                        text: "Details"
                                        font.pixelSize: 10
                                        Layout.alignment: Qt.AlignVCenter

                                        onClicked: {
                                            entryDetails.entryData = _entryData
                                            entryDetails.open()
                                        }
                                    }
                                }
                            }

                            EntryDetailsPopup { id: entryDetails}

                            Text {
                                anchors.centerIn: parent
                                text: "No history entries yet"
                                color: textColorDisable
                                visible: historyListView.count === 0
                            }
                        }
                    }

                    // Status
                    Text {
                        text: "Entries: " + historyListView.count
                        font.pixelSize: 11
                        color: textColorDisable
                    }
                }
            }

            // Tab 2: Logs
            Rectangle {
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    // Log controls
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        MyButton {
                            text: "🔄 Refresh Logs"
                            Layout.fillWidth: true
                            onClicked: refreshLogs()
                        }

                        MyButton {
                            text: "🗑️ Clear Logs"
                            Layout.fillWidth: true
                            mainColor: removeColor
                            onClicked: {
                                   console.log("Clear Logs button clicked")
                                   clearLogsDialog.open()
                               }
                        }

                        MyCombobox_Log {
                            id: logLevelCombo
                            model: ["All", "INFO", "WARNING", "ERROR", "DEBUG"]
                            Layout.preferredWidth: 120
                            onCurrentTextChanged: filterLogs()
                        }
                    }

                    // Log display
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
                                text: ""
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

                    // Auto-refresh toggle
                    RowLayout {
                        Layout.fillWidth: true

                        CheckBox {
                            id: autoRefreshCheck
                            text: "Auto-refresh (2s)"
                            checked: true
                            font.pixelSize: 11

                            contentItem: Text {
                                text: autoRefreshCheck.text
                                font: autoRefreshCheck.font
                                color: textColor
                                leftPadding: autoRefreshCheck.indicator.width + 5
                            }
                        }

                        Text {
                            text: "Lines: " + (logTextArea.text.split('\n').length - 1)
                            font.pixelSize: 11
                            color: textColorDisable
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // Tab 3: Statistics
            Rectangle {
                color: "transparent"

                ScrollView {
                    anchors.fill: parent

                    ColumnLayout {
                        width: parent.width
                        spacing: 15

                        // Overall Statistics
                        Rectangle {
                            Layout.fillWidth: true
                            height: 150
                            color: Qt.darker(bgColor, 1.1)
                            radius: 5
                            border.color: elementsColor
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10

                                Text {
                                    text: "📊 Overall Statistics"
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: textColor
                                }

                                GridLayout {
                                    columns: 2
                                    columnSpacing: 20
                                    rowSpacing: 8
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Text { text: "Total Entries:"; color: textColorDisable; font.pixelSize: 11 }
                                    Text {
                                        id: totalEntriesText
                                        color: lightGreenColor; font.pixelSize: 11; font.bold: true
                                    }

                                    Text { text: "Success Rate:"; color: textColorDisable; font.pixelSize: 11 }
                                    Text {
                                        id: successRateText
                                        color: lightGreenColor; font.pixelSize: 11; font.bold: true
                                    }

                                    Text { text: "Average Result:"; color: textColorDisable; font.pixelSize: 11 }
                                    Text {
                                        id: avgResultText
                                        color: yellowColor; font.pixelSize: 11; font.bold: true
                                    }

                                    Text { text: "Avg Execution Time:"; color: textColorDisable; font.pixelSize: 11 }
                                    Text {
                                        id: avgTimeText
                                        color: cyanColor; font.pixelSize: 11; font.bold: true
                                    }
                                }
                            }
                        }

                        // Algorithm Usage
                        Rectangle {
                            Layout.fillWidth: true
                            height: 200
                            color: Qt.darker(bgColor, 1.1)
                            radius: 5
                            border.color: elementsColor
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10

                                Text {
                                    text: "⚙️ Algorithm Usage"
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: textColor
                                }

                                ListView {
                                    id: algorithmListView
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    clip: true
                                    model: []

                                    delegate: Rectangle {
                                        width: algorithmListView.width
                                        height: 40
                                        color: index % 2 === 0 ? "transparent" : Qt.rgba(1,1,1,0.05)

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: 5

                                            Text {
                                                text: modelData.algorithm || "Unknown"
                                                font.pixelSize: 11
                                                color: textColor
                                                Layout.fillWidth: true
                                                elide: Text.ElideRight
                                            }

                                            Text {
                                                text: modelData.count + " uses"
                                                font.pixelSize: 11
                                                color: lightGreenColor
                                                Layout.preferredWidth: 60
                                            }

                                            Text {
                                                text: modelData.avgResult ? modelData.avgResult.toFixed(4) : "0.0000"
                                                font.pixelSize: 11
                                                color: yellowColor
                                                Layout.preferredWidth: 60
                                            }

                                            Text {
                                                text: modelData.avgTime ? modelData.avgTime.toFixed(0) + "ms" : "0ms"
                                                font.pixelSize: 11
                                                color: cyanColor
                                                Layout.preferredWidth: 70
                                            }
                                        }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "No algorithm statistics"
                                        color: textColorDisable
                                        visible: algorithmListView.count === 0
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Dialogs
    ConfirmationDialog {
        id: clearHistoryDialog
        title: "Clear History"
        message: "Are you sure you want to clear all history entries?\nThis action cannot be undone."
        confirmButtonText: "Clear"
        cancelButtonText: "Cancel"
        confirmButtonColor: removeColor
        cancelButtonColor: elementsColor

        onConfirmed: {
            console.log("Clear history confirmed")
            if (engine && engine.historyManager) {
                var hm = engine.historyManager()
                if (hm) {
                    hm.clearHistory()
                    refreshHistory()
                    refreshStatistics()
                    showMessage("History cleared successfully", lightGreenColor)
                }
            }
        }

        onCancelled: {
            console.log("Clear history cancelled")
        }
    }

    ConfirmationDialog {
        id: clearLogsDialog
        title: "Clear Logs"
        message: "Are you sure you want to clear all logs?"
        confirmButtonText: "Clear"
        cancelButtonText: "Cancel"
        confirmButtonColor: removeColor
        cancelButtonColor: elementsColor

        onConfirmed: {
            console.log("Clear logs confirmed")
            if (engine && engine.historyManager) {
                var hm = engine.historyManager()
                if (hm) {
                    hm.clearLogs()
                    refreshLogs()
                    showMessage("Logs cleared successfully", lightGreenColor)
                }
            }
        }

        onCancelled: {
            console.log("Clear logs cancelled")
        }
    }


    // Export Menu
    Menu {
        id: exportMenu

        MenuItem {
            text: "Export to JSON"
            onTriggered: exportJsonDialog.open()
        }

        MenuItem {
            text: "Export to CSV"
            onTriggered: exportCsvDialog.open()
        }
    }

    FileDialog {
        id: exportJsonDialog
        title: "Export History as JSON"
        fileMode: FileDialog.SaveFile
        defaultSuffix: "json"
        nameFilters: ["JSON files (*.json)", "All files (*)"]

        onAccepted: {
            var filePath = exportJsonDialog.file.toString()
            // Convert file URL to local path
            if (filePath.startsWith("file:///")) {
                filePath = filePath.substring(8)
            } else if (filePath.startsWith("file://")) {
                filePath = filePath.substring(7)
            }

            if (engine && engine.historyManager) {
                var hm = engine.historyManager()
                if (hm && hm.exportHistoryToJson(filePath)) {
                    showMessage("History exported successfully to JSON", lightGreenColor)
                }
            }
        }
    }

    FileDialog {
        id: exportCsvDialog
        title: "Export History as CSV"
        fileMode: FileDialog.SaveFile
        defaultSuffix: "csv"
        nameFilters: ["CSV files (*.csv)", "All files (*)"]

        onAccepted: {
            var filePath = exportCsvDialog.file.toString()
            if (filePath.startsWith("file:///")) {
                filePath = filePath.substring(8)
            } else if (filePath.startsWith("file://")) {
                filePath = filePath.substring(7)
            }

            if (engine && engine.historyManager) {
                var hm = engine.historyManager()
                if (hm && hm.exportHistoryToCsv(filePath)) {
                    showMessage("History exported successfully to CSV", lightGreenColor)
                }
            }
        }
    }

    // Helper functions
    function refreshHistory() {
        if (engine && engine.historyManager) {
            var hm = engine.historyManager()
            if (hm) {
                historyListView.model = hm.getHistoryEntries()
            }
        }
    }

    function refreshLogs() {
        if (engine && engine.historyManager) {
            var hm = engine.historyManager()
            if (hm) {
                logTextArea.text = hm.getLogs(500)
                filterLogs()
            }
        }
    }

    function refreshStatistics() {
        if (engine && engine.historyManager) {
            var hm = engine.historyManager()
            if (hm) {
                var stats = hm.getStatistics()
                totalEntriesText.text = stats["totalEntries"] || 0
                successRateText.text = (stats["successRate"] || 0).toFixed(1) + "%"
                avgResultText.text = (stats["averageResult"] || 0).toFixed(4)
                avgTimeText.text = (stats["averageExecutionTime"] || 0).toFixed(0) + "ms"

                // Algorithm statistics
                var algoStats = hm.getAlgorithmStatistics()
                var algoList = []
                for (var algo in algoStats) {
                    algoList.push({
                        algorithm: algo,
                        count: algoStats[algo]["usageCount"] || 0,
                        avgResult: algoStats[algo]["averageResult"] || 0,
                        avgTime: algoStats[algo]["averageExecutionTime"] || 0
                    })
                }
                algorithmListView.model = algoList
            }
        }
    }

    function filterLogs() {
        if (!logTextArea.text) return

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
        console.log("Message:", msg)
    }

    // Auto-refresh timer for logs
    Timer {
        interval: 2000
        running: autoRefreshCheck.checked && tabBar.currentIndex === 1 // Only when on Logs tab
        repeat: true
        onTriggered: refreshLogs()
    }

    // Load data when opened
    onOpened: {
        refreshHistory()
        refreshLogs()
        refreshStatistics()
    }

    Component.onCompleted: {
        console.log("Complete HistoryPanel loaded")
    }


}
