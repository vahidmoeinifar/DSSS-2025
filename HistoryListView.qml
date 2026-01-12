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
                text: "🔄 Refresh"
                font.pixelSize: 11
                onClicked: {
                    // Force refresh
                    historyManager.historyChanged()
                }
            }

            MyButton {
                mainColor: removeColor
                Layout.fillWidth: true
                _height: 30
                text: "🗑️ Clear History"
                font.pixelSize: 11
                onClicked: clearConfirmDialog.open()
            }

            MyButton {
                mainColor: lightGreenColor
                Layout.fillWidth: true
                _height: 30
                text: "📤 Export"
                font.pixelSize: 11
                onClicked: exportMenu.open()
            }
        }

        // Search/Filters
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            MyTextfield {
                id: searchField
                Layout.fillWidth: true
                placeholderText: "Search by algorithm, result, notes..."

                onTextChanged: {
                    filterTimer.restart()
                }

                Timer {
                    id: filterTimer
                    interval: 300
                    onTriggered: {
                        // Filter logic would go here
                        console.log("Filtering with:", searchField.text)
                    }
                }
            }

            MyCombobox {
                id: filterCombo
                model: ["All", "Success", "Error", "Today", "This Week"]
                Layout.preferredWidth: 120
            }
        }

        // History List
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
                model: historyManager.historyEntries
                spacing: 5

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                    width: 8
                }

                delegate: HistoryEntryCard {
                    width: historyListView.width - 20
                    entryData: modelData
                    onClicked: {
                        // Create and show details popup
                        var popup = entryDetailsPopupComponent.createObject(historyPanel)
                        popup.openWithEntry(modelData)
                        popup.closed.connect(function() {
                            popup.destroy()
                        })
                    }
                }
                Text {
                    anchors.centerIn: parent
                    text: "No history entries yet"
                    color: textColorDisable
                    font.pixelSize: 14
                    visible: historyListView.count === 0
                }
            }
        }

        // Status
        Text {
            text: "Entries: " + historyManager.entryCount
            font.pixelSize: 11
            color: textColorDisable
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

    // Dialogs
    Dialog {
        id: clearConfirmDialog
        title: "Clear History"
        Button: Dialog.Yes | Dialog.No

        Label {
            text: "Are you sure you want to clear all history entries?\nThis action cannot be undone."
        }

        onAccepted: historyManager.clearHistory()
    }

    FileDialog {
        id: exportJsonDialog
        title: "Export History as JSON"
        fileMode: FileDialog.SaveFile
        defaultSuffix: "json"
        nameFilters: ["JSON files (*.json)", "All files (*)"]

        onAccepted: {
            var filePath = exportJsonDialog.file.toString()
            if (filePath.startsWith("file:///")) {
                filePath = filePath.substring(8) // Windows
            } else if (filePath.startsWith("file://")) {
                filePath = filePath.substring(7) // Unix/Mac
            }

            if (historyManager.exportHistoryToJson(filePath)) {
                showMessage("History exported successfully to JSON", lightGreenColor)
            } else {
                showMessage("Failed to export history", removeColor)
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
                filePath = filePath.substring(8) // Windows
            } else if (filePath.startsWith("file://")) {
                filePath = filePath.substring(7) // Unix/Mac
            }

            if (historyManager.exportHistoryToCsv(filePath)) {
                showMessage("History exported successfully to CSV", lightGreenColor)
            } else {
                showMessage("Failed to export history", removeColor)
            }
        }
    }

    function showMessage(msg, color) {
        console.log(msg)
    }
}
