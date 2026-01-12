import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    color: "transparent"

    property HistoryManager historyManager

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                width: parent.width
                spacing: 15

                // Overall Statistics
                Rectangle {
                    Layout.fillWidth: true
                    height: 150
                    color: Qt.darker(bgColor, 1.1)
                    radius: 5
                    border.color: elementsColor
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        Text {
                            text: "📊 Overall Statistics"
                            font.pixelSize: 14
                            font.bold: true
                            color: textColor
                        }

                        GridLayout {
                            columns: 2
                            columnSpacing: 20
                            rowSpacing: 8
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            // Row 1
                            Text { text: "Total Entries:"; color: textColorDisable; font.pixelSize: 11 }
                            Text {
                                text: {
                                    var stats = historyManager.getStatistics()
                                    return stats["totalEntries"] || 0
                                }
                                color: lightGreenColor; font.pixelSize: 11; font.bold: true
                            }

                            Text { text: "Success Rate:"; color: textColorDisable; font.pixelSize: 11 }
                            Text {
                                text: {
                                    var stats = historyManager.getStatistics()
                                    var rate = stats["successRate"] || 0
                                    return rate.toFixed(1) + "%"
                                }
                                color: lightGreenColor; font.pixelSize: 11; font.bold: true
                            }

                            // Row 2
                            Text { text: "Success Count:"; color: textColorDisable; font.pixelSize: 11 }
                            Text {
                                text: {
                                    var stats = historyManager.getStatistics()
                                    return stats["successCount"] || 0
                                }
                                color: lightGreenColor; font.pixelSize: 11; font.bold: true
                            }

                            Text { text: "Error Count:"; color: textColorDisable; font.pixelSize: 11 }
                            Text {
                                text: {
                                    var stats = historyManager.getStatistics()
                                    return stats["errorCount"] || 0
                                }
                                color: magentaColor; font.pixelSize: 11; font.bold: true
                            }

                            // Row 3
                            Text { text: "Average Result:"; color: textColorDisable; font.pixelSize: 11 }
                            Text {
                                text: (historyManager.getAverageResult() || 0).toFixed(4)
                                color: yellowColor; font.pixelSize: 11; font.bold: true
                            }

                            Text { text: "Avg Confidence:"; color: textColorDisable; font.pixelSize: 11 }
                            Text {
                                text: {
                                    var stats = historyManager.getStatistics()
                                    var conf = stats["averageConfidence"] || 0
                                    return (conf * 100).toFixed(1) + "%"
                                }
                                color: cyanColor; font.pixelSize: 11; font.bold: true
                            }

                            // Row 4
                            Text { text: "Avg Execution Time:"; color: textColorDisable; font.pixelSize: 11 }
                            Text {
                                text: {
                                    var stats = historyManager.getStatistics()
                                    var time = stats["averageExecutionTime"] || 0
                                    return time.toFixed(0) + "ms"
                                }
                                color: cyanColor; font.pixelSize: 11; font.bold: true
                            }
                        }
                    }
                }

                // Algorithm Usage
                Rectangle {
                    Layout.fillWidth: true
                    height: 250
                    color: Qt.darker(bgColor, 1.1)
                    radius: 5
                    border.color: elementsColor
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        Text {
                            text: "⚙️ Algorithm Usage"
                            font.pixelSize: 14
                            font.bold: true
                            color: textColor
                        }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: {
                                var algoStats = historyManager.getAlgorithmStatistics()
                                return Object.keys(algoStats)
                            }

                            delegate: Rectangle {
                                width: ListView.view.width
                                height: 50
                                color: index % 2 === 0 ? "transparent" : Qt.rgba(1,1,1,0.05)

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 2

                                    // Algorithm name
                                    RowLayout {
                                        Layout.fillWidth: true

                                        Text {
                                            text: modelData
                                            font.pixelSize: 12
                                            color: textColor
                                            font.bold: true
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: {
                                                var algoStats = historyManager.getAlgorithmStatistics()
                                                var stats = algoStats[modelData] || {}
                                                return stats["usageCount"] + " uses"
                                            }
                                            font.pixelSize: 11
                                            color: lightGreenColor
                                            font.bold: true
                                        }
                                    }

                                    // Stats row
                                    RowLayout {
                                        Layout.fillWidth: true

                                        // Usage bar
                                        Rectangle {
                                            Layout.fillWidth: true
                                            height: 6
                                            radius: 3
                                            color: Qt.darker(elementsColor, 1.5)

                                            Rectangle {
                                                width: {
                                                    var algoStats = historyManager.getAlgorithmStatistics()
                                                    var stats = algoStats[modelData] || {}
                                                    var percentage = stats["usagePercentage"] || 0
                                                    return parent.width * (percentage / 100)
                                                }
                                                height: parent.height
                                                radius: parent.radius
                                                color: lightGreenColor
                                            }
                                        }

                                        // Percentage
                                        Text {
                                            text: {
                                                var algoStats = historyManager.getAlgorithmStatistics()
                                                var stats = algoStats[modelData] || {}
                                                var percentage = stats["usagePercentage"] || 0
                                                return percentage.toFixed(1) + "%"
                                            }
                                            font.pixelSize: 10
                                            color: textColorDisable
                                            Layout.preferredWidth: 50
                                        }
                                    }

                                    // Performance stats
                                    RowLayout {
                                        Layout.fillWidth: true

                                        Text {
                                            text: "Result:"
                                            font.pixelSize: 9
                                            color: textColorDisable
                                        }

                                        Text {
                                            text: {
                                                var algoStats = historyManager.getAlgorithmStatistics()
                                                var stats = algoStats[modelData] || {}
                                                return stats["averageResult"] ? stats["averageResult"].toFixed(4) : "0.0000"
                                            }
                                            font.pixelSize: 10
                                            color: yellowColor
                                            font.bold: true
                                            Layout.fillWidth: true
                                        }

                                        Text {
                                            text: "Time:"
                                            font.pixelSize: 9
                                            color: textColorDisable
                                        }

                                        Text {
                                            text: {
                                                var algoStats = historyManager.getAlgorithmStatistics()
                                                var stats = algoStats[modelData] || {}
                                                return stats["averageExecutionTime"] ?
                                                       stats["averageExecutionTime"].toFixed(0) + "ms" : "0ms"
                                            }
                                            font.pixelSize: 10
                                            color: cyanColor
                                            font.bold: true
                                        }
                                    }
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "No algorithm statistics available"
                                color: textColorDisable
                                visible: parent.count === 0
                            }
                        }
                    }
                }

                // Recent Activity Timeline
                Rectangle {
                    Layout.fillWidth: true
                    height: 200
                    color: Qt.darker(bgColor, 1.1)
                    radius: 5
                    border.color: elementsColor
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        Text {
                            text: "📈 Recent Activity"
                            font.pixelSize: 14
                            font.bold: true
                            color: textColor
                        }

                        // Simple timeline visualization
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: historyManager.historyEntries.slice(0, 8) // Last 8 entries

                            delegate: Rectangle {
                                width: ListView.view.width
                                height: 35
                                color: "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 10

                                    // Timeline dot
                                    Rectangle {
                                        width: 10
                                        height: 10
                                        radius: 5
                                        color: modelData.status === "success" ? lightGreenColor : magentaColor
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    // Time
                                    Text {
                                        text: {
                                            var timeStr = modelData.timestamp || ""
                                            if (timeStr.includes(" ")) {
                                                return timeStr.split(" ")[1] // Get time part only
                                            }
                                            return timeStr
                                        }
                                        font.pixelSize: 10
                                        color: textColorDisable
                                        Layout.preferredWidth: 60
                                    }

                                    // Algorithm name
                                    Text {
                                        text: {
                                            var algo = modelData.algorithm || ""
                                            return algo.split('/').pop().split('\\').pop()
                                        }
                                        font.pixelSize: 11
                                        color: textColor
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }

                                    // Result bar
                                    Rectangle {
                                        width: 80
                                        height: 8
                                        radius: 4
                                        color: Qt.darker(elementsColor, 1.5)
                                        Layout.alignment: Qt.AlignVCenter

                                        Rectangle {
                                            width: parent.width * (modelData.result || 0)
                                            height: parent.height
                                            radius: parent.radius
                                            color: {
                                                var val = modelData.result || 0
                                                if (val < 0.3) return magentaColor
                                                if (val < 0.7) return yellowColor
                                                return lightGreenColor
                                            }
                                        }
                                    }

                                    // Result value
                                    Text {
                                        text: (modelData.result || 0).toFixed(3)
                                        font.pixelSize: 11
                                        color: yellowColor
                                        font.bold: true
                                        Layout.preferredWidth: 45
                                    }

                                    // Agent count
                                    Text {
                                        text: "×" + (modelData.agentCount || 0)
                                        font.pixelSize: 10
                                        color: textColorDisable
                                        Layout.preferredWidth: 30
                                    }
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "No recent activity"
                                color: textColorDisable
                                visible: parent.count === 0
                            }
                        }
                    }
                }
            }
        }
    }
}
