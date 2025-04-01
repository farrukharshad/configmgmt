// Copyright 2012

// Header.qml
// This file contains the implementation of GUI element which
// creates header on all screens of the GUI. This component does communicates
// with QT C++ backend application. It displays time using its own functions

import QtQuick 1.0

Item {
    id:         language_menu
    width:      1920
    height:     980;

    Column {
        MenuOption {
            id: enOption;
            text: "English";
            //selection: guiBackend.GetCurrentLanguage();
            background: "";
            focus: true;
            Keys.onPressed: {
                handelKeyEvent(event.key);
            }
        }
        MenuOption {
            id: nlOption;
            text: "Nederlands";
            //selection: guiBackend.GetCurrentNetworkStatus();
            background: "";
            Keys.onPressed: {
                handelKeyEvent(event.key);
            }
        }
        MenuOption {
            id: deOption;
            text: "Deutsch";
            //selection: guiBackend.GetCurrentWirelessStatus();
            background: "";
            Keys.onPressed: {
                handelKeyEvent(event.key);
            }
        }
    }

    states: [
        // English Option has got focus
        State {
            name: "EnglishSelection"
            when: enOption.focus;

            PropertyChanges {
                target: enOption
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: nlOption;
                background: "";
            }
            PropertyChanges {
                target: deOption;
                background: "";
            }
        },
        // Nederlands Option has got focus
        State {
            name: "NederlandsSelection";
            when: nlOption.focus;
            PropertyChanges {
                target: nlOption
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: enOption;
                background: "";
            }
            PropertyChanges {
                target: deOption;
                background: "";
            }
        },
        // Deutsch Option has got focus
        State {
            name: "DeutschSelection";
            when: deOption.focus;
            PropertyChanges {
                target: deOption
                background: "qrc:/menu_selector_arrow.png";
            }
            PropertyChanges {
                target: nlOption;
                background: "";
            }
            PropertyChanges {
                target: enOption;
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
            console.log("Handling the Right Key in function");
        }
    }
    function gotoNextOption() {
        // Current Selection is English Option
        if ( enOption.focus ) {
            enOption.focus = false;
            nlOption.focus = true;
        }
        // Current Selection is Nederlands Option
        else if ( nlOption.focus ) {
            nlOption.focus = false;
            deOption.focus = true;
        }
        // Current Selection is Deutsch Option
        else if ( deOption.focus ) {
            deOption = false;
            enOption.focus = true;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
    function gotoPreviousOption() {
        // Current Selection is English Option
        if ( enOption.focus ) {
            enOption.focus = false;
            deOption.focus = true;
        }
        // Current Selection is Nederlands Option
        else if ( nlOption.focus ) {
            enOption.focus = true;
            nlOption.focus = false;
        }
        // Current Selection is Deutsch Option
        else if ( deOption.focus ) {
            nlOption.focus = true;
            deOption = false;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
}
