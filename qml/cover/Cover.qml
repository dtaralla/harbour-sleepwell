import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sleepwell 1.0

CoverBackground {
    property bool active: status === Cover.Active
    property QtObject player: playersManager.currentPlayer

    Image {
        source: "cover-back.png"
        anchors.top: parent.top
        anchors.right: parent.right
        opacity: 0.2
    }

    CoverPlaceholder {
        visible: player == null
        text: "Sleep Well"
    }

    Label {
        id: lsTo
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 2 * Theme.paddingLarge
        text: qsTr("Listening to")
        font.pixelSize: Theme.fontSizeExtraSmall
        horizontalAlignment: Text.AlignHCenter
        color: Theme.highlightColor

        visible: player != null
    }

    Label {
        id: playerName
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: lsTo.bottom
        anchors.topMargin: Theme.paddingSmall
        text: player ? player.name : ""
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideMiddle
        truncationMode: TruncationMode.Fade
        width: parent.width - 2 * Theme.paddingMedium

        visible: player != null
    }

    Label {
        id: remainingTimeLabel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: playerName.bottom
        anchors.topMargin: 2 * Theme.paddingLarge
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.highlightColor
        text: qsTr("Time left")

        visible: player != null
    }

    Label {
        id: remainingTime
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: remainingTimeLabel.bottom
        anchors.topMargin: Theme.paddingSmall
        horizontalAlignment: Text.AlignHCenter
        text: {
            if (active) {
                if (player && player.remainingSeconds > 0)
                    return player.remainingTime
                else
                    return qsTr("Not started")
            }

            return ""
        }

        visible: player != null
    }

    CoverActionList {
        id: coverAction
        enabled: player && player.remainingSeconds > 0

        CoverAction {
            iconSource: (player && player.playing) ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: if (player.playing) player.pause(); else player.play();
        }
    }
}


