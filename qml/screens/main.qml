
//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: main_screen
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
        id: screenArea;

        // Show Screen Header
        ScreenHeader {
            id: header;
            text: guiStrings.txtMainMenu;
        }

        // Show Main Menu Options
        Column {
            width:      1920
            height:     980;
            y: header.height;
            MenuOption {
                id: langOption;
                text: guiStrings.txtLanguage;
                selection: guiStrings.txtCurrentLangStr;
                selected: false;
                expandableOption: true;
                inside: false;
                focus: true;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: netOption;
                text: guiStrings.txtNetworkSettings;
                selection:  if ( guiStrings.txtCurrentIpAddr.length == 0 ) {
                                guiStrings.txtDisconnected;
                            } else {
                                guiStrings.txtCurrentIpAddr;
                            }
                selected: false;
                expandableOption: true;
                inside: false;
                selection_disabled: if ( guiStrings.txtCurrentIpAddr.length == 0 ) true; else false;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: wirelessOption;
                text: guiStrings.txtWirelessNetwork;
                selection: guiStrings.txtWirelessStr;
                selected: false;
                expandableOption: true;
                inside: false;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: funcOption;
                text: guiStrings.txtFunction;
                selection: guiStrings.txtFunctionStr;
                selected: false;
                expandableOption: true;
                inside: false;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: orienOption;
                text: guiStrings.txtOrientitation;
                selection: guiStrings.txtOrientitationStr;
                selected: false;
                expandableOption: true;
                inside: false;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: soundOption;
                text: guiStrings.txtSound;
                selection: guiStrings.txtSoundStr;
                selected: false;
                expandableOption: true;
                inside: false;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: powerOption;
                text: guiStrings.txtPower;
                selection: ""
                selected: false;
                expandableOption: true;
                inside: false;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: playOption;
                text: guiStrings.txtPlay;
                selection: "";
                selected: false;
                expandableOption: true;
                inside: false;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
        }
    }
    states: [
        // Language Option has got focus
        State {
            name: "LangOptSelection"
            when: langOption.focus;

            PropertyChanges {
                target: langOption
                selected: true;
            }
            PropertyChanges {
                target: netOption;
                selected: false;
            }
            PropertyChanges {
                target: playOption;
                selected: false;
            }
        },
        // Networking Option has got focus
        State {
            name: "NetOptSelect";
            when: netOption.focus;
            PropertyChanges {
                target: netOption
                selected: true;
            }
            PropertyChanges {
                target: langOption;
                selected: false;
            }
            PropertyChanges {
                target: wirelessOption;
                selected: false;
            }
        },
        // Wireless Option has got focus
        State {
            name: "WirelessOptSelect";
            when: wirelessOption.focus;
            PropertyChanges {
                target: wirelessOption
                selected: true;
            }
            PropertyChanges {
                target: netOption;
                selected: false;
            }
            PropertyChanges {
                target: funcOption;
                selected: false;
            }
        },
        // Function Option has got focus
        State {
            name: "FuncOptSelect";
            when: funcOption.focus;
            PropertyChanges {
                target: funcOption
                selected: true;
            }
            PropertyChanges {
                target: wirelessOption;
                selected: false;
            }
            PropertyChanges {
                target: orienOption;
                selected: false;
            }
        },
        // Orientitation Option has got focus
        State {
            name: "OrientOptSelect";
            when: orienOption.focus;
            PropertyChanges {
                target: orienOption
                selected: true;
            }
            PropertyChanges {
                target: funcOption;
                selected: false;
            }
            PropertyChanges {
                target: soundOption;
                selected: false;
            }
        },
        // Sound Option has got focus
        State {
            name: "SoundOptSelect";
            when: soundOption.focus;
            PropertyChanges {
                target: soundOption
                selected: true;
            }
            PropertyChanges {
                target: orienOption;
                selected: false;
            }
            PropertyChanges {
                target: powerOption;
                selected: false;
            }
        },
        // Power Option has got focus
        State {
            name: "PowerOptSelect";
            when: powerOption.focus;
            PropertyChanges {
                target: powerOption
                selected: true;
            }
            PropertyChanges {
                target: soundOption;
                selected: false;
            }
            PropertyChanges {
                target: playOption;
                selected: false;
            }
        },
        // Play Option has got focus
        State {
            name: "PlayOptSelect";
            when: playOption.focus;
            PropertyChanges {
                target: playOption
                selected: true;
            }
            PropertyChanges {
                target: powerOption;
                selected: false;
            }
            PropertyChanges {
                target: langOption;
                selected: false;
            }
        }
    ]
    function handelKeyEvent(key) {
        // Down Key
        if ( key == Qt.Key_Down ) {
            gotoNextOption();
        }
        // Up Key
        if ( key == Qt.Key_Up ) {
            gotoPreviousOption();
        }
        // Right Key
        if ( key == Qt.Key_Right ) {
            // Open the language selection page
            if ( langOption.focus ) {
                guiBackend.ChangeCurrentPage("language");
            }
            // Open the Network settings page
            else if ( netOption.focus ) {
                // FIXME: Remove following commented section.
                if ( /*true */guiStrings.txtCurrentIpAddr.length > 0 ) {
                    guiBackend.ChangeCurrentPage("network");
                }
            }
            // Open the wireless settings page
            else if ( wirelessOption.focus ) {
                guiBackend.ChangeCurrentPage("wireless");
            }
            // Open the Function settings page
            else if ( funcOption.focus ) {
                guiBackend.ChangeCurrentPage("function");
            }
            // Open the Orientitation settings page
            else if ( orienOption.focus ) {
                guiBackend.ChangeCurrentPage("orientitation");
            }
            // Open the Sound settings page
            else if ( soundOption.focus ) {
                guiBackend.ChangeCurrentPage("sound");
            }
            // Open the Power settings page
            else if ( powerOption.focus ) {
                guiBackend.ChangeCurrentPage("power");
            }
            // Open the Play settings page
            else if ( playOption.focus ) {
                guiBackend.ChangeCurrentPage("play");
            }
            else {
                console.debug("Opening a page which does not exist");
            }
        }
    }
    function gotoNextOption() {
        // Current Selection is Language Option
        if ( langOption.focus ) {
            langOption.focus = false;
            netOption.focus = true;
        }
        // Current Selection is Networking Option
        else if ( netOption.focus ) {
            netOption.focus = false;
            wirelessOption.focus = true;
        }
        // Current Selection is Wireless Option
        else if ( wirelessOption.focus ) {
            wirelessOption = false;
            funcOption.focus = true;
        }
        // Current Selection is Function Option
        else if ( funcOption.focus ) {
            funcOption.focus = false;
            orienOption.focus = true;
        }
        // Current Selection is Orientitation Option
        else if ( orienOption.focus ) {
            orienOption.focus = false;
            soundOption.focus = true;
        }
        // Current Selection is Sound Option
        else if ( soundOption.focus ) {
            soundOption.focus = false;
            powerOption.focus = true;
        }
        // Current Selection is Power Option
        else if ( powerOption.focus ) {
            powerOption.focus = false;
            playOption.focus = true;
        }
        // Current Selection is Play Option
        else if ( playOption.focus ) {
            playOption.focus = false;
            langOption.focus = true;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
    function gotoPreviousOption() {
        // Current Selection is Language Option
        if ( langOption.focus ) {
            langOption.focus = false;
            playOption.focus = true;
        }
        // Current Selection is Networking Option
        else if ( netOption.focus ) {
            langOption.focus = true;
            netOption.focus = false;
        }
        // Current Selection is Wireless Option
        else if ( wirelessOption.focus ) {
            netOption.focus = true;
            wirelessOption = false;
        }
        // Current Selection is Function Option
        else if ( funcOption.focus ) {
            wirelessOption.focus = true;
            funcOption.focus = false;
        }
        // Current Selection is Orientitation Option
        else if ( orienOption.focus ) {
            orienOption.focus = false;
            funcOption.focus = true;
        }
        // Current Selection is Sound Option
        else if ( soundOption.focus ) {
            soundOption.focus = false;
            orienOption.focus = true;
        }
        // Current Selection is Power Option
        else if ( powerOption.focus ) {
            powerOption.focus = false;
            soundOption.focus = true;
        }
        // Current Selection is Play Option
        else if ( playOption.focus ) {
            playOption.focus = false;
            powerOption.focus = true;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
}



