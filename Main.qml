import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import GDSS 1.0

ApplicationWindow {
    width: 500
    height: 600
    visible: true
    title: "GDSS Simulator"

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
        anchors.margins: 20
        spacing: 20

        Text {
            text: "Enter Agent Value"
            font.pixelSize: 20
        }

        RowLayout {
            spacing: 10

            TextField {
                id: valueInput
                placeholderText: "e.g. 0.75"
                Layout.fillWidth: true

                validator: DoubleValidator {
                    bottom: 0.0
                    top: 1.0
                }
            }

            Button {
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
            font.pixelSize: 18
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: agentModel

            delegate: RowLayout {
                spacing: 20
                Text {
                    text: value.toFixed(3)
                    font.pixelSize: 16
                }

                Button {
                    text: "Remove"
                    onClicked: agentModel.remove(index)
                }
            }
        }

        Button {
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

        Text {
            id: resultLabel
            text: "Fused Result: " + engine.fusedValue.toFixed(4)
            font.pixelSize: 20
        }
    }
}
