/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../"
import harbour.sleepwell 1.0

Page {
    id: page
    allowedOrientations: Orientation.All
    property bool portrait: (orientation & Orientation.Portrait) || (orientation & Orientation.PortraitInverted)

    property int playerId: -1
    property QtObject player
    property bool paused: !player.playing
    property bool hideControls: true
    property bool aboutToExecuteReceived: false

    RemorsePopup {
        id: cancelCommand

        onCanceled: {
            player.setNextCommandExecutionEnabled(false);
        }
        onTriggered: {
            hideControls = true
            restartBtn.visible = true
        }
    }

    RemorsePopup {
        id: cancelForcedCommand

        onCanceled: {
            if (aboutToExecuteReceived)
                player.setNextCommandExecutionEnabled(false);
        }

        onTriggered: {
            player.command.execute()
        }
    }

    Connections {
        target: player
        onAboutToExecuteCommand: {
            aboutToExecuteReceived = true
            if (player.hasCommand && player.nextCommandExecutionEnabled && !cancelForcedCommand.visible)
                cancelCommand.execute(player.command.commandStr(), function() {}, player.remainingSeconds * 1000)
        }

        onFinishedPlaying: {
            hideControls = true
            restartBtn.visible = true
        }
    }

    SilicaFlickable {
        width: parent.width
        height: parent.height
        contentHeight: container.y + container.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Close preset")
                onClicked: {
                    playersManager.resetCurrentPlayer()
                    pageStack.popAttached()
                }
            }

            MenuItem {
                visible: player.hasCommand
                text: player.nextCommandExecutionEnabled ? player.command.cancelNextStr()
                                                         : player.command.reenableNextStr()
                onClicked: player.nextCommandExecutionEnabled = !player.nextCommandExecutionEnabled
            }
        }

        VerticalScrollDecorator {}

        PageHeader { title: "Sleep well!" }

        Row {
            id: container
            y: 100
            width: parent.width
            spacing: 2 * Theme.paddingLarge

            Column {
                id: col1
                width: portrait ? parent.width : (parent.width / 2 - 2 * Theme.paddingLarge)
                spacing: portrait ? 2 * Theme.paddingLarge : Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter

                Item {
                    height: lsTo.height + playerName.height + playerName.anchors.topMargin
                    width: parent.width

                    Label {
                        id: lsTo
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        text: qsTr("Listening to")
                        font.pixelSize: Theme.fontSizeSmall
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.highlightColor

                        visible: player != null
                    }

                    Label {
                        id: playerName
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: lsTo.bottom
                        anchors.topMargin: Theme.paddingMedium
                        text: player ? player.name : ""
                        font.pixelSize: Theme.fontSizeLarge
                        horizontalAlignment: Text.AlignHCenter
                        truncationMode: TruncationMode.Fade
                        width: parent.width - 2 * Theme.paddingLarge
                    }
                }

                ProgressCircleBase {
                    anchors.horizontalCenter: parent.horizontalCenter
                    progressColor: Theme.highlightColor
                    value: 1
                    width: 2 * parent.width / 3.0
                    height: width

                    IconButton {
                        id: playBtn
                        anchors.centerIn: parent
                        icon.source: "image://theme/icon-cover-play"
                        onClicked: {
                            enabled = false
                            player.play()
                            animTimer.start()
                            hidePlayBtn.start()
                            hideControls = false
                        }

                        NumberAnimation on opacity {
                            id: hidePlayBtn
                            running: false
                            from: 1
                            to: 0
                            onStopped: playBtn.visible = false
                            duration: 200
                        }
                    }

                    IconButton {
                        id: restartBtn
                        visible: false

                        anchors.centerIn: parent
                        icon.source: "image://theme/icon-push-restart"
                        onClicked: {
                            player.restart()
                            animTimer.restart()
                            hideControls = false
                            hideRestartBtn.start()
                        }

                        FadeAnimation on opacity {
                            id: hideRestartBtn
                            running: false
                            from: 1
                            to: 0
                            onStopped: restartBtn.visible = false
                        }
                    }

                    Label {
                        id: remainingTimeLabel
                        anchors.centerIn: parent
                        horizontalAlignment: Text.horizontalCenter
                        font.pixelSize: 72
                        text: player.remainingTime

                        visible: !playBtn.visible && !restartBtn.visible
                        opacity: playBtn.visible ? 0 : 1

                        Behavior on opacity {
                            FadeAnimation { }
                        }
                    }

                    NumberAnimation on value {
                        id: animTimer
                        from: 1
                        to: 0
                        duration: (player.playDuration + 0.5) * 1000
                        running: false
                    }
                }

                Row {
                    id: playerControls
                    visible: !hideControls
                    spacing: 2 * Theme.paddingLarge
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 82

                    IconButton {
                        id: prevBtn
                        icon.source: "image://theme/icon-cover-next-song"
                        icon.height: parent.height
                        icon.fillMode: Image.PreserveAspectFit
                        icon.mirror: true
                        onClicked: player.prevSong()

                        opacity: parent.visible ? 1 : 0

                        Behavior on opacity {
                            FadeAnimation { }
                        }
                    }

                    IconButton {
                        id: pauseBtn
                        icon.source: paused ? "image://theme/icon-cover-play" : "image://theme/icon-cover-pause"
                        icon.height: parent.height
                        icon.fillMode: Image.PreserveAspectFit
                        onClicked: {
                            if (paused) {
                                player.play()
                                animTimer.resume()
                            }
                            else {
                                player.pause()
                                animTimer.pause()
                                cancelCommand.visible = false
                            }
                        }

                        opacity: parent.visible ? 1 : 0

                        Behavior on opacity {
                            FadeAnimation { }
                        }
                    }

                    IconButton {
                        id: nextBtn
                        icon.source: "image://theme/icon-cover-next-song"
                        icon.height: parent.height
                        icon.fillMode: Image.PreserveAspectFit
                        onClicked: player.nextSong()

                        opacity: parent.visible ? 1 : 0

                        Behavior on opacity {
                            FadeAnimation { }
                        }
                    }
                }

                Row {
                    id: controls

                    visible: !hideControls
                    spacing: Theme.paddingLarge
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 48

                    IconButton {
                        icon.source: "image://theme/icon-push-restart"
                        icon.height: parent.height
                        icon.fillMode: Image.PreserveAspectFit
                        onClicked: {
                            player.restart()
                            animTimer.restart()
                            cancelCommand.visible = false
                            hideControls = false
                        }

                        opacity: parent.visible ? 1 : 0

                        Behavior on opacity {
                            FadeAnimation { }
                        }
                    }

                    IconButton {
                        id: forceCommandBtn
                        visible: player.hasCommand && !cancelCommand.visible && !cancelForcedCommand.visible

                        icon.source: {
                            if (visible) {
                                var c = player.command.type()
                                if (c == Command.SHUTDOWN)
                                    return "image://theme/icon-push-power-off"

                                if (c == Command.SILENT_EXIT)
                                    return "image://theme/icon-status-silent"
                            }

                            return ""
                        }
                        icon.height: parent.height
                        icon.fillMode: Image.PreserveAspectFit
                        onClicked: {
                            cancelForcedCommand.execute(player.command.commandStr())
                        }

                        opacity: parent.visible ? 1 : 0

                        Behavior on opacity {
                            FadeAnimation { }
                        }
                    }
                }

                Label {
                    id: commandInfo
                    visible: !hideControls && player.hasCommand

                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.Center
                    font.pixelSize: Theme.fontSizeSmall
                    text: player.nextCommandExecutionEnabled ? player.command.willExecuteStr()
                                                             : player.command.wontExecuteStr()

                    opacity: visible ? 1 : 0

                    Behavior on opacity {
                        FadeAnimation { }
                    }
                }

                states: State {
                    name: "landscape"
                    when: !portrait
                    ParentChange {
                        target: playerControls
                        parent: col2
                    }
                    ParentChange {
                        target: controls
                        parent: col2
                    }
                    ParentChange {
                        target: commandInfo
                        parent: col2
                    }
                }
            } // col1

            Column {
                id: col2
                width: portrait ? 0 : col1.width
                spacing: 2 * Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter

            } // col2
        } // row

    }
}


