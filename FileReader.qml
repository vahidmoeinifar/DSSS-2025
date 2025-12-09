// FileReader.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: fileReader

    property string filePath: ""
    signal fileLoaded(var values, string fileName)

    function load() {
        var xhr = new XMLHttpRequest()
        var fileUrl = filePath

        // Ensure file URL is properly formatted
        if (!filePath.startsWith("file://")) {
            fileUrl = "file:///" + filePath
        }

        xhr.open("GET", fileUrl)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || xhr.status === 0) {
                    parseFileContent(xhr.responseText)
                } else {
                    console.error("Error reading file:", xhr.status, xhr.statusText)
                    fileLoaded([], "")
                }
            }
        }
        xhr.send()
    }

    function parseFileContent(content) {
        var lines = content.split('\n')
        var values = []
        var fileName = filePath.split('/').pop().split('\\').pop()

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            if (line.length === 0 || line.startsWith('#')) continue

            // Parse various formats
            var lineValues = []

            // Try comma-separated
            if (line.includes(',')) {
                lineValues = line.split(',').map(function(v) { return v.trim() })
            }
            // Try semicolon-separated
            else if (line.includes(';')) {
                lineValues = line.split(';').map(function(v) { return v.trim() })
            }
            // Try space/tab separated
            else {
                lineValues = line.split(/\s+/)
            }

            for (var j = 0; j < lineValues.length; j++) {
                var val = parseFloat(lineValues[j])
                if (!isNaN(val) && val >= 0 && val <= 1) {
                    values.push(val)
                }
            }
        }

        fileLoaded(values, fileName)
    }
}
