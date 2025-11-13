import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import GDSS 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: "GDSS Simulator"

    DecisionEngine {
        id: engine
        onFusedValueChanged: resultLabel.text = "Fused Result: " + fusedValue.toFixed(2)
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        TextField {
            id: inputField
            placeholderText: "Enter agent value"
            validator: DoubleValidator {}
            Layout.fillWidth: true
        }

        RowLayout {
            Button {
                text: "Add Value"
                onClicked: {
                    if (inputField.text !== "") {
                        engine.addAgentValue(parseFloat(inputField.text))
                        inputField.text = ""
                    }
                }
            }

            Button {
                text: "Compute Fusion"
                onClicked: engine.computeFusion()
            }

            Button {
                text: "Clear"
                onClicked: engine.clearValues()
            }
        }

        Label {
            id: resultLabel
            text: "Fused Result: --"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
