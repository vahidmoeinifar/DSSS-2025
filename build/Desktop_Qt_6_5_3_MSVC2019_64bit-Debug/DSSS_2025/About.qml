import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: aboutDialog
    title: "About GDSS Simulator"
    modal: true
    standardButtons: Dialog.Ok

    width: 400
    height: 500
    implicitHeight: contentLayout.implicitHeight + 100

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        spacing: 10

        Text {
            text: "GDSS Simulator v1.0"
            font.bold: true
            font.pixelSize: 18
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Group Decision Support System based on Information Fusion and AI Methods"
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: "This system combines multiple agent views using probabilistic and AI-based fusion techniques with C++ backend and Python AI processing."
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            font.pixelSize: 11
            color: "#666666"
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#eeeeee"
        }

        // Developer Information
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            Text {
                text: "Developed by: Vahid Moeinifar"
                font.pixelSize: 12
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "AGH University of Krakow"
                font.pixelSize: 10
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Faculty of Electrical Engineering, Automatics, Computer Science and Biomedical Engineering"
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                font.pixelSize: 9
                horizontalAlignment: Text.AlignHCenter
                color: "#555555"
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#eeeeee"
        }

        // Contact Information
        Text {
            text: "vmoeinifar@agh.edu.pl"
            font.pixelSize: 10
            Layout.alignment: Qt.AlignHCenter
            color: "#2c5aa0"
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#eeeeee"
        }

        SpaceLine {}
        // MIT License Information
        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            Text {
                text: "MIT License\n\n" +
                      "Copyright (c) 2024 Vahid Moeinifar\n\n" +
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
                font.pixelSize: 8
                color: "#444444"
            }
        }
    }
}
