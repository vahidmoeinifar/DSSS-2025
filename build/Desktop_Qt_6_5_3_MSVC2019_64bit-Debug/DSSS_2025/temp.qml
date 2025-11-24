import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import GDSS 1.0

ApplicationWindow {
    width: 650
    height: 400
    visible: true
    title: "GDSS Fusion Simulator"

    DecisionEngine {
        id: engine
        onPythonError: console.log("Python error: " + msg)
    }

    ColumnLayout {
        anchors.centerIn: parent

        RowLayout {
            spacing: 10
            TextField {
                id: valueInput
                width: 120
                placeholderText: "Value"
            }

            Button {
                text: "Add Agent"
                onClicked: engine.addAgentValue(parseFloat(valueInput.text))
            }
        }

        Button {
            text: "Run Fusion (Python)"
            Layout.topMargin: 20
            onClicked: engine.runFusion()
        }

        Text {
            text: "Fusion Result = " + engine.fusedValue.toFixed(4)
            font.pixelSize: 22
            color: "red"
            Layout.topMargin: 15
        }
    }
}
