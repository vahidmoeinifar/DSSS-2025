import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import GDSS 1.0
import Qt.labs.platform 1.1 // For FileDialog

ApplicationWindow {

    property color bgColor: "#162026"
    property color textColor: "#F7F4E9"
    property color textColorDark: "#2E2E2E"
    property color textColorDisable: "#888888"
    property color elementsColor: "#396C70"
    property color removeColor: "#8F3939"
    property color successColor: "#1F7D38"
    property color warningColor: "#63261B"
    property color yellowColor: "#FFD166"
    property color cyanColor: "#4FC3F7"
    property color magentaColor: "#FF6B6B"
    property color darkScreenColor: "#0A0E12"
    property color lightGreenColor: "#4CAF50"

    id: root
    width: 1000
    height: 600
    minimumWidth: 800
    minimumHeight: 500
    visible: true
    title: "GDSS Simulator"

    background: Rectangle {
        anchors.fill: parent
        color: bgColor
    }

    HistoryPanel {
        id: historyPopup
        engine: engine
    }
    // Model holding agent values
    ListModel {
        id: agentModel
    }
    FontLoader {
        id: fontAwsomeRegular
        source: "fonts/FontAwesomeFree-Solid-900.otf"
    }
    // Model for script selection
    ListModel {
        id: scriptModel
        ListElement { name: "Neural Network"; value: "neural.py"; description: "Uses MLP neural network" }
        ListElement { name: "Weighted Average"; value: "weighted.py"; description: "Simple weighted average" }
        ListElement { name: "Fuzzy Logic"; value: "fuzzy.py"; description: "Fuzzy logic rules" }
        ListElement { name: "Random Forest"; value: "random_forest.py"; description: "Ensemble method" }
        ListElement { name: "Consensus"; value: "consensus.py"; description: "Consensus-based fusion" }
        ListElement { name: "Weighted with Confidence"; value: "weighted_with_confidence.py"; description: "weighted_with_confidence" }
    }

    // Property for custom script path
    property string customScriptPath: ""

    DecisionEngine {
        id: engine
        onPythonError: (msg) => {
                           console.log("Python error:", msg)
                           showMessage("Error: " + msg, removeColor)
                           // Hide progress bar on error
                           stopProgress()
                       }
    }

    // Main Container
    Rectangle {
        anchors.fill: parent
        anchors.margins: 10
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            // Header
            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: Qt.darker(bgColor, 1.2)
                radius: 5
                border.color: elementsColor
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    Text {
                        text: "GDSS Simulator"
                        font.pixelSize: 20
                        font.bold: true
                        color: textColor
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "transparent"
                    }
                    MyMenu {
                        id: myMenu
                        anchors.verticalCenter: parent.verticalCenter
                        width: 40
                        height: 40

                        // Handle data loaded from file - directly load to model
                        onDataLoaded: function(values, fileName) {
                            if (values && values.length > 0) {
                                // Directly load values into model
                                for (var i = 0; i < values.length; i++) {
                                    agentModel.append({ "value": values[i] })
                                }
                                showMessage("Loaded " + values.length + " values from " + fileName, successColor)
                            } else {
                                showMessage("No valid values found in file", warningColor)
                            }
                        }

                        // Handle messages from MyMenu
                        onShowMessage: function(message, color) {
                            showMessage(message, color)
                        }
                    }
                }
            }

            // Main Content Area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    spacing: 15

                    // Left Panel - Input Section
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width * 0.35
                        color: Qt.darker(bgColor, 1.1)
                        radius: 5
                        border.color: elementsColor
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 15

                            // Manual Input Section
                            ColumnLayout {
                                spacing: 10

                                Text {
                                    text: "Input Agents"
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: textColor
                                }

                                RowLayout {
                                       spacing: 10

                                       MyTextfield {
                                           id: valueInput
                                           placeholderText: "Value (0-1)"
                                           validator: DoubleValidator { bottom: 0.0; top: 1.0 }
                                           Layout.fillWidth: true

                                           // Clear on Enter
                                           onAccepted: {
                                               addAgentButton.clicked()
                                           }
                                       }

                                       MyTextfield {
                                           id: confidenceInput
                                           placeholderText: "Confidence"
                                           text: "1.0"
                                           validator: DoubleValidator { bottom: 0.0; top: 1.0 }
                                           Layout.preferredWidth: 80

                                           // Clear on Enter
                                           onAccepted: {
                                               addAgentButton.clicked()
                                           }
                                       }

                                       MyButton {
                                           id: addAgentButton
                                           mainColor: elementsColor
                                           _width: 60
                                           _height: 30
                                           text: "Add"
                                           onClicked: {
                                               if (valueInput.text.length === 0) return

                                               var value = parseFloat(valueInput.text)
                                               var confidence = parseFloat(confidenceInput.text || "1.0")

                                               // Clamp values
                                               value = Math.max(0, Math.min(1, value))
                                               confidence = Math.max(0, Math.min(1, confidence))

                                               agentModel.append({
                                                   "value": value,
                                                   "confidence": confidence
                                               })

                                               valueInput.text = ""
                                               confidenceInput.text = "1.0"
                                               valueInput.focus = true
                                           }
                                       }
                                   }

                                   MyButton {
                                       id: openDataButton
                                       mainColor: Qt.lighter(elementsColor, 1.2)
                                       Layout.fillWidth: true
                                       _height: 35
                                       text: "📂 Open Data"
                                       font.pixelSize: 12
                                       onClicked: dataFileDialog.open()
                                   }

                                // Batch Input Section
                                ColumnLayout {
                                    spacing: 10
                                    Layout.topMargin: 10

                                    Text {
                                        text: "Batch Input"
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: textColor
                                    }

                                    MyTextfArea {
                                        id: valueInputii
                                        mainColor: elementsColor
                                        secondColor: Qt.lighter(elementsColor)
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 100
                                        placeholderText: "Or enter comma-separated values (0.75, 0.5, 0.25)..."
                                        font.pixelSize: 11
                                    }

                                    RowLayout {
                                        spacing: 10

                                        MyButton {
                                            id: parseButton
                                            mainColor: elementsColor
                                            Layout.fillWidth: true
                                            _height: 35
                                            text: "Parse & Add"
                                            font.pixelSize: 11
                                            enabled: valueInputii.text.length > 0
                                            onClicked: {
                                                if (valueInputii.text.length === 0) {
                                                    showMessage("Please enter some values", warningColor)
                                                    return
                                                }

                                                var text = valueInputii.text.trim()
                                                var valuePairs = text.split(',').map(function(v) {
                                                    return v.trim()
                                                })

                                                var validPairs = []
                                                var invalidCount = 0

                                                for (var i = 0; i < valuePairs.length; i++) {
                                                    var pair = valuePairs[i]

                                                    // Check if it's a value:confidence pair
                                                    var parts = pair.split(':')
                                                    var val, confidence = 1.0

                                                    if (parts.length === 2) {
                                                        // Has confidence: e.g., "0.75:0.8"
                                                        val = parseFloat(parts[0])
                                                        confidence = parseFloat(parts[1])
                                                    } else {
                                                        // Just value: e.g., "0.75"
                                                        val = parseFloat(pair)
                                                    }

                                                    if (!isNaN(val) && val >= 0 && val <= 1 &&
                                                        !isNaN(confidence) && confidence >= 0 && confidence <= 1) {
                                                        validPairs.push({value: val, confidence: confidence})
                                                    } else {
                                                        invalidCount++
                                                    }
                                                }

                                                if (validPairs.length > 0) {
                                                    for (var j = 0; j < validPairs.length; j++) {
                                                        agentModel.append(validPairs[j])
                                                    }

                                                    showMessage("Added " + validPairs.length + " valid agents" +
                                                                (invalidCount > 0 ? " (" + invalidCount + " invalid ignored)" : ""),
                                                                successColor)
                                                    valueInputii.text = ""
                                                } else {
                                                    showMessage("No valid values found (format: value or value:confidence)", warningColor)
                                                }
                                            }
                                        }

                                        MyButton {
                                            id: clearAllButton
                                            mainColor: removeColor
                                            _width: 100
                                            _height: 35
                                            text: "Clear All"
                                            font.pixelSize: 11
                                            onClicked: {
                                                agentModel.clear()
                                                showMessage("All values cleared", warningColor)
                                            }
                                        }
                                    }
                                }
                                // Agent List
                                ColumnLayout {
                                    spacing: 5
                                    Text {
                                        text: "Agent Values (" + agentModel.count + ")"
                                        font.pixelSize: 12
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
                                            id: list
                                            anchors.fill: parent
                                            anchors.margins: 5
                                            clip: true
                                            model: agentModel
                                            spacing: 2

                                            delegate: Rectangle {
                                                width: list.width
                                                height: 50  // Increased height for confidence slider
                                                color: index % 2 === 0 ? Qt.darker(bgColor, 1.1) : Qt.darker(bgColor, 1.15)
                                                radius: 3

                                                ColumnLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: 5
                                                    spacing: 2

                                                    // Top row: Agent info and remove button
                                                    RowLayout {
                                                        Layout.fillWidth: true

                                                        Text {
                                                            text: "Agent " + (index + 1)
                                                            font.pixelSize: 11
                                                            color: textColor
                                                            Layout.preferredWidth: 60
                                                        }

                                                        Text {
                                                            text: value.toFixed(4)
                                                            font.pixelSize: 11
                                                            color: textColor
                                                            Layout.fillWidth: true
                                                        }

                                                        Text {
                                                            text: (confidence * 100).toFixed(0) + "%"
                                                            font.pixelSize: 11
                                                            color: confidence > 0.7 ? lightGreenColor :
                                                                   confidence > 0.4 ? yellowColor : magentaColor
                                                            font.bold: true
                                                            Layout.preferredWidth: 50
                                                        }

                                                        MyButton {
                                                            mainColor: removeColor
                                                            _width: 25
                                                            _height: 20
                                                            text: "×"
                                                            font.pixelSize: 10
                                                            font.bold: true
                                                            onClicked: agentModel.remove(index)
                                                        }
                                                    }

                                                    // Bottom row: Confidence slider
                                                    RowLayout {
                                                        Layout.fillWidth: true
                                                        spacing: 5

                                                        Slider {
                                                            id: confidenceSlider
                                                            from: 0.0
                                                            to: 1.0
                                                            value: confidence
                                                            stepSize: 0.01
                                                            Layout.fillWidth: true

                                                            onMoved: {
                                                                agentModel.setProperty(index, "confidence", value)
                                                            }

                                                            background: Rectangle {
                                                                implicitWidth: 200
                                                                implicitHeight: 4
                                                                color: Qt.darker(elementsColor, 1.5)
                                                                radius: 2
                                                            }

                                                            handle: Rectangle {
                                                                x: confidenceSlider.leftPadding + confidenceSlider.visualPosition *
                                                                   (confidenceSlider.availableWidth - width)
                                                                y: confidenceSlider.topPadding + confidenceSlider.availableHeight / 2 - height / 2
                                                                implicitWidth: 16
                                                                implicitHeight: 16
                                                                radius: 8
                                                                color: confidenceSlider.pressed ? Qt.lighter(elementsColor, 1.3) : elementsColor
                                                                border.color: Qt.darker(elementsColor, 1.5)
                                                                border.width: 2
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                        }
                    }

                    // Middle Panel - Configuration
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width * 0.35
                        color: Qt.darker(bgColor, 1.1)
                        radius: 5
                        border.color: elementsColor
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 15

                            // Algorithm Selection
                            ColumnLayout {
                                spacing: 10

                                Text {
                                    text: "Fusion Algorithm"
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: textColor
                                }

                                MyCombobox {
                                    id: scriptComboBox
                                    model: scriptModel
                                    Layout.fillWidth: true
                                }

                                RowLayout {
                                    spacing: 10

                                    MyButton {
                                        mainColor: Qt.lighter(elementsColor, 1.2)
                                        Layout.fillWidth: true
                                        _height: 35
                                        text: "Info"
                                        font.pixelSize: 11
                                        onClicked: {
                                            if (scriptComboBox.currentIndex >= 0) {
                                                var selected = scriptModel.get(scriptComboBox.currentIndex)
                                                if (selected.value.includes('/') || selected.value.includes('\\')) {
                                                    customScriptPopup.name = selected.name
                                                    customScriptPopup.path = selected.value
                                                    customScriptPopup.open()
                                                } else {
                                                    scriptInfoPopup.name = selected.name
                                                    scriptInfoPopup.description = selected.description
                                                    scriptInfoPopup.file = selected.value
                                                    scriptInfoPopup.open()
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            // Custom Script Section
                            ColumnLayout {
                                spacing: 10
                                Layout.topMargin: 10

                                Text {
                                    text: "Custom Script"
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: textColor
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 80
                                    color: Qt.darker(bgColor, 1.2)
                                    radius: 5
                                    border.color: elementsColor
                                    border.width: 1

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 5

                                        Text {
                                            text: customScriptPath === "" ? "No custom script loaded" :
                                                                            customScriptPath.split('/').pop().split('\\').pop()
                                            font.pixelSize: 11
                                            color: customScriptPath === "" ? Qt.lighter(textColor, 1.5) : successColor
                                            Layout.fillWidth: true
                                            elide: Text.ElideMiddle
                                        }

                                        RowLayout {
                                            spacing: 5

                                            MyButton {
                                                mainColor: elementsColor
                                                Layout.fillWidth: true
                                                _height: 25
                                                text: "📂 Load Script"
                                                font.pixelSize: 10
                                                onClicked: fileDialog.open()
                                            }

                                            MyButton {
                                                mainColor: removeColor
                                                Layout.fillWidth: true
                                                _height: 25
                                                text: "Remove"
                                                font.pixelSize: 10
                                                enabled: customScriptPath !== ""
                                                onClicked: {
                                                    customScriptPath = ""
                                                    showMessage("Custom script removed", warningColor)
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            // Status Display
                            ColumnLayout {
                                spacing: 10
                                Layout.topMargin: 10

                                Text {
                                    text: "System Status"
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: textColor
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 80
                                    color: Qt.darker(bgColor, 1.2)
                                    radius: 5
                                    border.color: elementsColor
                                    border.width: 1

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 5

                                        RowLayout {
                                            Text {
                                                text: "Agents:"
                                                font.pixelSize: 11
                                                color: textColor
                                                font.bold: true
                                            }

                                            Text {
                                                text: agentModel.count
                                                font.pixelSize: 11
                                                color: successColor
                                                font.bold: true
                                                Layout.fillWidth: true
                                            }
                                        }

                                        RowLayout {
                                            Text {
                                                text: "Algorithm:"
                                                font.pixelSize: 11
                                                color: textColor
                                                font.bold: true
                                            }

                                            Text {
                                                text: scriptComboBox.currentIndex >= 0 ?
                                                          scriptModel.get(scriptComboBox.currentIndex).name : "None"
                                                font.pixelSize: 11
                                                color: Qt.lighter(elementsColor, 1.3)
                                                font.bold: true
                                                Layout.fillWidth: true
                                                elide: Text.ElideRight
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Right Panel - Results
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: Qt.darker(bgColor, 1.1)
                        radius: 5
                        border.color: elementsColor
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 15

                            // Results Display
                            ColumnLayout {
                                spacing: 10
                                Layout.fillHeight: true


                                Text {
                                    text: "Fusion Results"
                                    font.pixelSize: 20
                                    font.bold: true
                                    color: textColor
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: scriptComboBox.currentIndex >= 0 ?
                                              scriptModel.get(scriptComboBox.currentIndex).name : "No algorithm selected"
                                    font.pixelSize: 12
                                    color: Qt.lighter(textColor, 1.3)
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                // Result Value
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 120
                                    color: Qt.darker(bgColor, 1.2)
                                    radius: 8
                                    border.color: elementsColor
                                    border.width: 2

                                    Text {
                                        text: engine.fusedValue.toFixed(4)
                                        font.pixelSize: 48
                                        font.bold: true
                                        color: {
                                            if (engine.fusedValue === 0) return textColor
                                            if (engine.fusedValue < 0.3) return magentaColor  // Red for low
                                            if (engine.fusedValue < 0.7) return yellowColor  // Yellow for medium
                                            return lightGreenColor
                                        }
                                        anchors.centerIn: parent
                                    }
                                }

                                MyButton {
                                    id: runFusionButton
                                    mainColor: elementsColor
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 45
                                    text: "Run Fusion"
                                    font.pixelSize: 14
                                    font.bold: true
                                    enabled: agentModel.count > 0 && scriptComboBox.currentIndex >= 0

                                    onClicked: {
                                        let values = []
                                        let confidences = []

                                        for (let i = 0; i < agentModel.count; i++) {
                                            let agent = agentModel.get(i)
                                            values.push(agent.value)
                                            confidences.push(agent.confidence)
                                        }

                                        var selected = scriptModel.get(scriptComboBox.currentIndex)

                                        startProgress()
                                        messageText.text = "Running " + selected.name + " with " + agentModel.count + " agents..."

                                        if (selected.value === "weighted.py" || selected.value === "weighted_with_confidence.py") {
                                            engine.runFusionWithConfidence(values, confidences, selected.value)
                                        } else {
                                            engine.runFusion(values, selected.value)
                                        }
                                    }
                                }
                                MyButton {
                                    id: runAllButton
                                    mainColor: elementsColor
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 40
                                    text: "Compare Algorithms"
                                    font.pixelSize: 13
                                    enabled: agentModel.count > 0

                                    onClicked: {
                                        let values = []
                                        let confidences = []
                                        let scripts = []

                                        for (let i = 0; i < agentModel.count; i++) {
                                            let agent = agentModel.get(i)
                                            values.push(agent.value)
                                            confidences.push(agent.confidence)
                                        }

                                        for (let i = 0; i < scriptModel.count; i++)
                                            scripts.push(scriptModel.get(i).value)

                                        // Clear previous results
                                        comparisonPopup.comparisonData.clear()

                                        // Connect to finished signal
                                        engine.comparisonFinished.connect(function() {
                                            comparisonPopup.loadComparisonData()
                                        })

                                        // Use the confidence-aware comparison
                                        engine.runComparisonWithConfidence(values, confidences, scripts)
                                        comparisonPopup.open()
                                    }
                                }

                                Result{ id: comparisonPopup }

                                   // Clear Results Button
                                   MyButton {
                                    mainColor: removeColor
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 35
                                    text: "Clear Results"
                                    font.pixelSize: 12
                                    onClicked: {
                                        engine.clearValues()
                                        showMessage("Results cleared", warningColor)
                                    }
                                }
                            }

                              // Progress Bar Area
                            ColumnLayout {
                                spacing: 10
                                Layout.fillWidth: true

                                // Progress Bar
                                Rectangle {
                                    id: progressBar
                                    Layout.fillWidth: true
                                    height: 20
                                    radius: 10
                                    color: Qt.darker(bgColor, 1.3)
                                    border.color: elementsColor
                                    border.width: 1
                                    visible: false
                                    clip: true

                                    // Inner progress indicator
                                    Rectangle {
                                        id: progressIndicator
                                        width: parent.width * 0.3
                                        height: parent.height
                                        radius: parent.radius
                                        color: elementsColor

                                        gradient: Gradient {
                                            GradientStop { position: 0.0; color: elementsColor }
                                            GradientStop { position: 0.5; color: Qt.lighter(elementsColor, 1.3) }
                                            GradientStop { position: 1.0; color: elementsColor }
                                        }
                                    }

                                    // Text overlay
                                    Text {
                                        text: "Processing..."
                                        font.pixelSize: 10
                                        color: textColor
                                        font.bold: true
                                        anchors.centerIn: parent
                                        visible: progressBar.visible
                                    }
                                }

                                // Status Messages
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 40
                                    color: Qt.darker(bgColor, 1.2)
                                    radius: 5
                                    border.color: elementsColor
                                    border.width: 1

                                    Text {
                                        id: messageText
                                        text: "Ready"
                                        font.pixelSize: 12
                                        color: textColor
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // File Dialog for opening data files
    FileDialog {
        id: dataFileDialog
        title: "Open Data File"
        nameFilters: ["Text files (*.txt)", "CSV files (*.csv)", "All files (*)"]

        onAccepted: {
            var filePath = dataFileDialog.file.toString()
            // Convert file URL to local path
            if (filePath.startsWith("file:///")) {
                filePath = filePath.substring(8) // Windows
            } else if (filePath.startsWith("file://")) {
                filePath = filePath.substring(7) // Unix/Mac
            }

            // Load data directly from file
            loadDataFromFileDirectly(filePath)
        }
    }

    // Function to load data from file directly into model
    function loadDataFromFileDirectly(filePath) {
        console.log("Loading CSV file:", filePath)

        var xhr = new XMLHttpRequest()
        var fileUrl = filePath

        if (!filePath.startsWith("file://")) {
            if (Qt.platform.os === "windows") {
                fileUrl = "file:///" + filePath
            } else {
                fileUrl = "file://" + filePath
            }
        }

        xhr.open("GET", fileUrl)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || xhr.status === 0) {
                    var content = xhr.responseText
                    console.log("File content (first 500 chars):", content.substring(0, 500))

                    var lines = content.split('\n')
                    var validAgents = []
                    var invalidCount = 0
                    var fileName = filePath.split('/').pop().split('\\').pop()
                    var hasHeader = false

                    // Check if first line is a header
                    if (lines.length > 0) {
                        var firstLine = lines[0].toLowerCase().trim()
                        if (firstLine.includes('value') || firstLine.includes('confidence') ||
                            firstLine.includes('agent')) {
                            hasHeader = true
                            console.log("Detected CSV header, skipping first line")
                        }
                    }

                    for (var i = (hasHeader ? 1 : 0); i < lines.length; i++) {
                        var line = lines[i].trim()

                        // Skip empty lines and comments
                        if (line.length === 0 || line.startsWith('#') || line.startsWith('//')) {
                            continue
                        }

                        console.log("Parsing line:", line)

                        var value = NaN
                        var confidence = 1.0
                        var parts = []

                        // Try different CSV parsing methods
                        if (line.includes(',')) {
                            // Standard CSV format
                            parts = line.split(',')
                            console.log("CSV parts:", parts.length, parts)

                            if (parts.length >= 2) {
                                // Format: value,confidence,... (more columns)
                                value = parseFloat(parts[0].trim())
                                confidence = parseFloat(parts[1].trim())
                            } else if (parts.length === 1) {
                                // Just value, default confidence
                                value = parseFloat(parts[0].trim())
                                confidence = 1.0
                            }
                        } else if (line.includes(';')) {
                            // European CSV format (semicolon)
                            parts = line.split(';')
                            if (parts.length >= 2) {
                                value = parseFloat(parts[0].trim())
                                confidence = parseFloat(parts[1].trim())
                            }
                        } else if (line.includes('\t')) {
                            // TSV format
                            parts = line.split('\t')
                            if (parts.length >= 2) {
                                value = parseFloat(parts[0].trim())
                                confidence = parseFloat(parts[1].trim())
                            }
                        } else if (line.includes(':')) {
                            // value:confidence format
                            parts = line.split(':')
                            if (parts.length >= 2) {
                                value = parseFloat(parts[0].trim())
                                confidence = parseFloat(parts[1].trim())
                            }
                        } else {
                            // Single value only
                            value = parseFloat(line)
                            confidence = 1.0
                        }

                        console.log("Parsed - Value:", value, "Confidence:", confidence)

                        // Validate both value and confidence
                        var valueValid = !isNaN(value) && value >= 0 && value <= 1
                        var confidenceValid = !isNaN(confidence) && confidence >= 0 && confidence <= 1

                        if (valueValid && confidenceValid) {
                            validAgents.push({
                                value: value,
                                confidence: confidence
                            })
                            console.log("✓ Valid agent added")
                        } else {
                            invalidCount++
                            console.log("✗ Invalid - Value valid:", valueValid, "Confidence valid:", confidenceValid)
                        }
                    }

                    console.log("Parsing complete - Valid:", validAgents.length, "Invalid:", invalidCount)

                    if (validAgents.length > 0) {
                        // Clear existing agents first
                        agentModel.clear()

                        for (var k = 0; k < validAgents.length; k++) {
                            agentModel.append(validAgents[k])
                        }

                        var message = "Loaded " + validAgents.length + " agents from " + fileName
                        if (invalidCount > 0) {
                            message += " (" + invalidCount + " invalid entries ignored)"
                        }
                        showMessage(message, successColor)

                        // Show sample of loaded data
                        console.log("Sample loaded agents (first 3):")
                        for (var s = 0; s < Math.min(3, validAgents.length); s++) {
                            console.log("  Agent", s+1, ":", validAgents[s])
                        }
                    } else {
                        showMessage("No valid agents found in file. Expected format: value,confidence", warningColor)
                    }
                } else {
                    console.error("Failed to read file, status:", xhr.status)
                    showMessage("Failed to read file: " + xhr.statusText, removeColor)
                }
            }
        }

        xhr.onerror = function() {
            console.error("XHR error occurred")
            showMessage("Error reading file. Check if file exists and is accessible.", removeColor)
        }

        xhr.send()
    }

    // Script Info Popup
    Popup {
        id: scriptInfoPopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 400
        height: 250
        modal: true
        focus: true
        dim: true

        property string name: ""
        property string description: ""
        property string file: ""

        background: Rectangle {
            color: Qt.darker(bgColor, 1.1)
            radius: 5
            border.color: elementsColor
            border.width: 2
        }

        contentItem: ColumnLayout {
            spacing: 10
            anchors.margins: 20

            Text {
                text: scriptInfoPopup.name
                font.pixelSize: 18
                font.bold: true
                color: textColor
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: elementsColor
            }

            Text {
                text: "Description:"
                font.pixelSize: 12
                font.bold: true
                color: textColor
            }

            Text {
                text: scriptInfoPopup.description
                font.pixelSize: 11
                color: Qt.lighter(textColor, 1.2)
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Text {
                text: "Script File:"
                font.pixelSize: 12
                font.bold: true
                color: textColor
                Layout.topMargin: 10
            }

            Text {
                text: scriptInfoPopup.file
                font.pixelSize: 11
                color: Qt.lighter(textColor, 1.5)
                font.italic: true
                wrapMode: Text.WrapAnywhere
                Layout.fillWidth: true
            }

            MyButton {
                mainColor: elementsColor
                Layout.alignment: Qt.AlignHCenter
                _width: 100
                _height: 30
                text: "Close"
                onClicked: scriptInfoPopup.close()
            }
        }
    }

    // Custom Script Popup
    Popup {
        id: customScriptPopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 450
        height: 300
        modal: true
        focus: true
        dim: true

        property string name: ""
        property string path: ""

        background: Rectangle {
            color: Qt.darker(bgColor, 1.1)
            radius: 5
            border.color: successColor
            border.width: 2
        }

        contentItem: ColumnLayout {
            spacing: 10
            anchors.margins: 20

            Text {
                text: "Custom Script"
                font.pixelSize: 18
                font.bold: true
                color: successColor
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: successColor
            }

            Text {
                text: "Script Name:"
                font.pixelSize: 12
                font.bold: true
                color: textColor
            }

            Text {
                text: customScriptPopup.name
                font.pixelSize: 14
                color: textColor
                font.bold: true
                Layout.fillWidth: true
                wrapMode: Text.Wrap
            }

            Text {
                text: "Full Path:"
                font.pixelSize: 12
                font.bold: true
                color: textColor
                Layout.topMargin: 10
            }

            Text {
                text: customScriptPopup.path
                font.pixelSize: 10
                color: Qt.lighter(textColor, 1.3)
                font.italic: true
                wrapMode: Text.WrapAnywhere
                Layout.fillWidth: true
                Layout.maximumHeight: 80
            }

            Text {
                text: "This is a custom Python script. Make sure it follows the required format:\n" +
                      "1. Reads JSON from stdin\n" +
                      "2. Returns JSON with 'fused' key\n" +
                      "3. Outputs valid JSON to stdout"
                font.pixelSize: 10
                color: Qt.lighter(textColor, 1.5)
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.topMargin: 10
            }

            MyButton {
                mainColor: successColor
                Layout.alignment: Qt.AlignHCenter
                _width: 100
                _height: 30
                text: "Close"
                onClicked: customScriptPopup.close()
            }
        }
    }


    // File Dialog for selecting custom scripts
    FileDialog {
        id: fileDialog
        title: "Select Python Script"
        nameFilters: ["Python files (*.py)", "All files (*)"]

        onAccepted: {
            var filePath = fileDialog.file
            // Handle different platform file paths
            if (Qt.platform.os === "windows") {
                // On Windows, remove "file:///" prefix
                if (filePath.toString().startsWith("file:///")) {
                    filePath = filePath.toString().substring(8)
                }
            } else {
                // On Linux/Mac, remove "file://" prefix
                if (filePath.toString().startsWith("file://")) {
                    filePath = filePath.toString().substring(7)
                }
            }

            customScriptPath = filePath

            var scriptName = customScriptPath.split('/').pop().split('\\').pop()
            scriptModel.append({
                                   "name": scriptName.replace('.py', ' (Custom)'),
                                   "value": customScriptPath,
                                   "description": "Custom Python script from " + customScriptPath
                               })
            showMessage("Custom script added to algorithm list", successColor)

        }
    }

    // Progress Animation
    SequentialAnimation {
        id: progressAnimation
        running: false
        loops: Animation.Infinite

        PropertyAnimation {
            target: progressIndicator
            property: "x"
            from: -progressIndicator.width
            to: progressBar.width
            duration: 1500
            easing.type: Easing.InOutQuad
        }
    }

    // Function to show messages
    function showMessage(msg, color) {
        messageText.text = msg
        messageText.color = color
        messageTimer.restart()
    }

    // Function to start progress bar
    function startProgress() {
        progressBar.visible = true
        progressAnimation.start()
    }

    // Function to stop progress bar
    function stopProgress() {
        progressBar.visible = false
        progressAnimation.stop()
        progressIndicator.x = 0
    }

    Timer {
        id: messageTimer
        interval: 3000
        onTriggered: {
            messageText.text = "Ready"
            messageText.color = textColor
        }
    }

    // Connections to handle progress bar
    Connections {
        target: engine

        // When fusion completes
        function onFusedValueChanged() {
            stopProgress()
            showMessage("Fusion complete! Result: " + engine.fusedValue.toFixed(4), successColor)
        }

        // When error occurs
        function onPythonError(msg) {
            stopProgress()
        }
    }

    // Keyboard shortcuts
    Shortcut {
        sequence: "Enter"
        onActivated: {
            if (valueInput.focus) {
                addButton.clicked()
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+Return"
        onActivated: parseButton.clicked()
    }

    Shortcut {
        sequence: "Ctrl+O"
        onActivated: fileDialog.open()
    }

    Component.onCompleted: {
        // Select first script by default
        scriptComboBox.currentIndex = 0
        showMessage("Ready to fuse decisions", elementsColor)
    }
}
