import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import GDSS 1.0

ApplicationWindow {
    property color bgColor: "#162026"
    property color textColor: "#F7F4E9"
    property color elementsColor: "#396C70"
    property color removeColor: "#8F3939"
    property color successColor: "#4CAF50"
    property color warningColor: "#FF9800"

    id: root
    width: 500
    height: 680  // Increased height to accommodate new UI elements
    visible: true
    title: "GDSS Simulator"

    background: Rectangle {
        anchors.fill: parent
        color: bgColor
    }

    // Model holding agent values
    ListModel {
        id: agentModel
    }

    DecisionEngine {
        id: engine
        onPythonError: (msg) => {
            console.log("Python error:", msg)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        anchors.margins: 10

        MyMenu { }

        Text {
            text: "GDSS Simulator"
            font.pixelSize: 24
            color: textColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        SpaceLine {}

        RowLayout {
            spacing: 20
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                id: manualArea
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Text {
                        text: "Manually add agents Value:"
                        font.pixelSize: 12
                        color: textColor
                    }

                    RowLayout {
                        spacing: 10

                        MyTextfield {
                            mainColor: elementsColor
                            secondColor: Qt.lighter(elementsColor)
                            _width: 100
                            _height: 30
                            id: valueInput
                            placeholderText: "e.g. 0.75"
                            Layout.fillWidth: true

                            validator: DoubleValidator {
                                bottom: 0.0
                                top: 1.0
                            }
                            onAccepted: addButton.clicked()
                        }

                        MyButton {
                            id: addButton
                            mainColor: elementsColor
                            _width: 60
                            _height: 30
                            text: "Add"
                            onClicked: {
                                if (valueInput.text.length === 0)
                                    return

                                var val = parseFloat(valueInput.text)
                                if (val >= 0 && val <= 1) {
                                    agentModel.append({ "value": val })
                                    valueInput.text = ""
                                    valueInput.focus = true
                                } else {
                                    // Show error
                                    valueInput.text = ""
                                    valueInput.placeholderText = "Value must be 0-1"
                                    valueInput.color = warningColor
                                    Qt.callLater(function() {
                                        valueInput.placeholderText = "e.g. 0.75"
                                        valueInput.color = textColor
                                    })
                                }
                            }
                        }
                    }

                    Text {
                        text: "Agent Inputs:"
                        font.pixelSize: 12
                        color: textColor
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent"
                        border.color: elementsColor
                        border.width: 1
                        radius: 5

                        ListView {
                            id: list
                            anchors.fill: parent
                            anchors.margins: 5
                            clip: true
                            model: agentModel
                            spacing: 5

                            delegate: Rectangle {
                                width: list.width
                                height: 30
                                color: "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 10

                                    Text {
                                        text: "Agent " + (index + 1) + ":"
                                        font.pixelSize: 12
                                        color: textColor
                                        Layout.preferredWidth: 60
                                    }

                                    Text {
                                        text: value.toFixed(3)
                                        font.pixelSize: 12
                                        color: textColor
                                        Layout.fillWidth: true
                                    }

                                    MyButton {
                                        mainColor: removeColor
                                        _width: 60
                                        _height: 20
                                        text: "Remove"
                                        font.pixelSize: 10
                                        onClicked: agentModel.remove(index)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            SpaceLine_V {
                Layout.fillHeight: true
            }

            Item {
                id: copyTextArea
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Text {
                        text: "Paste comma-separated values:"
                        wrapMode: Text.Wrap
                        font.pixelSize: 12
                        color: textColor
                    }

                    MyTextfArea {
                        mainColor: elementsColor
                        secondColor: Qt.lighter(elementsColor)
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        id: valueInputii
                        placeholderText: "e.g. 0.75, 1.0, 0.23, 0.5"

                        // Clear button
                        MyButton {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 5
                            mainColor: removeColor
                            _width: 60
                            _height: 20
                            text: "Clear"
                            font.pixelSize: 10
                            onClicked: {
                                valueInputii.text = ""
                                valueInputii.focus = true
                            }
                        }
                    }

                    RowLayout {
                        spacing: 10

                        MyButton {
                            id: parseButton
                            mainColor: elementsColor
                            Layout.fillWidth: true
                            _height: 30
                            text: "Parse and Add to List"
                            onClicked: {
                                if (valueInputii.text.length === 0) {
                                    showMessage("Please enter some values", warningColor)
                                    return
                                }

                                var text = valueInputii.text.trim()
                                var values = text.split(',').map(function(v) {
                                    return v.trim()
                                })

                                var validValues = []
                                var invalidCount = 0

                                for (var i = 0; i < values.length; i++) {
                                    var val = parseFloat(values[i])
                                    if (!isNaN(val) && val >= 0 && val <= 1) {
                                        validValues.push(val)
                                    } else {
                                        invalidCount++
                                    }
                                }

                                if (validValues.length > 0) {
                                    // Clear existing model if you want, or comment this out to append
                                    // agentModel.clear()

                                    for (var j = 0; j < validValues.length; j++) {
                                        agentModel.append({ "value": validValues[j] })
                                    }

                                    showMessage("Added " + validValues.length + " valid values" +
                                               (invalidCount > 0 ? " (" + invalidCount + " invalid ignored)" : ""),
                                               successColor)
                                    valueInputii.text = ""
                                } else {
                                    showMessage("No valid values found (must be 0-1)", warningColor)
                                }
                            }
                        }

                        MyButton {
                            id: clearAllButton
                            mainColor: removeColor
                            _width: 80
                            _height: 30
                            text: "Clear All"
                            onClicked: {
                                agentModel.clear()
                                showMessage("All values cleared", warningColor)
                            }
                        }
                    }

                    Text {
                        id: messageText
                        text: ""
                        font.pixelSize: 11
                        color: warningColor
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        visible: text.length > 0
                    }
                }
            }
        }

        SpaceLine{}

        RowLayout {
            spacing: 10

            MyButton {
                id: runFusionButton
                mainColor: elementsColor
                _height: 40
                text: "Run Fusion"
                Layout.fillWidth: true
                enabled: agentModel.count > 0

                onClicked: {
                    let arr = []
                    for (let i = 0; i < agentModel.count; i++)
                        arr.push(agentModel.get(i).value)

                    engine.runFusion(arr)
                    showMessage("Running fusion with " + agentModel.count + " agents...", elementsColor)
                }
            }

            MyButton {
                mainColor: warningColor
                _width: 100
                _height: 40
                text: "Clear Results"
                onClicked: {
                    engine.clearValues()
                    showMessage("Results cleared", warningColor)
                }
            }
        }

        SpaceLine{}

        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: Qt.lighter(bgColor, 1.2)
            radius: 5
            border.color: elementsColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "Fused Result:"
                    font.pixelSize: 14
                    color: textColor
                }

                Text {
                    id: resultLabel
                    text: engine.fusedValue.toFixed(4)
                    font.pixelSize: 24
                    font.bold: true
                    color: engine.fusedValue > 0 ? successColor : textColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Text {
            text: "Total Agents: " + agentModel.count
            font.pixelSize: 12
            color: textColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Function to show temporary messages
    function showMessage(msg, color) {
        messageText.text = msg
        messageText.color = color
        messageTimer.restart()
    }

    Timer {
        id: messageTimer
        interval: 3000
        onTriggered: {
            messageText.text = ""
        }
    }

    // Keyboard shortcut for Enter to add values
    Shortcut {
        sequence: "Enter"
        onActivated: {
            if (valueInput.focus) {
                addButton.clicked()
            }
        }
    }

    // Keyboard shortcut for Ctrl+Enter to parse text area
    Shortcut {
        sequence: "Ctrl+Return"
        onActivated: parseButton.clicked()
    }
}
