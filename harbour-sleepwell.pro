# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-sleepwell

QT += dbus \
    multimedia

CONFIG += sailfishapp

SOURCES += src/harbour-sleepwell.cpp \
    src/player.cpp \
    src/playersmanager.cpp \
    src/musicplayer.cpp \
    src/hardwarecontrol.cpp \
    src/playlistsmanager.cpp \
    src/playlist.cpp \
    src/command.cpp \
    src/commandshutdown.cpp \
    src/commandsilentexit.cpp

lupdate_only{
SOURCES += qml/*.qml \
           qml/cover/*.qml \
           qml/pages/*.qml
}

OTHER_FILES += qml/harbour-sleepwell.qml \
    rpm/harbour-sleepwell.spec \
    rpm/harbour-sleepwell.yaml \
    harbour-sleepwell.desktop \
    qml/pages/EditPresetMusic.qml \
    qml/pages/MainPage.qml \
    qml/pages/HelpPage.qml \
    qml/pages/SelectPlaylistDialog.qml \
    LICENCE \
    qml/RadioButtonGroup.qml \
    qml/RadioButton.qml \
    qml/pages/PlayersListPage.qml \
    qml/cover/Cover.qml \
    qml/pages/PresetsListPage.qml \
    qml/pages/PresetPlayingPage.qml \
    qml/pages/EditPresetDialog.qml

HEADERS += \
    src/player.h \
    src/playersmanager.h \
    src/musicplayer.h \
    src/hardwarecontrol.h \
    src/playlistsmanager.h \
    src/playlist.h \
    src/command.h \
    src/commandshutdown.h \
    src/commandsilentexit.h

TRANSLATIONS += \
    tr/fr.ts

tr.files = tr/*.qm
tr.path = /usr/share/$${TARGET}/tr

INSTALLS += tr
