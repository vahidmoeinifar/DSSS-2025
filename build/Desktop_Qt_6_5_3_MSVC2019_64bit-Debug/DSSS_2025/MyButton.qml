import QtQuick
import QtQuick.Controls.Basic

Button {
    property color mainColor
    property int _width
    property int _height

    id: control

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: _width
        implicitHeight: _height
        opacity: enabled ? 1 : 0.3
        color: control.hovered ? Qt.darker(mainColor, 1.2) : mainColor
        radius: 25
        border.color: control.hovered ? Qt.lighter(mainColor, 1.5) : "transparent"
        border.width: control.hovered ? 1 : 0
    }
}
