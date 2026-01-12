import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: entryCard
    height: 80
    radius: 5
    color: {
        if (entryData.status === "error") return Qt.darker(removeColor, 1.5)
        return index % 2 === 0 ? Qt.darker(bgColor, 1.2) : Qt.darker(bgColor, 1.3)
    }
    border.color: entryData.status === "error" ? magentaColor : elementsColor
    border.width: 1

    property var entryData: ({})
    property int index: 0
    signal clicked()

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: entryCard.clicked()

        onEntered: {
            if (entryData.status !== "error") {
                entryCard.color = Qt.darker(elementsColor, 1.3)
            }
        }
        onExited: {
            if (entryData.status !== "error") {
                entryCard.color = index % 2 === 0 ? Qt.darker(bgColor, 1.2) : Qt.darker(bgColor, 1.3)
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        // Status Indicator
        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: entryData.status === "success" ? lightGreenColor : magentaColor
            Layout.alignment: Qt.AlignVCenter
        }

        // Main Content
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: {
                        if (!entryData.algorithm) return "Unknown"
                        var algo = entryData.algorithm
                        return algo.split('/').pop().split('\\').pop()
                    }
                    font.pixelSize: 12
                    font.bold: true
                    color: textColor
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    text: entryData.timestamp || "N/A"
                    font.pixelSize: 10
                    color: textColorDisable
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Result: " + (entryData.result || 0).toFixed(4)
                    font.pixelSize: 11
                    color: {
                        var val = entryData.result || 0
                        if (val < 0.3) return magentaColor
                        if (val < 0.7) return yellowColor
                        return lightGreenColor
                    }
                    font.bold: true
                }

                Text {
                    text: "Agents: " + (entryData.agentCount || 0)
                    font.pixelSize: 10
                    color: textColorDisable
                    Layout.fillWidth: true
                }

                Text {
                    text: (entryData.executionTime || 0).toFixed(0) + "ms"
                    font.pixelSize: 10
                    color: cyanColor
                }
            }

            // Notes/Error
            Text {
                text: entryData.status === "error" ?
                      "❌ " + (entryData.errorMessage || "Error") :
                      (entryData.notes || "")
                font.pixelSize: 10
                color: entryData.status === "error" ? magentaColor : textColorDisable
                elide: Text.ElideRight
                visible: text.length > 0
                Layout.fillWidth: true
            }
        }

        // View Details Button
        MyButton {
            mainColor: elementsColor
            _width: 60
            _height: 24
            text: "Details"
            font.pixelSize: 10
            Layout.alignment: Qt.AlignVCenter

            onClicked: entryCard.clicked()
        }
    }

    onEntryDataChanged: {
        console.log("HistoryEntryCard: entryData updated",
                    "algorithm:", entryData.algorithm,
                    "result:", entryData.result,
                    "status:", entryData.status)
    }
}
