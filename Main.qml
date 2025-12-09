import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import GDSS 1.0
import Qt.labs.platform 1.1 // For FileDialog

ApplicationWindow {
    property color bgColor: "#162026"
    property color textColor: "#F7F4E9"
    property color elementsColor: "#396C70"
    property color removeColor: "#8F3939"
    property color successColor: "#4CAF50"
    property color warningColor: "#63261B"

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

                                MyButton {
                                    id: openDataButton
                                    mainColor: Qt.lighter(elementsColor, 1.2)
                                    Layout.fillWidth: true
                                    _height: 35
                                    text: "📂 Open Data"
                                    font.pixelSize: 12

                                    onClicked: {
                                        dataFileDialog.open()
                                    }
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
                                                height: 35
                                                color: index % 2 === 0 ? Qt.darker(bgColor, 1.1) : Qt.darker(bgColor, 1.15)
                                                radius: 3

                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: 5
                                                    spacing: 10

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

                                MyButton {
                                    mainColor: customScriptPath === "" ? Qt.darker(elementsColor, 1.5) : successColor
                                    Layout.fillWidth: true
                                    _height: 35
                                    text: "Add to Algorithms"
                                    font.pixelSize: 11
                                    enabled: customScriptPath !== ""
                                    onClicked: {
                                        var scriptName = customScriptPath.split('/').pop().split('\\').pop()
                                        scriptModel.append({
                                                               "name": scriptName.replace('.py', ' (Custom)'),
                                                               "value": customScriptPath,
                                                               "description": "Custom Python script from " + customScriptPath
                                                           })
                                        showMessage("Custom script added to algorithm list", successColor)
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
                                            if (engine.fusedValue < 0.3) return "#FF6B6B"  // Red for low
                                            if (engine.fusedValue < 0.7) return "#FFD166"  // Yellow for medium
                                            return "#4CAF50"  // Your original successColor
                                        }
                                        anchors.centerIn: parent
                                    }
                                }

                                // Run Button
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
                                        let arr = []
                                        for (let i = 0; i < agentModel.count; i++)
                                            arr.push(agentModel.get(i).value)

                                        var selected = scriptModel.get(scriptComboBox.currentIndex)

                                        startProgress()
                                        messageText.text = "Running " + selected.name + " with " + agentModel.count + " agents..."

                                        engine.runFusion(arr, selected.value)
                                    }
                                }

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

    // In main.qml, replace the entire FileDialog handler and related functions:

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
        console.log("Loading file:", filePath)

        // Create an XMLHttpRequest directly
        var xhr = new XMLHttpRequest()
        var fileUrl = filePath

        // Ensure we have a proper file URL
        if (!filePath.startsWith("file://")) {
            if (Qt.platform.os === "windows") {
                fileUrl = "file:///" + filePath
            } else {
                fileUrl = "file://" + filePath
            }
        }

        console.log("File URL:", fileUrl)

        xhr.open("GET", fileUrl)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log("XHR Status:", xhr.status)
                if (xhr.status === 200 || xhr.status === 0) {
                    var content = xhr.responseText
                    console.log("File content length:", content.length)

                    var lines = content.split('\n')
                    var validValues = []
                    var invalidCount = 0
                    var fileName = filePath.split('/').pop().split('\\').pop()

                    for (var i = 0; i < lines.length; i++) {
                        var line = lines[i].trim()
                        if (line.length === 0 || line.startsWith('#')) continue

                        // Parse values
                        var lineValues = line.split(/[,;\s]+/)
                        for (var j = 0; j < lineValues.length; j++) {
                            var val = parseFloat(lineValues[j])
                            if (!isNaN(val) && val >= 0 && val <= 1) {
                                validValues.push(val)
                            } else {
                                invalidCount++
                            }
                        }
                    }

                    console.log("Parsed values - valid:", validValues.length, "invalid:", invalidCount)

                    if (validValues.length > 0) {
                        // Directly append valid values to the model
                        for (var k = 0; k < validValues.length; k++) {
                            agentModel.append({ "value": validValues[k] })
                        }

                        // Show success message
                        var message = "Loaded " + validValues.length + " values from " + fileName
                        if (invalidCount > 0) {
                            message += " (" + invalidCount + " invalid values ignored)"
                        }
                        showMessage(message, successColor)
                    } else {
                        showMessage("No valid values (0-1) found in file", warningColor)
                    }
                } else {
                    console.error("Failed to read file")
                    showMessage("Failed to read file: " + xhr.statusText, removeColor)
                }
            }
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
