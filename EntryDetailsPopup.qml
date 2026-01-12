import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: entryDetails
    width: 600
    height: 500
    modal: true
    focus: true
    dim: true
    anchors.centerIn: Overlay.overlay

    property var entryData: ({})

    background: Rectangle {
        color: bgColor
        radius: 8
        border.color: elementsColor
        border.width: 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Header
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Entry Details"
                font.pixelSize: 18
                font.bold: true
                color: textColor
                Layout.fillWidth: true
            }

            MyButton {
                mainColor: removeColor
                _width: 30
                _height: 30
                text: "✕"
                font.pixelSize: 16
                onClicked: entryDetails.close()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: elementsColor
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                width: parent.width
                spacing: 15

                // Basic Info Grid
                GridLayout {
                    columns: 2
                    columnSpacing: 20
                    rowSpacing: 10
                    Layout.fillWidth: true

                    Text { text: "Timestamp:"; color: textColorDisable; font.pixelSize: 12 }
                    Text {
                        text: entryData.timestamp || "N/A"
                        color: lightGreenColor;
                        font.pixelSize: 12
                    }

                    Text { text: "Algorithm:"; color: textColorDisable; font.pixelSize: 12 }
                    Text {
                        text: entryData.algorithm || "N/A"
                        color: lightGreenColor;
                        font.pixelSize: 12
                    }

                    Text { text: "Result:"; color: textColorDisable; font.pixelSize: 12 }
                    Text {
                        text: (entryData.result || 0).toFixed(6)
                        color: {
                            var val = entryData.result || 0
                            if (val < 0.3) return magentaColor
                            if (val < 0.7) return yellowColor
                            return lightGreenColor
                        }
                        font.pixelSize: 14
                        font.bold: true
                    }

                    Text { text: "Confidence:"; color: textColorDisable; font.pixelSize: 12 }
                    Text {
                        text: {
                            var conf = entryData.confidence || 1.0
                            return (conf * 100).toFixed(1) + "%"
                        }
                        color: cyanColor
                        font.pixelSize: 12
                    }

                    Text { text: "Execution Time:"; color: textColorDisable; font.pixelSize: 12 }
                    Text {
                        text: (entryData.executionTime || 0).toFixed(0) + " ms"
                        color: cyanColor
                        font.pixelSize: 12
                    }

                    Text { text: "Status:"; color: textColorDisable; font.pixelSize: 12 }
                    Text {
                        text: (entryData.status === "success") ? "✅ Success" : "❌ Error"
                        color: (entryData.status === "success") ? lightGreenColor : magentaColor
                        font.pixelSize: 12
                        font.bold: true
                    }

                    Text { text: "Agent Count:"; color: textColorDisable; font.pixelSize: 12 }
                    Text {
                        text: entryData.agentCount || 0
                        color: textColor
                        font.pixelSize: 12
                    }
                }

                // Agent Values Section (only if agents exist)
                Loader {
                    Layout.fillWidth: true
                    Layout.preferredHeight: active ? 200 : 0
                    active: entryData.agents && entryData.agents.length > 0

                    sourceComponent: ColumnLayout {
                        spacing: 10
                        width: parent.width

                        Text {
                            text: "Agent Values (" + entryData.agents.length + ")"
                            font.pixelSize: 14
                            font.bold: true
                            color: textColor
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Qt.darker(bgColor, 1.2)
                            radius: 5
                            border.color: elementsColor
                            border.width: 1

                            ListView {
                                anchors.fill: parent
                                anchors.margins: 5
                                clip: true
                                model: entryData.agents || []

                                delegate: Rectangle {
                                    width: ListView.view.width
                                    height: 30
                                    color: index % 2 === 0 ? Qt.rgba(1,1,1,0.05) : "transparent"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 5

                                        Text {
                                            text: "Agent " + (index + 1)
                                            font.pixelSize: 11
                                            color: textColor
                                            Layout.preferredWidth: 80
                                        }

                                        Text {
                                            text: modelData.toFixed(4)
                                            font.pixelSize: 11
                                            color: yellowColor
                                            Layout.fillWidth: true
                                        }

                                        Text {
                                            text: {
                                                var conf = entryData.confidences && entryData.confidences[index]
                                                return conf ? (conf * 100).toFixed(1) + "%" : "100%"
                                            }
                                            font.pixelSize: 11
                                            color: cyanColor
                                            Layout.preferredWidth: 60
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Notes/Error Section (only if exists)
                Loader {
                    Layout.fillWidth: true
                    Layout.preferredHeight: active ? 80 : 0
                    active: (entryData.notes && entryData.notes.length > 0) ||
                            (entryData.errorMessage && entryData.errorMessage.length > 0)

                    sourceComponent: ColumnLayout {
                        spacing: 5
                        width: parent.width

                        Text {
                            text: (entryData.status === "error") ? "Error Message:" : "Notes:"
                            font.pixelSize: 14
                            font.bold: true
                            color: textColor
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 60
                            color: Qt.darker(bgColor, 1.2)
                            radius: 5
                            border.color: (entryData.status === "error") ? magentaColor : elementsColor
                            border.width: 1

                            ScrollView {
                                anchors.fill: parent
                                anchors.margins: 5

                                Text {
                                    text: (entryData.status === "error") ?
                                          (entryData.errorMessage || "") :
                                          (entryData.notes || "")
                                    font.pixelSize: 11
                                    color: (entryData.status === "error") ? magentaColor : textColorDisable
                                    wrapMode: Text.Wrap
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
