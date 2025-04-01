
//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: power_screen
    width: 1920;
    height: 1080;

    FontLoader {
        id: lucida
        source: "qrc:/lucida.ttf"
    }
    Rectangle {
        width: parent.width;
        height: parent.height;
        color: "black";

        // Show Screen Header
        ScreenHeader {
            id: header;
            width:  parent.width;
            text: guiStrings.txtPower;
        }

        // Show Function Menu Options Options
        Column {
            width:      parent.width;
            height:     1080 - header.height;
            y: header.height;

            MenuOption {
                id: rebootOption;
                text: guiStrings.txtReboot;
                expandableOption: false;
                selected: true;
                selection: "";
                focus: true;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: shutdownOption;
                text: guiStrings.txtShutdown;
                expandableOption: false;
                selected: false;
                selection: "";

                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
        }
    }
    function handelKeyEvent(key) {
        // Down / Up Key
        if ( key == Qt.Key_Down || key == Qt.Key_Up ) {
            gotoNextOption();
        }
        // Left Key
        if ( key == Qt.Key_Left ) {
            guiBackend.ChangeCurrentPage("main");
        }
        // ENTER Key is pressed
        if ( key == Qt.Key_Return ) {
            if ( rebootOption.selected ) {
                guiStrings.PerformPowerOperation("reboot");
            }
            else if ( shutdownOption.selected ) {
                guiStrings.PerformPowerOperation("poweroff");
            }
            guiBackend.ChangeCurrentPage("main");
        }
    }
    function gotoNextOption() {
        // Current Selection is HDMI Option
        if ( rebootOption.selected ) {
            rebootOption.selected = false;
            shutdownOption.selected = true;
        }
        // Current Selection is Headphone Option
        else if ( shutdownOption.selected ) {
            shutdownOption.selected = false;
            rebootOption.selected = true;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
}
