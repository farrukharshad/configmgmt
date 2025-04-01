// Copyright 2012

// Header.qml
// This file contains the implementation of GUI element which
// creates header on all screens of the GUI. This component does communicates
// with QT C++ backend application. It displays time using its own functions

import QtQuick 1.0

Item {
    id:         main_menu
    width:      1920
    height:     980;

    signal openPage(string page);

    Column {
        MenuOption {
            id: langOption;
            text: guiStrings.txtLanguage;
            selection: guiBackend.GetCurrentLanguage();
            background: "";
            focus: true;
            Keys.onPressed: {
                handelKeyEvent(event.key);
            }
        }
        MenuOption {
            id: netOption;
            text: guiStrings.txtNetworkSettings;
            selection: guiBackend.GetCurrentNetworkStatus();
            background: "";
            Keys.onPressed: {
                handelKeyEvent(event.key);
            }
        }
        MenuOption {
            id: wirelessOption;
            text: guiStrings.txtWirelessNetwork;
            selection: guiBackend.GetCurrentWirelessStatus();
            background: "";
            Keys.onPressed: {
                handelKeyEvent(event.key);
            }
        }
        MenuOption {
            id: funcOption;
            text: guiStrings.txtFunction;
            selection: guiBackend.GetCurrentFunction();
            background: "";
            Keys.onPressed: {
                handelKeyEvent(event.key);
            }
        }
        MenuOption {
            id: orienOption;
            text: guiStrings.txtOrientitation;
            selection: guiBackend.GetCurrentOrientitation();
            background: "";
            Keys.onPressed: {
                handelKeyEvent(event.key);
            }
        }
        MenuOption {
            id: soundOption;
            text: guiStrings.txtSound;
            selection: guiBackend.GetCurrentSoundSource();
            background: "";
            Keys.onPressed: {
                handelKeyEvent(event.key);
            }
        }
        MenuOption {
            id: powerOption;
            text: guiStrings.txtPower;
            selection: ""
            background: "";
            Keys.onPressed: {
                handelKeyEvent(event.key);
            }
        }
        MenuOption {
            id: playOption;
            text: guiStrings.txtPlay;
            selection: "";
            background: "";
            Keys.onPressed: {
                handelKeyEvent(event.key);
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
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: netOption;
                background: "";
            }
            PropertyChanges {
                target: playOption;
                background: "";
            }
        },
        // Networking Option has got focus
        State {
            name: "NetOptSelect";
            when: netOption.focus;
            PropertyChanges {
                target: netOption
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: langOption;
                background: "";
            }
            PropertyChanges {
                target: wirelessOption;
                background: "";
            }
        },
        // Wireless Option has got focus
        State {
            name: "WirelessOptSelect";
            when: wirelessOption.focus;
            PropertyChanges {
                target: wirelessOption
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: netOption;
                background: "";
            }
            PropertyChanges {
                target: funcOption;
                background: "";
            }
        },
        // Function Option has got focus
        State {
            name: "FuncOptSelect";
            when: funcOption.focus;
            PropertyChanges {
                target: funcOption
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: wirelessOption;
                background: "";
            }
            PropertyChanges {
                target: orienOption;
                background: "";
            }
        },
        // Orientitation Option has got focus
        State {
            name: "OrientOptSelect";
            when: orienOption.focus;
            PropertyChanges {
                target: orienOption
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: funcOption;
                background: "";
            }
            PropertyChanges {
                target: soundOption;
                background: "";
            }
        },
        // Sound Option has got focus
        State {
            name: "SoundOptSelect";
            when: soundOption.focus;
            PropertyChanges {
                target: soundOption
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: orienOption;
                background: "";
            }
            PropertyChanges {
                target: powerOption;
                background: "";
            }
        },
        // Power Option has got focus
        State {
            name: "PowerOptSelect";
            when: powerOption.focus;
            PropertyChanges {
                target: powerOption
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: soundOption;
                background: "";
            }
            PropertyChanges {
                target: playOption;
                background: "";
            }
        },
        // Play Option has got focus
        State {
            name: "PlayOptSelect";
            when: playOption.focus;
            PropertyChanges {
                target: playOption
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: powerOption;
                background: "";
            }
            PropertyChanges {
                target: langOption;
                background: "";
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
        // Left Key
        if ( key == Qt.Key_Left ) {
            console.log("Handling the Left Key in funciton");
        }
        // Right Key
        if ( key == Qt.Key_Right ) {
            // Open the language selection page
            if ( langOption.focus ) {
                main_menu.openPage("language");
            }
            // Open the Network settings page
            else if ( netOption.focus ) {
                main_menu.openPage("network");
            }
            // Open the wireless settings page
            else if ( wirelessOption.focus ) {
                main_menu.openPage("wireless");
            }
            // Open the Function settings page
            else if ( funcOption.focus ) {
                main_menu.openPage("function");
            }
            // Open the Orientitation settings page
            else if ( orienOption.focus ) {
                main_menu.openPage("orientitation");
            }
            // Open the Sound settings page
            else if ( soundOption.focus ) {
                main_menu.openPage("sound");
            }
            // Open the Power settings page
            else if ( powerOption.focus ) {
                main_menu.openPage("power");
            }
            // Open the Play settings page
            else if ( playOption.focus ) {
                main_menu.openPage("play");
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
