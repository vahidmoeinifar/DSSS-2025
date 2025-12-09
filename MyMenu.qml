import QtQuick
import QtQuick.Controls

Item {
    width: 50
    height: 50

    About {
        id: aboutDialog
    }
    Button {
        id: menuButton
        text: "\uf03a"
        font.family: fontAwsomeRegular.name
        font.pixelSize: 30
        anchors.fill: parent

        contentItem: Text {
            text: menuButton.text
            font: menuButton.font
            color: elementsColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            color: "transparent"
            border.color: menuButton.down ? "gray" : "transparent"
            radius: 4
        }

        onClicked: menuPopup.open()

        Menu {
            id: menuPopup
            y: menuButton.height



            MenuItem {
                text: "Help"
                icon.source: "icons/help.png"
                onTriggered: showHelp()
            }

            MenuItem {
                text: "Open Source"
                icon.source: "icons/open-source.png"
                onTriggered: showOpenSource()
            }

            MenuItem {
                text: "About"
                icon.source: "icons/about.png"
                onTriggered: aboutDialog.show()
            }

            MenuSeparator {}

            MenuItem {
                text: "Exit"
                icon.source: "icons/exit.png"
                onTriggered: Qt.quit()
            }
        }
    }
}
