import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import GDSS 1.0

ApplicationWindow {

    property color bgColor: "#162026"
    property color textColor: "#F7F4E9"
    property color elementsColor: "#4E8AAD"
    property color elementsColor_lighter: "#72ACCC"
    property color removeColor: "#E8514A"
    property color removeColor_lighter: "#EB7A75"

    id: root
    width: 500
    height: 600
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
        onPythonError: console.log("Python error: " + msg)
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

            Item {
                id: manualArea
                width: root.width/2 - 40
                height: 400

                ColumnLayout {
                    spacing: 10

                    Text {
                        text: "Manulaly add agents Value:"
                        font.pixelSize: 12
                        color: textColor
                    }


                    RowLayout {
                        spacing: 10

                        MyTextfield {
                            mainColor: elementsColor
                            secondColor: elementsColor_lighter
                            _width: 100
                            _height: 30
                            id: valueInput
                            placeholderText: "e.g. 0.75"


                            Layout.fillWidth: true

                            validator: DoubleValidator {
                                bottom: 0.0
                                top: 1.0
                            }
                        }

                        MyButton {
                            mainColor: elementsColor
                            secondColor: elementsColor_lighter
                            _width: 60
                            _height: 30
                            text: "Add"
                            onClicked: {
                                if (valueInput.text.length === 0)
                                    return

                                agentModel.append({ "value": parseFloat(valueInput.text) })
                                valueInput.text = ""
                            }
                        }
                    }

                    Text {
                        text: "Agent Inputs:"
                        font.pixelSize: 12
                        color: textColor

                    }

                    ListView {
                        id: list
                        width: 30
                        height: 100
                        model: agentModel

                        delegate: RowLayout {
                            spacing: 30
                            Text {
                                text: value.toFixed(3)
                                font.pixelSize: 12
                                color: textColor

                            }

                            MyButton {
                                mainColor: removeColor
                                secondColor: removeColor_lighter
                                _width: 60
                                _height: 12
                                text: "Remove"
                                font.pixelSize: 10
                                onClicked: agentModel.remove(index)
                            }
                        }
                    }

                }


            }

            SpaceLine_V {}

            Item {
                id: copyTextArea
                width: root.width/2 - 50
                height: 400

                ColumnLayout {
                    spacing: 20

                    Text {
                        text: "Copy and paste comma seprarted agents value:"
                        wrapMode: Text.Wrap
                        width: 40 // Set a maximum width to force wrapping
                        font.pixelSize: 12
                        color: textColor
                    }

                    RowLayout {
                        spacing: 10

                        MyTextfArea {
                            mainColor: elementsColor
                            secondColor: elementsColor_lighter
                            _width: 250
                            _height: 300
                            id: valueInputii
                            placeholderText: "e.g. 0.75,1.25,0.23"
                        }
                    }
                }
            }
        }
        MyButton {
            text: "Run Fusion"
            Layout.fillWidth: true
            enabled: agentModel.count > 0

            onClicked: {
                let arr = []
                for (let i = 0; i < agentModel.count; i++)
                    arr.push(agentModel.get(i).value)

                engine.runFusion(arr)
            }
        }

        SpaceLine{}

        Text {
            id: resultLabel
            text: "Fused Result: " + engine.fusedValue.toFixed(4)
            font.pixelSize: 20
            color: textColor
            anchors.horizontalCenter: parent.horizontalCenter
        }


    }
}
