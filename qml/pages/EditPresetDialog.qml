import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sleepwell 1.0
import "../"


Dialog {
    id: page
    allowedOrientations: Orientation.All

    property bool createMode
    property int playerId: -1
    property QtObject player: playerId == -1 ? null : playersManager.musicPlayerById(playerId)

    canAccept: name.text !== "" &&
               playlist.path !== "" &&
               startVolume.acceptableInput &&
               (playDuration.hour > 0 || playDuration.minute > 0) &&
               3600 * playDuration.hour + 60 * playDuration.minute >= 3600 * fadeDuration.hour + 60 * fadeDuration.minute

    DialogHeader {
        id: header
        opacity: (acceptPending || flick.atYBeginning) ? 1 : 0
    }

    SilicaFlickable {
        id: flick
        width: parent.width
        height: parent.height
        contentHeight: col.y + col.height

        VerticalScrollDecorator { flickable: flick }

        Column {
            id: col
            y: 100
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: createMode ? qsTr("Create preset")
                                  : qsTr("Edit preset")
            }

            SectionHeader {
                text: qsTr("Preset details")
            }

            TextField {
                id: name
                width: parent.width
                placeholderText: qsTr("Preset name")
            }

            ValueButton {
                id: playlist
                property string path

                width: parent.width

                label: qsTr("Playlist:")

                onClicked: {
                    var d = pageStack.push(Qt.resolvedUrl("SelectPlaylistDialog.qml"))
                    d.accepted.connect(function() {
                        value = d.playlistName
                        path = d.playlistPath
                    })
                }
            }

            TextField {
                id: startVolume
                width: parent.width
                placeholderText: qsTr("Starting volume")
                label: qsTr("Enter 0 to start at system volume")
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator {
                    bottom: 0
                    top: 100
                }
            }

            SectionHeader {
                text: qsTr("Action on timeout")
            }

            RadioButtonGroup {
                id: command

                RadioButton {
                    value: Command.SHUTDOWN

                    text: qsTr("Automatic shutdown")
                    description: qsTr("Shut down device on timeout.")
                }

                RadioButton {
                    value: Command.SILENT_EXIT

                    text: qsTr("Automatic silence & exit")
                    description: qsTr("Silence device and exit app on timeout.")
                }
            }

            SectionHeader {
                text: qsTr("Playout total duration")
            }

            TimePicker {
                id: playDuration
                hourMode: DateTime.TwentyFourHours
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    anchors.centerIn: parent
                    text: parent.hour + ":" + parent.minute
                }
            }


            SectionHeader {
                text: qsTr("Playout volume fading duration")
            }

            TimePicker {
                id: fadeDuration
                hourMode: DateTime.TwentyFourHours
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    anchors.centerIn: parent
                    text: parent.hour + ":" + parent.minute
                }
            }

            Item { height: Theme.paddingMedium; width: parent.width } // To have a bottom margin
        } // column
    } // flickable

    onOpened: {
        name.text        = createMode ? "" : player.name
        playlist.path    = createMode ? "" : player.playlistUrl
        playlist.value   = createMode ? qsTr("Browse imported...") : player.playlistName
        startVolume.text = createMode ? "0" : player.startVolume
        playDuration.hour = createMode ? 0 : Math.floor(player.playDuration / 3600)
        playDuration.minute = createMode ? 15 : Math.floor((player.playDuration - 3600 * playDuration.hour) / 60)
        fadeDuration.hour = createMode ? 0 : Math.floor(player.fadeOutDuration / 3600)
        fadeDuration.minute = createMode ? 15 : Math.floor((player.fadeOutDuration - 3600 * fadeDuration.hour) / 60)

        if (!createMode && player.hasCommand) {
            command.setValue(player.command.type());
        }
    }


    onDone: {
        if (result === DialogResult.Accepted) {
            var playSeconds = 3600 * playDuration.hour + 60 * playDuration.minute
            var fadeSeconds = 3600 * fadeDuration.hour + 60 * fadeDuration.minute

            var c = Command.NONE
            if (!command.noValue) {
                c = command.selectedValue
            }

            if (createMode) {
                player = playersManager.createMusicPlayer(playlist.path, name.text, c, playSeconds, fadeSeconds, startVolume.text)
            }
            else {
                player.name = name.text
                player.playlistUrl = playlist.path
                player.playDuration = playSeconds
                player.fadeOutDuration = fadeSeconds
                player.startVolume = startVolume.text
                player.setCommand(c)
            }
        }
    }
}





