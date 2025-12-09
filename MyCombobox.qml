import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ComboBox {
    id: scriptComboBox
    Layout.fillWidth: true
    model: scriptModel
    textRole: "name"

    currentIndex: 0

    background: Rectangle {
        color: elementsColor
        radius: 3
        border.color: Qt.darker(elementsColor, 1.2)
        border.width: 1
    }

    contentItem: Text {
        text: scriptComboBox.displayText
        color: textColor
        font.pixelSize: 12
        verticalAlignment: Text.AlignVCenter
        leftPadding: 10
        rightPadding: scriptComboBox.indicator.width + scriptComboBox.spacing + 5
    }

    // Dropdown arrow
    indicator: Text {
        text: "\uf107"
        font.family: fontAwsomeRegular.name
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color: textColor
    }
    // Dropdown popup
    popup: Popup {
        y: scriptComboBox.height
        width: Math.max(scriptComboBox.width, 250)  // Minimum width
        implicitHeight: Math.min(contentHeight, 200)  // Max height with scroll
        padding: 0

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: scriptComboBox.popup.visible ? scriptComboBox.delegateModel : null
            currentIndex: scriptComboBox.highlightedIndex

            delegate: ItemDelegate {
                width: scriptComboBox.popup.width
                height: 50  // Increased height for better touch/click area
                highlighted: scriptComboBox.highlightedIndex === index

                contentItem: Column {
                    spacing: 2
                    anchors.fill: parent
                    anchors.margins: 5

                    Text {
                        text: name
                        color: scriptComboBox.highlightedIndex === index ? Qt.lighter(textColor, 1.5) : textColor
                        font.pixelSize: 12
                        font.bold: true
                        width: parent.width
                        elide: Text.ElideRight
                    }

                    Text {
                        text: description
                        color: scriptComboBox.highlightedIndex === index ? Qt.lighter(textColor, 1.8) : Qt.lighter(textColor, 1.5)
                        font.pixelSize: 10
                        width: parent.width
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }
                }

                background: Rectangle {
                    color: highlighted ? Qt.lighter(elementsColor, 1.5) :
                           hovered ? Qt.lighter(bgColor, 1.3) :
                           index % 2 === 0 ? Qt.lighter(bgColor, 1.1) : Qt.lighter(bgColor, 1.05)
                    border.color: highlighted ? Qt.lighter(elementsColor, 1.8) : "transparent"
                    border.width: highlighted ? 1 : 0
                }



                // Click handler
                onClicked: {
                    scriptComboBox.currentIndex = index
                    scriptComboBox.popup.close()
                }
            }

            ScrollIndicator.vertical: ScrollIndicator {
                active: true
            }
        }

        background: Rectangle {
            color: Qt.lighter(bgColor, 1.1)
            border.color: elementsColor
            border.width: 2
            radius: 3
        }
    }

    onCurrentIndexChanged: {
        if (currentIndex >= 0) {
            var selectedScript = scriptModel.get(currentIndex).value
            showMessage("Selected: " + scriptModel.get(currentIndex).name, elementsColor)
        }
    }

    // Make sure dropdown appears on click
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!scriptComboBox.popup.visible) {
                scriptComboBox.popup.open()
            } else {
                scriptComboBox.popup.close()
            }
        }
    }
}
