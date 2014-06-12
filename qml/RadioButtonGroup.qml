import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sleepwell 1.0


Column {
    property variant checkedSwitch: undefined
    property variant selectedValue: checkedSwitch ? checkedSwitch.value : -1
    property bool noValue: !checkedSwitch

    width: parent.width
    spacing: Theme.paddingMedium

    function setValue(v) {
        for (var i = 0; i < children.length; i++) {
            if (children[i].value == v) {
                children[i].checked = true
                break
            }
        }
    }
}
