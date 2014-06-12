import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property string playlistName
    property string playlistPath

    allowedOrientations: Orientation.All
    canAccept: false

    SilicaFlickable {
        id: flick
        width: parent.width
        height: parent.height
        contentHeight: col.y + col.height

        VerticalScrollDecorator { flickable: flick }

        ViewPlaceholder {
            enabled: rep.count == 0
            text: qsTr("No playlist available")
            hintText: qsTr("You need to import playlists before using this application: create one in Jolla Media for instance, then restart SleepWell.")
        }

        Column {
            id: col
            y: 90
            width: parent.width
            //spacing: Theme.paddingMedium
            visible: rep.count > 0

            PageHeader {
                title: qsTr("Available playlists")
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: rep.count == 1 ? qsTr("%1 playlist in library").arg(rep.count)
                                     : qsTr("%1 playlists in library").arg(rep.count)
            }

            Repeater {
                id: rep
                model: playlistsManager.playlists
                delegate: ListItem {
                    Label {
                        text: modelData.name
                        truncationMode: TruncationMode.Fade
                        width: parent.width - 2 * Theme.paddingLarge
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    onClicked: {
                        playlistName = modelData.name
                        playlistPath = modelData.url
                        canAccept = true
                        accept()
                    }
                } // delegate
            } // rep
        } // col
    } // flick

}
