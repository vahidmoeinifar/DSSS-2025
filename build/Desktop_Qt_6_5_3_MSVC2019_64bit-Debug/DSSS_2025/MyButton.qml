import QtQuick
import QtQuick.Controls.Basic

Button {

    property color mainColor
    property color secondColor
    property int _width
    property int _height

    id: control
    text: qsTr("Button")
    PlaceholderText{
        color:textColor
    }

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
        border.color: control.down ? mainColor: secondColor
        border.width: 1
        color: mainColor
        radius: 25
    }
}
