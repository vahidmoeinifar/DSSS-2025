import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Window {
    id: aboutWindow
    title: "About GDSS Simulator"
    width: 450
    height: 600
    minimumWidth: 400
    minimumHeight: 400
    flags: Qt.Dialog
    modality: Qt.ApplicationModal


    color: Qt.darker(bgColor, 1.1)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Title Section
        ColumnLayout {
            spacing: 5
            Layout.alignment: Qt.AlignHCenter

            Text {
                text: "GDSS Simulator"
                font.pixelSize: 24
                font.bold: true
                color: textColor
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "v1.0"
                font.pixelSize: 12
                color: Qt.lighter(textColor, 1.3)
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 2
            color: elementsColor
            radius: 1
        }

        // Description
        Text {
            text: "Group Decision Support System"
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            font.pixelSize: 14
            font.bold: true
            color: textColor
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: "Information Fusion & AI Decision Making Platform"
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            font.pixelSize: 11
            color: Qt.lighter(textColor, 1.2)
            horizontalAlignment: Text.AlignHCenter
        }

        // Feature highlights
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: Qt.darker(bgColor, 1.2)
            radius: 5
            border.color: elementsColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                Text {
                    text: "Features:"
                    font.pixelSize: 12
                    font.bold: true
                    color: textColor
                }

                RowLayout {
                    spacing: 15

                    ColumnLayout {
                        spacing: 3

                        Text {
                            text: "✓ Multi-agent fusion"
                            font.pixelSize: 10
                            color: textColor
                        }

                        Text {
                            text: "✓ AI-based algorithms"
                            font.pixelSize: 10
                            color: textColor
                        }

                        Text {
                            text: "✓ Real-time processing"
                            font.pixelSize: 10
                            color: textColor
                        }
                    }

                    ColumnLayout {
                        spacing: 3

                        Text {
                            text: "✓ C++ backend"
                            font.pixelSize: 10
                            color: textColor
                        }

                        Text {
                            text: "✓ Python AI engine"
                            font.pixelSize: 10
                            color: textColor
                        }

                        Text {
                            text: "✓ Qt Quick UI"
                            font.pixelSize: 10
                            color: textColor
                        }
                    }
                }
            }
        }

        // Developer Info
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: Qt.darker(bgColor, 1.15)
            radius: 5
            border.color: elementsColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 8

                Text {
                    text: "Developer Information"
                    font.pixelSize: 12
                    font.bold: true
                    color: textColor
                }

                Text {
                    text: "Vahid Moeinifar"
                    font.pixelSize: 11
                    color: textColor
                }

                Text {
                    text: "AGH University of Krakow"
                    font.pixelSize: 10
                    color: Qt.lighter(textColor, 1.2)
                }

                Text {
                    text: "Faculty of Electrical Engineering, Automatics, Computer Science and Biomedical Engineering"
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    font.pixelSize: 9
                    color: Qt.lighter(textColor, 1.5)
                }

                Text {
                    text: "vmoeinifar@agh.edu.pl"
                    font.pixelSize: 10
                    color: Qt.lighter(elementsColor, 1.3)
                    font.italic: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.openUrlExternally("mailto:vmoeinifar@agh.edu.pl")
                    }
                }
            }
        }

        // License Section
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            color: Qt.darker(bgColor, 1.15)
            radius: 5
            border.color: elementsColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                Text {
                    text: "MIT License"
                    font.pixelSize: 11
                    font.bold: true
                    color: textColor
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded

                    TextArea {
                        readOnly: true
                        text: "Copyright (c) 2024 Vahid Moeinifar\n\n" +
                              "Permission is hereby granted, free of charge, to any person obtaining a copy " +
                              "of this software and associated documentation files (the \"Software\"), to deal " +
                              "in the Software without restriction, including without limitation the rights " +
                              "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell " +
                              "copies of the Software, and to permit persons to whom the Software is " +
                              "furnished to do so, subject to the following conditions:\n\n" +
                              "The above copyright notice and this permission notice shall be included in all " +
                              "copies or substantial portions of the Software.\n\n" +
                              "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR " +
                              "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, " +
                              "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE " +
                              "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER " +
                              "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, " +
                              "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 9
                        color: Qt.lighter(textColor, 1.3)
                        background: Rectangle {
                            color: "transparent"
                        }
                    }
                }
            }
        }

        // Close button
        MyButton {
            mainColor: elementsColor
            Layout.alignment: Qt.AlignHCenter
            _width: 100
            _height: 30
            text: "Close"
            onClicked: aboutWindow.close()
        }
    }
}
