import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow {
    initialPage: Component { PresetsListPage { } }
    cover: Qt.resolvedUrl("cover/Cover.qml")
    allowedOrientations: Orientation.All
}


