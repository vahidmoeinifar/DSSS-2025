import QtQuick
import QtQuick.Controls

ComboBox {
    id: comboBox
    property color mainColor: elementsColor
    property color textColor: textColorDark

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 30
        color: comboBox.down ? Qt.darker(comboBox.mainColor, 1.2) : comboBox.mainColor
        border.color: Qt.darker(comboBox.mainColor, 1.5)
        border.width: 1
        radius: 4
    }

    contentItem: Text {
        text: comboBox.displayText
        font: comboBox.font
        color: comboBox.textColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: 10
        rightPadding: comboBox.indicator.width + 10
        elide: Text.ElideRight
    }

    indicator: Text {
        text: "\uf107"
        font.family: fontAwsomeRegular.name
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color: textColor
    }
    delegate: ItemDelegate {
        width: comboBox.width
        text: modelData
        highlighted: comboBox.highlightedIndex === index
        background: Rectangle {
            color: highlighted ? Qt.lighter(comboBox.mainColor, 1.3) : "transparent"
        }
        contentItem: Text {
            text: modelData
            color: comboBox.textColor
            font: comboBox.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            leftPadding: 10
        }
    }
}
