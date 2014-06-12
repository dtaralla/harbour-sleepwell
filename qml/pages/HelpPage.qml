
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../"
import harbour.sleepwell 1.0

Page {
    allowedOrientations: Orientation.All

    ListModel {
        id: faqModel
    }

    ListModel {
        id: issuesModel
    }

    SilicaFlickable {
        id: flick
        width: parent.width
        height: parent.height
        contentHeight: col.height

        VerticalScrollDecorator { flickable: flick }

        Column {
            id: col
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Help")
            }

            SectionHeader {
                text: qsTr("Frequently Asked Questions")
            }

            Repeater {
                model: faqModel
                delegate: Column {
                    width: parent.width - 2 * Theme.paddingLarge
                    spacing: Theme.paddingSmall
                    anchors.horizontalCenter: parent.horizontalCenter

                    Label {
                        text: question

                        width: parent.width
                        color: Theme.highlightColor
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.Wrap
                    }
                    Label {
                        text: answer

                        width: parent.width
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.Wrap
                    }
                }
            }


            SectionHeader {
                text: qsTr("Known issues")
            }

            Repeater {
                model: issuesModel
                delegate: Row {
                    width: parent.width - 2 * Theme.paddingLarge
                    spacing: Theme.paddingMedium
                    anchors.horizontalCenter: parent.horizontalCenter

                    Label {
                        text: "- " + issue

                        width: parent.width
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.Wrap
                    }
                }
            }

            Item { height: Theme.paddingLarge / 2; width: 1 } // for bottom margin
        }
    }



    onPageContainerChanged: {
        var faqEntries = [
                    { "question": qsTr("What is the 'Volume fading duration'?"),
                        "answer":  qsTr("You are able to specify a duration, less or equal to the playout total duration, during which the volume will fade linearly to reach 0 when the playout total duration elapsed.") },

                    { "question": qsTr("What is the 'Starting volume'?"),
                       "answer":   qsTr("When tapping the Play button, the volume of the device will be set to this value. The value won't change until the volume fading begins (if the volume fading duration is different from 0).") },

                    { "question": qsTr("What are the available timeout commands and what are they?"),
                      "answer":   qsTr("SleepWell allows you to program a command to be executed when playout is finished. For now, you can program the following actions:\n- Shutdown device,\n-Silence device and exit application.\nThe command can be configured for each preset, in its settings page. You can always cancel a programmed command while listening to a preset by using the pulley menu on the preset page, or by tapping the imminent command execution remorse timer.") },

                    { "question": qsTr("I would like SleepWell to include a new timeout command!"),
                      "answer":   qsTr("Please, contact me or just leave a word about it in the comments of Harbour SleepWell page :-) I monitor them often, and will be pleased to add new functionalities if the idea is possible!") },

                    { "question": qsTr("I want to trigger manually the command of the preset I listen to because I'm tired. How to do that?"),
                      "answer":   qsTr("Just tap the button corresponding to the command in the bottom-right corner of the screen. That's all! Notice the aspect of the button changes according to the programmed command. You can trigger a command only if it set as the preset timeout action.") },

                    { "question": qsTr("Can SleepWell read playlists containing URLs?"),
                      "answer":   qsTr("Yes! SleepWell relies on the QtMultimedia QMediaPlayer object, which is able to to just that.") },

                    { "question": qsTr("I cannot create a preset, why?"),
                      "answer":   qsTr("To create a preset, you will first need at least one compatible playlist in your $HOME/Music/playlists directory (supported format: Jolla Media .PLS, standard .PLS and .M3U). Check also that the playout total duration is greater or equal to the volume fading duration. Finally, the starting volume should be an integer between 0 and 100.") },

                    { "question": qsTr("I cannot edit nor delete one of my presets, why?"),
                      "answer":   qsTr("Make sure the preset is not currently in use (it would have a speaker icon next to it). To close it, go in this preset page and use the pulley menu, or use the popup menu of this preset as you would do to edit it. You should also wait for a preset delete timer to elapse before deleting another one (see known issues below).") },

                    { "question": qsTr("Can I create playlists from inside SleepWell?"),
                      "answer":   qsTr("Not at the moment. Nevertheless, SleepWell works in conjunction with the Jolla Media app: all playlists created with Jolla Media are imported each time the application starts, and thus are available for your presets.") },

                    { "question": qsTr("How to import playlists in SleepWell?"),
                      "answer":   qsTr("At each start, the app will look for compatible playlists in your $HOME/Music/playlists directory and import them (supported format: Jolla Media .PLS, standard .PLS and .M3U). You are free to create playlists manually, but then make sure the paths to the files are absolute. Moreover, as the Jolla Media app saves its playlists into this directory, you can use it to create your playlists. The changes made to a playlist located in your $HOME/Music/playlists directory will be taken into account the next time the application starts.") },

                    { "question": qsTr("I found a bug!"),
                        "answer":  qsTr("Good job! My app is, as any app, subject to have bugs, thank you for reporting it in the comments of Harbour SleepWell page :-) Take also a look to the 'Know issues' hereafter. Any ideas to fix them are also welcome!") }
                ]

        var issuesEntries = [
                    { "issue": qsTr("QMediaPlayer volume still has an erratic behaviour. Put the starting volume setting at 0 for your presets and manually set the device volume when you hit the play button to ensure proper functionning.") },
                    { "issue": qsTr("If a volume fade out duration is set, your device will end up with a volume of 0. Thus, do not forget to reset your device volume to your needs after use.") },
                    { "issue": qsTr("The Media app stores its playlists in a non-standard PLS format. The app will try (and normally succeed) to fix these before importing. If for some reasons some playlists could not be loaded, they won't be available for your presets. Comment on SleepWell Harbour page if you have any trouble with this!") },
                    { "issue": qsTr("Deleting presets from their popup menus should be done one after the other, when no other preset delete remorse timer is running. Else, the preset list does not refresh correctly.") },
                    { "issue": qsTr("Some graphical artifacts can appear on the progress circles before starting a preset, because this Sailfish component is still experimental.") }
                ]

        for (var i = 0; i < faqEntries.length; i += 1)
            faqModel.append(faqEntries[i])

        for (i = 0; i < issuesEntries.length; i += 1)
            issuesModel.append(issuesEntries[i])
    }
}
