
//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: ipconfiginput_screen
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
            text: guiStrings.txtConfigIp;
        }

        // Show Function Menu Options Options
        Column {
            width:      parent.width;
            height:     1080 - header.height;
            y: header.height;

            MenuOption {
                id: autoOption;
                text: guiStrings.txtAutomatic;
                expandableOption: false;
                selected: true;
                selection: "";
                focus: true;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: manualOption;
                text: guiStrings.txtManual;
                expandableOption: false;
                selected: false;
                selection: "";

                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
        }
    }
    states: [
        // Landscape Option has got focus
        State {
            name: "AutoSelection"
            when: autoOption.focus;

            PropertyChanges {
                target: autoOption
                selected: true;
            }
            PropertyChanges {
                target: manualOption;
                selected: false;
            }
        },
        // Portrait Option has got focus
        State {
            name: "ManualSelection";
            when: manualOption.focus;
            PropertyChanges {
                target: manualOption
                selected: true;
            }
            PropertyChanges {
                target: autoOption;
                selected: false;
            }
        }
    ]
    function handelKeyEvent(key) {
        // Down / Up Key
        if ( key == Qt.Key_Down || key == Qt.Key_Up ) {
            gotoNextOption();
        }
        // Left Key
        if ( key == Qt.Key_Left ) {
            guiBackend.ChangeCurrentPage("network");
        }
        // ENTER Key is pressed
        if ( key == Qt.Key_Return ) {
            if ( autoOption.focus ) {
                guiStrings.SetAutoIpConfig(true);
            }
            else if ( manualOption.focus ) {
                guiStrings.SetAutoIpConfig(false);
            }
            guiBackend.ChangeCurrentPage("network");
        }
    }
    function gotoNextOption() {
        // Current Selection is HDMI Option
        if ( autoOption.focus ) {
            autoOption.focus = false;
            manualOption.focus = true;
        }
        // Current Selection is Headphone Option
        else if ( manualOption.focus ) {
            manualOption.focus = false;
            autoOption.focus = true;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
}
