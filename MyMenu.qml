import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    width: 40
    height: 40

    // Signal to send loaded data to main
    signal dataLoaded(var values, var fileName)
    signal showMessage(string message, color color)

    FileDialog {
        id: dataFileDialog
        title: "Open Data File"
        nameFilters: ["Text files (*.txt)", "CSV files (*.csv)", "All files (*)"]

        onAccepted: {
            var fileUrl = dataFileDialog.selectedFile
            var fileName = fileUrl.toString().split('/').pop().split('\\').pop()

            var xhr = new XMLHttpRequest()
            xhr.open("GET", fileUrl)
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200 || xhr.status === 0) {
                        var content = xhr.responseText
                        var lines = content.split('\n')
                        var values = []

                        for (var i = 0; i < lines.length; i++) {
                            var line = lines[i].trim()
                            if (line.length === 0) continue

                            // Parse comma or space separated values
                            var lineValues = line.split(/[,;\s\t]+/)
                            for (var j = 0; j < lineValues.length; j++) {
                                var val = parseFloat(lineValues[j])
                                if (!isNaN(val) && val >= 0 && val <= 1) {
                                    values.push(val)
                                }
                            }
                        }

                        if (values.length > 0) {
                            dataLoaded(values, fileName)  // Emit the signal
                        } else {
                            showMessage("No valid values found in file", warningColor)
                        }
                    } else {
                        showMessage("Error reading file", removeColor)
                    }
                }
            }
            xhr.send()
        }
    }

    // Menu button
    Rectangle {
        id: menuButton
        anchors.fill: parent
        color: "transparent"

        Text {
            text: "☰"
            font.pixelSize: 24
            color: elementsColor
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: customMenu.open()
        }
    }

    // Custom menu using Popup
    Popup {
        id: customMenu
        x: -140  // Position to left of button
        y: menuButton.height
        width: 160
        height: 290 //menuContent.height
        padding: 5

        background:  Rectangle {
            color: Qt.darker(bgColor, 2.1)
            border.color: elementsColor
            border.width: 1
            radius: 3
        }

        contentItem: Column {
            id: menuContent
            width: parent.width
            spacing: 0

            // Open Data
            Rectangle {
                width: parent.width
                height: 40
                color: menuDataArea.containsMouse ? Qt.lighter(elementsColor, 1.2) : "transparent"

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    spacing: 10

                    Text {
                        text: "📂"
                        font.pixelSize: 14
                        color: textColor
                    }

                    Text {
                        text: "Open Data"
                        font.pixelSize: 12
                        color: textColor
                    }
                }

                MouseArea {
                    id: menuDataArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        dataFileDialog.open()
                        customMenu.close()
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 40
                color: menuScriptArea.containsMouse ? Qt.lighter(elementsColor, 1.2) : "transparent"

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    spacing: 10

                    Text {
                        text: "📜"
                        font.pixelSize: 14
                        color: textColor
                    }

                    Text {
                        text: "Load Script"
                        font.pixelSize: 12
                        color: textColor
                    }
                }

                MouseArea {
                    id: menuScriptArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        fileDialog.open()
                        customMenu.close()
                    }
                }
            }



            // Separator
            Rectangle {
                width: parent.width
                height: 1
                color: elementsColor
            }

            // Repository
            Rectangle {
                width: parent.width
                height: 40
                color: menuRepoArea.containsMouse ? Qt.lighter(elementsColor, 1.2) : "transparent"

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    spacing: 10

                    Text {
                        text: "🐙"
                        font.pixelSize: 14
                        color: textColor
                    }

                    Text {
                        text: "GitHub Repository"
                        font.pixelSize: 12
                        color: textColor
                    }
                }

                MouseArea {
                    id: menuRepoArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Qt.openUrlExternally("https://github.com/vahidmoeinifar/DSSS-2025/tree/main")
                }
            }
            // Help
            Rectangle {
                width: parent.width
                height: 40
                color: menuHelpArea.containsMouse ? Qt.lighter(elementsColor, 1.2) : "transparent"

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    spacing: 10

                    Text {
                        text: "❓"
                        font.pixelSize: 14
                        color: textColor
                    }

                    Text {
                        text: "Documents"
                        font.pixelSize: 12
                        color: textColor
                    }
                }

                MouseArea {
                    id: menuHelpArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Qt.openUrlExternally("https://github.com/vahidmoeinifar/DSSS-2025/blob/main/Documents.md")
                }
            }

            // readme
            Rectangle {
                width: parent.width
                height: 40
                color: menuReadMeArea.containsMouse ? Qt.lighter(elementsColor, 1.2) : "transparent"

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    spacing: 10

                    Text {
                        text: "📚"
                        font.pixelSize: 14
                        color: textColor
                    }

                    Text {
                        text: "Readme"
                        font.pixelSize: 12
                        color: textColor
                    }
                }

                MouseArea {
                    id: menuReadMeArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Qt.openUrlExternally("https://github.com/vahidmoeinifar/DSSS-2025/blob/main/README.md")
                }
            }
            // About
            Rectangle {
                width: parent.width
                height: 40
                color: menuAboutArea.containsMouse ? Qt.lighter(elementsColor, 1.2) : "transparent"

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    spacing: 10

                    Text {
                        text: "ℹ️"
                        font.pixelSize: 14
                        color: textColor
                    }

                    Text {
                        text: "About"
                        font.pixelSize: 12
                        color: textColor
                    }
                }

                MouseArea {
                    id: menuAboutArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        var component = Qt.createComponent("About.qml");
                        if (component.status === Component.Ready) {
                            var aboutWindow = component.createObject(null, {
                                "bgColor": bgColor,
                                "textColor": textColor,
                                "elementsColor": elementsColor
                            });
                            aboutWindow.show();
                        }
                        customMenu.close()
                    }
                }
            }

            // Separator
            Rectangle {
                width: parent.width
                height: 1
                color: elementsColor
            }

            // Exit
            Rectangle {
                width: parent.width
                height: 40
                color: menuExitArea.containsMouse ? removeColor : "transparent"

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    spacing: 10

                    Text {
                        text: "✕"
                        font.pixelSize: 14
                        color: textColor
                    }

                    Text {
                        text: "Exit"
                        font.pixelSize: 12
                        color: textColor
                    }
                }

                MouseArea {
                    id: menuExitArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Qt.quit()
                }
            }
        }
    }
}
