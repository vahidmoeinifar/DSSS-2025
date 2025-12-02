import QtQuick
import QtQuick.Controls.Basic

TextArea {
    property color mainColor
    property color secondColor
    property int _width
    property int _height

    id: control

    placeholderTextColor: Qt.darker(textColor)
    color: textColor

    background: Rectangle {
        implicitWidth: _width
        implicitHeight: _height
        opacity: enabled ? 1 : 0.3
        color: "black"
        radius: 7
    }
}

