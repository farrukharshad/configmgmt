
//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: language_screen
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
            text: guiStrings.txtLanguage;
        }

        // Show Main Menu Options
        Column {
            width:      1920
            height:     980;
            y: header.height;

            MenuOption {
                id: enOption;
                text: "English";
                focus: true;
                selected: true;
                expandableOption: false;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: nlOption;
                text: "Nederlands";
                expandableOption: false;
                selected: false;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: deOption;
                text: "Deutsch";
                expandableOption: false;
                selected: false;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
        }
    }

    function handelKeyEvent(key) {
        // Down Key
        if ( key == Qt.Key_Down ) {
            gotoNextOption();
        }
        // Up Key
        if ( key == Qt.Key_Up ) {
            gotoPreviousOption();
        }
        // Left Key
        if ( key == Qt.Key_Left ) {
            guiBackend.ChangeCurrentPage("main");
        }
        // ENTER Key is pressed
        if ( key == Qt.Key_Return) {
            console.log("Enter is pressed");
            if ( enOption.selected )
                guiStrings.ChangeSystemLanguage("en");
            else if ( nlOption.selected )
                guiStrings.ChangeSystemLanguage("nl");
            else if ( deOption.selected )
                guiStrings.ChangeSystemLanguage("de");
        }
    }
    function gotoNextOption() {
        // Current Selection is English Option
        if ( enOption.selected ) {
            enOption.selected = false;
            nlOption.selected = true;
        }
        // Current Selection is Nederlands Option
        else if ( nlOption.selected ) {
            nlOption.selected = false;
            deOption.selected = true;
        }
        // Current Selection is Deutsch Option
        else if ( deOption.selected ) {
            deOption.selected = false;
            enOption.selected = true;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
    function gotoPreviousOption() {
        // Current Selection is English Option
        if ( enOption.selected ) {
            enOption.selected = false;
            deOption.selected = true;
        }
        // Current Selection is Nederlands Option
        else if ( nlOption.selected ) {
            enOption.selected = true;
            nlOption.selected = false;
        }
        // Current Selection is Deutsch Option
        else if ( deOption.selected ) {
            nlOption.selected = true;
            deOption.selected = false;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
}
