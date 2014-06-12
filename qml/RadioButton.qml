import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sleepwell 1.0


TextSwitch {
    id: button
    property variant value

    onCheckedChanged: {
        if (checked) {
            if (parent.checkedSwitch) {
                parent.checkedSwitch.checked = false
            }
            parent.checkedSwitch = button
        }
        else if (parent.checkedSwitch == button) {
            parent.checkedSwitch = undefined
        }
    }
}
