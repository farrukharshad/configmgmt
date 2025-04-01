
//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: function_screen
    width: 1920;
    height: 1080;

    property string selectingFor: "";

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
            text: guiStrings.txtFunction;
        }
        Text {
            id: functionDesc
            width: parent.width;
            height: 180;
            y: header.height;
            text: guiStrings.txtFuncDescription;
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            font.pointSize: 16;
            color: "white";
        }

        // Show Function Menu Options Options
        Item {
            id: functionSelectionMenu;
            visible: true
            Column {
                width:      parent.width;
                height:     1080 - header.height - functionDesc.height;
                y: header.height + functionDesc.height;

                MenuOption {
                    id: playerOption;
                    text: guiStrings.txtFunctionAsPlayer;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: {
                        if ( guiStrings.IsFunctionAsPlayer() ) {
                            guiStrings.txtOn;
                        } else {
                            guiStrings.txtOff;
                        }
                    }
                    focus: true;
                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
                MenuOption {
                    id: srvrOption;
                    text: guiStrings.txtFunctionAsSrvr;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: {
                        if ( guiStrings.IsFunctionAsPlayer() ) {
                            guiStrings.txtOff;
                        } else {
                            guiStrings.txtOn;
                        }
                    }

                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
            }
        }
        // Selection for On / Off
        Item {
            id: onOffSelectionMenu;
            visible: false;

            Column {
                width:      parent.width;
                height:     1080 - header.height - functionDesc.height;
                y: header.height + functionDesc.height;

                MenuOption {
                    id: onOption;
                    text: guiStrings.txtOn;
                    expandableOption: false;
                    selected: true;
                    focus: false;
                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
                MenuOption {
                    id: offOption;
                    text: guiStrings.txtOff;
                    expandableOption: false;
                    selected: false;
                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
            }
        }
    }
    states: [
        // Function As Player Option has got focus
        State {
            name: "PlayerSelection"
            when: playerOption.focus;

            PropertyChanges {
                target: playerOption
                selected: true;
            }
            PropertyChanges {
                target: srvrOption;
                selected: false;
            }
        },
        // Function as Server Option has got focus
        State {
            name: "SrvrSelection";
            when: srvrOption.focus;
            PropertyChanges {
                target: srvrOption
                selected: true;
            }
            PropertyChanges {
                target: playerOption;
                selected: false;
            }
        },
        // On Option has got focus
        State {
            name: "OnSelection"
            when: onOption.focus;

            PropertyChanges {
                target: onOption
                selected: true;
            }
            PropertyChanges {
                target: offOption;
                selected: false;
            }
        },
        // Off Option has got focus
        State {
            name: "OffSelection";
            when: offOption.focus;
            PropertyChanges {
                target: offOption
                selected: true;
            }
            PropertyChanges {
                target: onOption;
                selected: false;
            }
        }
    ]
    function handelKeyEvent(key) {
        // Up / Down Key
        if ( key == Qt.Key_Down || key == Qt.Key_Up ) {
            gotoNextOption();
        }
        // Left Key
        if ( key == Qt.Key_Left ) {
            // We are at the Function selection menu
            if ( selectingFor == "" )
                guiBackend.ChangeCurrentPage("main");
            else
                goBackToFunctionSelectionOption();
        }
        // Right Key is pressed
        if ( key == Qt.Key_Right ) {
            if ( playerOption.focus ) {
                selectingFor = "functionAsPlayer";
                header.text = guiStrings.txtFunctionAsPlayer;
                openOnOffSelectionOption();
            }
            else if ( srvrOption.focus ) {
                selectingFor = "functionAsServer";
                header.text = guiStrings.txtFunctionAsSrvr;
                openOnOffSelectionOption();
            }
        }
        // ENTER Key is pressed
        if ( key == Qt.Key_Return ) {
            if ( offOption.focus && onOffSelectionMenu.visible ) {
                if ( selectingFor == "functionAsPlayer" )
                    guiStrings.SetFuncAsPlayer(false);
                else if ( selectingFor == "functionAsServer" )
                    guiStrings.SetFuncAsPlayer(true);
                goBackToFunctionSelectionOption();
            }
            else if ( onOption.focus && onOffSelectionMenu.visible ) {
                if ( selectingFor == "functionAsPlayer" )
                    guiStrings.SetFuncAsPlayer(true);
                else if ( selectingFor == "functionAsServer" )
                    guiStrings.SetFuncAsPlayer(false);
                goBackToFunctionSelectionOption();
            }
        }
    }
    function gotoNextOption() {
        // Current Selection is English Option
        if ( playerOption.focus ) {
            playerOption.focus = false;
            srvrOption.focus = true;
        }
        // Current Selection is Nederlands Option
        else if ( srvrOption.focus ) {
            srvrOption.focus = false;
            playerOption.focus = true;
        }
        else if ( onOption.focus ) {
            onOption.focus = false;
            offOption.focus = true;
        }
        else if ( offOption.focus ) {
            offOption.focus = false;
            onOption.focus = true;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
    function openOnOffSelectionOption()
    {
        onOffSelectionMenu.visible = true;
        functionSelectionMenu.visible = false;
        onOption.focus = true;
        offOption.focus = false;
        playerOption.focus = false;
    }
    function goBackToFunctionSelectionOption()
    {
        selectingFor = "";
        header.text = guiStrings.txtFunction;
        onOption.focus = false;
        offOption.focus = false;
        onOffSelectionMenu.visible = false
        functionSelectionMenu.visible = true;
        playerOption.focus = true;
    }
}
