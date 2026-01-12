import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform 1.1

Popup {
    id: comparisonPopup
    width: 800
    height: 600
    modal: true
    focus: true
    dim: true
    anchors.centerIn: Overlay.overlay

    property string title: "Algorithm Comparison Results"
    property bool showProgress: engine.isComparing
    property ListModel comparisonData: ListModel {}

    function loadComparisonData() {
           comparisonData.clear()
           var results = engine.getComparisonResults()
           for (var i = 0; i < results.length; i++) {
               comparisonData.append(results[i])
           }
       }

    onOpened: {
            if (!engine.isComparing) {
                loadComparisonData()
            }
        }


    background: Rectangle {
        color: bgColor
        radius: 8
        border.color: elementsColor
        border.width: 2
    }

    // Progress overlay
    Rectangle {
        visible: showProgress
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        z: 10

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            BusyIndicator {
                Layout.alignment: Qt.AlignHCenter
                running: showProgress
                contentItem: Rectangle {
                    implicitWidth: 64
                    implicitHeight: 64
                    radius: width / 2
                    color: "transparent"
                    border.color: elementsColor
                    border.width: 4

                    RotationAnimation on rotation {
                        from: 0
                        to: 360
                        duration: 1000
                        loops: Animation.Infinite
                    }
                }
            }

            Text {
                text: "Comparing algorithms... (" + (engine.comparisonProgressCurrent + 1) + "/" + engine.comparisonProgressTotal + ")"
                color: textColor
                font.pixelSize: 14
            }

            Text {
                text: "Please wait while all algorithms are executed"
                color: Qt.lighter(textColor, 1.3)
                font.pixelSize: 12
            }
        }
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Header
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: comparisonPopup.title
                font.pixelSize: 20
                font.bold: true
                color: textColor
                Layout.fillWidth: true
            }

            MyButton {
                mainColor: removeColor
                _width: 30
                _height: 30
                text: "✕"
                font.pixelSize: 12
                onClicked: comparisonPopup.close()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: elementsColor
        }

        // Statistics Panel
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 130
            color: Qt.darker(bgColor, 1.1)
            radius: 5
            border.color: elementsColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                // Row 2: Mean Result
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Mean Result:"
                        font.pixelSize: 12
                        color: textColor
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: 150
                    }

                    Text {
                        text: engine.comparisonMean.toFixed(4)
                        font.pixelSize: 12
                        font.bold: true
                        color: textColor
                        Layout.alignment: Qt.AlignLeft
                    }
                }

                // Row 3: Standard Deviation
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Standard Deviation:"
                        font.pixelSize: 12
                        color: textColor
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: 150
                    }

                    Text {
                        text: engine.comparisonStdDev.toFixed(4)
                        font.pixelSize: 12
                        font.bold: true
                        color: {
                            var std = engine.comparisonStdDev
                            if (std < 0.1) return lightGreenColor
                            if (std < 0.2) return yellowColor
                            return magentaColor
                        }
                        Layout.alignment: Qt.AlignLeft
                    }
                }

                // Row 4: Best Algorithm
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Best Algorithm:"
                        font.pixelSize: 12
                        color: textColor
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: 150
                    }

                    Text {
                        text: engine.bestAlgorithm
                        font.pixelSize: 12
                        font.bold: true
                        color: "#FFD700"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                // Row 5: Fastest Algorithm
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Fastest Algorithm:"
                        font.pixelSize: 12
                        color: textColor
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredWidth: 150
                    }

                    Text {
                        text: engine.fastestAlgorithm
                        font.pixelSize: 12
                        font.bold: true
                        color: cyanColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: elementsColor
            Layout.topMargin: 10
            Layout.bottomMargin: 10
        }

        // Comparison Table Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: "Algorithm"
                font.pixelSize: 12
                font.bold: true
                color: textColor
                Layout.preferredWidth: 200
            }

            Text {
                text: "Result"
                font.pixelSize: 12
                font.bold: true
                color: textColor
                Layout.preferredWidth: 100
            }

            Text {
                text: "Time (ms)"
                font.pixelSize: 12
                font.bold: true
                color: textColor
                Layout.preferredWidth: 80
            }

            Text {
                text: "Rank"
                font.pixelSize: 12
                font.bold: true
                color: textColor
                Layout.preferredWidth: 60
            }

            Text {
                text: ""
                Layout.fillWidth: true
            }
        }

        // Comparison Table
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            border.color: elementsColor
            border.width: 1
            radius: 4

            ListView {
                id: comparisonListView
                anchors.fill: parent
                anchors.margins: 2
                clip: true
                model: comparisonData

                delegate: Rectangle {
                    width: comparisonListView.width
                    height: 40
                    color: index % 2 === 0 ? Qt.darker(bgColor, 1.1) : Qt.darker(bgColor, 1.15)

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Text {
                            text: model.algorithm
                            font.pixelSize: 11
                            color: textColor
                            Layout.preferredWidth: 200
                            elide: Text.ElideRight
                        }

                        Text {
                            text: model.value.toFixed(4)
                            font.pixelSize: 11
                            color: {
                                if (model.value < 0.3) return magentaColor
                                if (model.value < 0.7) return yellowColor
                                return lightGreenColor
                            }
                            font.bold: true
                            Layout.preferredWidth: 100
                        }

                        Text {
                            text: model.executionTime.toFixed(1)
                            font.pixelSize: 11
                            color: cyanColor
                            Layout.preferredWidth: 80
                        }

                        Rectangle {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 24
                            radius: 3
                            color: {
                                switch(model.rank) {
                                case 1: return "#FFD700";  // Gold
                                case 2: return "#C0C0C0";  // Silver
                                case 3: return "#CD7F32";  // Bronze
                                default: return Qt.darker(elementsColor, 1.3)
                                }
                            }
                            border.color: elementsColor
                            border.width: 1

                            Text {
                                text: model.rank
                                font.pixelSize: 11
                                font.bold: true
                                color: model.rank <= 3 ? "black" : textColor
                                anchors.centerIn: parent
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 10
                            radius: 5
                            color: Qt.darker(elementsColor, 1.5)

                            Rectangle {
                                width: parent.width * (model.value)
                                height: parent.height
                                radius: parent.radius
                                color: {
                                    if (model.value < 0.3) return magentaColor
                                    if (model.value < 0.7) return yellowColor
                                    return lightGreenColor
                                }
                            }
                        }
                    }
                }
            }
        }

        // Action Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            MyButton {
                mainColor: elementsColor
                Layout.fillWidth: true
                _height: 35
                text: "Export to CSV"
                font.pixelSize: 12
                onClicked: {
                    fileDialog.folder = StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
                    fileDialog.open()
                }
            }

            MyButton {
                mainColor: removeColor
                Layout.fillWidth: true
                _height: 35
                text: "Close"
                font.pixelSize: 12
                onClicked: comparisonPopup.close()
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Export Comparison Results"
        nameFilters: ["CSV files (*.csv)", "All files (*)"]
        fileMode: FileDialog.SaveFile
        defaultSuffix: "csv"

        onAccepted: {
            var filePath = fileDialog.file.toString();

            // Debug: print the path
            console.log("FileDialog returned:", filePath);

            // Convert file URL to local path (platform independent)
            if (filePath.startsWith("file:///")) {
                // Windows: file:///C:/path/to/file.csv
                filePath = filePath.substring(8); // Remove "file:///"
            } else if (filePath.startsWith("file://")) {
                // Linux/Mac: file:///home/user/file.csv
                filePath = filePath.substring(7); // Remove "file://"
            } else if (filePath.startsWith("file:/")) {
                // Some systems: file:/C:/path
                filePath = filePath.substring(6); // Remove "file:/"
            }

            // Decode URL encoding (if any)
            filePath = decodeURIComponent(filePath);

            console.log("Exporting to:", filePath);

            // Call export function
            engine.exportComparisonCSV(filePath);

            // Show success message
            showMessage("Results exported to: " + filePath, lightGreenColor);
        }

        onRejected: {
            console.log("Export cancelled");
        }
    }
}
