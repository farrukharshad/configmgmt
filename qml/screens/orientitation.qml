
//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: orientitation_screen
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
            text: guiStrings.txtOrientitation;
        }

        // Show Function Menu Options Options
        Column {
            width:      parent.width;
            height:     1080 - header.height;
            y: header.height;

            MenuOption {
                id: landscapeOption;
                text: guiStrings.txtLandscape;
                expandableOption: false;
                selected: true;
                selection: "";
                focus: true;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: portraitOption;
                text: guiStrings.txtPortrait;
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
            name: "LandscapeSelection"
            when: landscapeOption.focus;

            PropertyChanges {
                target: landscapeOption
                selected: true;
            }
            PropertyChanges {
                target: portraitOption;
                selected: false;
            }
        },
        // Portrait Option has got focus
        State {
            name: "PortraitSelection";
            when: portraitOption.focus;
            PropertyChanges {
                target: portraitOption
                selected: true;
            }
            PropertyChanges {
                target: landscapeOption;
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
            guiBackend.ChangeCurrentPage("main");
        }
        // ENTER Key is pressed
        if ( key == Qt.Key_Return ) {
            if ( landscapeOption.focus ) {
                guiStrings.SetOrientitationLandscape(true);
            }
            else if ( portraitOption.focus ) {
                guiStrings.SetOrientitationLandscape(false);
            }
            guiBackend.ChangeCurrentPage("main");
        }
    }
    function gotoNextOption() {
        // Current Selection is English Option
        if ( landscapeOption.focus ) {
            landscapeOption.focus = false;
            portraitOption.focus = true;
        }
        // Current Selection is Nederlands Option
        else if ( portraitOption.focus ) {
            portraitOption.focus = false;
            landscapeOption.focus = true;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
}
