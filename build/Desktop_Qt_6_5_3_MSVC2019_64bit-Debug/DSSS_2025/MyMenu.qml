import QtQuick
import QtQuick.Controls

Item {
    width: 50
    height: 50

    Button {
        id: menuButton
        text: "\uf03a"
        font.family: fontAwsomeRegular.name
        font.pixelSize: 16

        anchors.fill: parent

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
                text: "\uf059" + " Help"
                onTriggered: showHelp()
            }

            MenuItem {
                text: "Open Source"
                icon.source: "qrc:/icons/open-source.png"
                onTriggered: showOpenSource()
            }

            MenuItem {
                text: "About"
                icon.source: "qrc:/icons/about.png"
                onTriggered: showAbout()
            }

            MenuSeparator {}

            MenuItem {
                text: "Exit"
                icon.source: "qrc:/icons/exit.png"
                onTriggered: Qt.quit()
            }
        }
    }

    function showHelp() { /* ... */ }
    function showOpenSource() { /* ... */ }
    function showAbout() { /* ... */ }
}
