import QtQuick

Rectangle {
    width: 300
    height: 1
    gradient: Gradient {
        orientation: Gradient.Horizontal
          GradientStop { position: 0.0; color: "transparent" }
          GradientStop { position: 0.5; color: elementsColor }
          GradientStop { position: 1.0; color: "transparent" }
      }
    anchors.horizontalCenter: parent.horizontalCenter
}
