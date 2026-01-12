import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: confirmationDialog
    width: 400
    height: 200
    modal: true
    focus: true
    dim: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property string title: "Confirm"
    property string message: "Are you sure?"
    property string confirmButtonText: "Yes"
    property string cancelButtonText: "No"
    property color confirmButtonColor: removeColor
    property color cancelButtonColor: elementsColor

    signal confirmed()
    signal cancelled()

    background: Rectangle {
        color: bgColor
        radius: 8
        border.color: elementsColor
        border.width: 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: confirmationDialog.title
            font.pixelSize: 18
            font.bold: true
            color: textColor
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: elementsColor
        }

        Text {
            text: confirmationDialog.message
            font.pixelSize: 14
            color: textColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            MyButton {
                id: cancelButton
                text: confirmationDialog.cancelButtonText
                mainColor: confirmationDialog.cancelButtonColor
                Layout.fillWidth: true
                onClicked: {
                    confirmationDialog.cancelled()
                    confirmationDialog.close()
                }
            }

            MyButton {
                id: confirmButton
                text: confirmationDialog.confirmButtonText
                mainColor: confirmationDialog.confirmButtonColor
                Layout.fillWidth: true
                onClicked: {
                    confirmationDialog.confirmed()
                    confirmationDialog.close()
                }
            }
        }
    }
}
