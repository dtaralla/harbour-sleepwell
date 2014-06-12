import QtQuick 2.0
import Sailfish.Silica 1.0
import "../"
import harbour.sleepwell 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        anchors.fill: parent
        model: playersManager.savedPlayers

        header: PageHeader { title: qsTr("Presets") }



        ViewPlaceholder {
            enabled: listView.count == 0
            text: qsTr("No presets")
            hintText: qsTr("Pull down to create a preset")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Help")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("HelpPage.qml"))
                }

            }

            MenuItem {
                text: qsTr("Add new preset")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("EditPresetDialog.qml"), { "createMode": true })
                }

            }

            MenuLabel {
                text: APP_VERSION
            }

            busy: listView.count == 0
        }

        VerticalScrollDecorator {}

        delegate: ListItem {
            id: listItem
            property int playerId: modelData.id

            menu: itemMenu
            ListView.onRemove: animateRemoval()

            onClicked: {
                var p = playersManager.currentPlayer
                if (p) {
                    if (p.id === playerId) {
                        pageStack.navigateForward()
                        return
                    }
                }

                playersManager.setCurrentPlayer(modelData.id)
                pageStack.pushAttached(Qt.resolvedUrl("PresetPlayingPage.qml"), { "player": playersManager.currentPlayer })
                pageStack.navigateForward()
            }

            Label {
                id: nameLabel
                x: Theme.paddingLarge
                text: modelData.name
                width: speakerIcon.visible ? parent.width - 3 * Theme.paddingLarge - Theme.iconSizeMedium : parent.width - 2 * Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                maximumLineCount: 1
                truncationMode: TruncationMode.Fade
            }

            Image {
                id: speakerIcon
                visible: playersManager.currentPlayer && playersManager.currentPlayer.id === playerId

                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter

                source: "image://theme/icon-l-speaker"
                fillMode: Image.PreserveAspectFit
                width: Theme.iconSizeMedium
            }

            Component {
                id: itemMenu

                ContextMenu {
                    property bool presetActive: (pageStack.depth > 0 && playersManager.currentPlayer && playersManager.currentPlayer.id === playerId)
                    MenuItem {
                        visible: presetActive
                        text: qsTr("Close preset")
                        onClicked: {
                            playersManager.resetCurrentPlayer()
                            pageStack.popAttached()
                        }
                    }

                    MenuItem  {
                        visible: !presetActive
                        text: qsTr("Edit")
                        onClicked: {
                            if (modelData.type === MusicPlayer.MUSIC) {
                                pageStack.push(Qt.resolvedUrl("EditPresetDialog.qml"), {
                                                 "playerId": playerId,
                                                 "createMode": false
                                               })
                            }
                        }
                    }

                    MenuItem {
                        visible: !presetActive
                        text: qsTr("Delete")
                        onClicked: remove()
                    }
                }
            }

            function remove() {
                remorseAction(qsTr("Deleting"), function() {
                    playersManager.deletePlayer(modelData.id)
                })
            }
        } // ListItem
    } // ListView

    onPageContainerChanged: {
        if (pageStack.depth == 0 && playersManager.currentPlayer)
            playersManager.currentPlayer = null
    }
}
