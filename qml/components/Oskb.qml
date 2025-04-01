
// Copyright 2012

// oskb.qml
// This file contains the implementation of On Screen Keyboard. The keyboard is invoked
// user user taps on any field which will require input from the user. The keyboard can take
// multi line input. Once user is done with the keyboard input, the keyboard will return control
// to its calling screen and user input can be read from oskbInputField.text
// The logic of this keyboard is and display of different buttons is highly dependent on the
// two alphabet & numeric keys string. Care must be taken when these strings required any change.

import QtQuick 1.0

Item {

    id: oskb
    width: 1920;
    height: 1080;

    property alias title: header.text;

    property bool capsLock: true
    property bool alphabetKeysLock: true
    property string alphabetKeys:   "QWERTYUIOPASDFGHJKLZXCVBNM"
    property string numericKeys:    "0123456789+#*,.;:?-_&!@/\'\"ABCD"

    property string keys: alphabetKeys
    property alias input: oskbInputField.text;
    property string input_type: "normal"
    property bool input_focus: false;

    signal inputComplete(string output);

    Rectangle {
        width: parent.width;
        height: parent.height;
        color: "black";

        // Show Screen Header
        ScreenHeader {
            id: header;
            width: parent.width;
        }

        /* OSKB Upper Half */
        Item {
            id: upperHalf;
            y: header.height;
            width: parent.width;
            height: inputBgImage.sourceSize.height;
            anchors.horizontalCenter: parent.horizontalCenter;

            Image {
                id: inputBgImage;
                source: "qrc:/input-background.png"
                fillMode: Image.PreserveAspectCrop
                anchors.verticalCenter: parent.verticalCenter;
                anchors.horizontalCenter: parent.horizontalCenter;
                TextInput {
                    id: oskbInputField
                    x: 10
                    y: 10
                    color: "#ffffff"
                    font.family: "OpenSymbol"
                    font.pointSize: 20
                    font.bold: true;
                    maximumLength: 35;
                    anchors.verticalCenter: parent.verticalCenter;
                    cursorVisible: true;
                    echoMode: {
                        if ( input_type == "normal" ) {
                            TextInput.Normal;
                        } else if ( input_type == "password" ) {
                            TextInput.Password;
                        }
                    }
                }
            }
        }
        Item {
            id: lowerHalf;
            width: inputBgImage.sourceSize.width;
            anchors.top: upperHalf.bottom;
            anchors.topMargin: 40;
            anchors.horizontalCenter: parent.horizontalCenter;

            // ===================
            //  Buttons Row # 1
            // ===================
            Row {
                id: row1
                spacing: 2
                OSKBButton {
                    id: r1b1;
                    size: "small";
                    selected: true;
                    input_focus: if ( input_focus ) true; else false;
                    label: keys.charAt(0);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r1b2;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(1);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r1b3;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(2);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r1b4;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(3);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r1b5;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(4);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r1b6;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(5);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r1b7;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(6);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r1b8;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(7);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r1b9;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(8);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r1b10;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(9);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
            }
            // ===================
            //  Buttons Row # 2
            // ===================
            Row {
                id: row2
                spacing: 2
                anchors.top: row1.bottom;
                anchors.topMargin: spacing;

                OSKBButton {
                    id: r2empty1;
                    size: "pagap";
                    selected: false;
                    input_focus: false;
                    label: "";
                }
                OSKBButton {
                    id: r2b1;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(10);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r2b2;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(11);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r2b3;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(12);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r2b4;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(13);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r2b5;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(14);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r2b6;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(15);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r2b7;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(16);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r2b8;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(17);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r2b9;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(18);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
            }
            // ===================
            //  Buttons Row # 3
            // ===================
            Row {
                id: row3
                spacing: 2
                anchors.top: row2.bottom;
                anchors.topMargin: spacing;

                OSKBButton {
                    id: r3empty1;
                    size: "custom";
                    custom_width: 25;
                    selected: false;
                    input_focus: false;
                    label: "";
                }
                OSKBButton {
                    id: r3CapsLock;
                    size: "medium_small";
                    selected: false;
                    input_focus: false;
                    label: "";
                    icon_bg: "qrc:/oskb_icn_shift.png";
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r3b1;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(19);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r3b2;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(20);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r3b3;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(21);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r3b4;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(22);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r3b5;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(23);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r3b6;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(24);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r3b7;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: keys.charAt(25);
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r3backspace;
                    size: "medium_small";
                    selected: false;
                    input_focus: false;
                    label: ""
                    icon_bg: "qrc:/oskb_icn_del.png"
                    Keys.onPressed: handleKeyEvent(event.key);
                }
            }
            // ===================
            //  Buttons Row # 4
            // ===================
            Row {
                id: row4
                spacing: 2
                anchors.top: row3.bottom;
                anchors.topMargin: spacing;

                OSKBButton {
                    id: r4NumLock;
                    size: "medium";
                    selected: false;
                    input_focus: false;
                    label: "";
                    icon_bg: "qrc:/oskb_icn_num.png";
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r4b1;
                    size: "small";
                    selected: false;
                    input_focus: false;
                    label: ".";
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r4spaceBar;
                    size: "large_large";
                    selected: false;
                    input_focus: false;
                    label: "";
                    icon_bg: "qrc:/oskb_icn_space.png";
                    Keys.onPressed: handleKeyEvent(event.key);
                }
                OSKBButton {
                    id: r4return;
                    size: "medium";
                    selected: false;
                    input_focus: false;
                    label: "";
                    icon_bg: "qrc:/oskb_icn_ret.png";
                    Keys.onPressed: handleKeyEvent(event.key);
                }
            }
        }
    }
    Keys.onPressed: {
        handleKeyEvent(event.key);
    }
    states: [
        State {
            name: "CapsLockOn";
            when: capsLock == true && alphabetKeysLock == true;
            StateChangeScript {
                name: "TurnOnCapsLock";
                script: turnOffNumLock();
            }
        },
        State {
            name: "CapsLockOff";
            when: capsLock == false && alphabetKeysLock == true;
            StateChangeScript {
                name: "TurnOffCapsLock";
                script: turnOffNumLock();
            }
        },
        State {
            name: "NumLockOn";
            when: alphabetKeysLock == false;
            StateChangeScript {
                name: "TurnOnNumLock";
                script: turnOnNumLock();
            }
        }
    ]
    function handleKeyEvent(key) {
        if ( key == Qt.Key_Left || key == Qt.Key_Up )
            leftKeyPressed();
        else if ( key == Qt.Key_Right || key == Qt.Key_Down )
            rightKeyPressed();
        else if ( key == Qt.Key_Return )
            returnKeyPressed();
    }
    function leftKeyPressed() {
        //==========================
        // Row 1
        //==========================
        if ( r1b1.selected ) {
            r1b1.selected = false;
            r4return.selected = true;
        }
        else if ( r1b2.selected ) {
            r1b2.selected = false;
            r1b1.selected = true;
        }
        else if ( r1b3.selected ) {
            r1b3.selected = false;
            r1b2.selected = true;
        }
        else if ( r1b4.selected ) {
            r1b4.selected = false;
            r1b3.selected = true;
        }
        else if ( r1b5.selected ) {
            r1b5.selected = false;
            r1b4.selected = true;
        }
        else if ( r1b6.selected ) {
            r1b6.selected = false;
            r1b5.selected = true;
        }
        else if ( r1b7.selected ) {
            r1b7.selected = false;
            r1b6.selected = true;
        }
        else if ( r1b8.selected ) {
            r1b8.selected = false;
            r1b7.selected = true;
        }
        else if ( r1b9.selected ) {
            r1b9.selected = false;
            r1b8.selected = true;
        }
        else if ( r1b10.selected ) {
            r1b10.selected = false;
            r1b9.selected = true;
        }
        //==========================
        // Row 2
        //==========================
        else if ( r2b1.selected ) {
            r2b1.selected = false;
            r1b10.selected = true;
        }
        else if ( r2b1.selected ) {
            r2b1.selected = false;
            r1b10.selected = true;
        }
        else if ( r2b2.selected ) {
            r2b2.selected = false;
            r2b1.selected = true;
        }
        else if ( r2b3.selected ) {
            r2b3.selected = false;
            r2b2.selected = true;
        }
        else if ( r2b4.selected ) {
            r2b4.selected = false;
            r2b3.selected = true;
        }
        else if ( r2b5.selected ) {
            r2b5.selected = false;
            r2b4.selected = true;
        }
        else if ( r2b6.selected ) {
            r2b6.selected = false;
            r2b5.selected = true;
        }
        else if ( r2b7.selected ) {
            r2b7.selected = false;
            r2b6.selected = true;
        }
        else if ( r2b8.selected ) {
            r2b8.selected = false;
            r2b7.selected = true;
        }
        else if ( r2b9.selected ) {
            r2b9.selected = false;
            r2b8.selected = true;
        }
        //==========================
        // Row 3
        //==========================
        else if ( r3CapsLock.selected ) {
            r3CapsLock.selected = false;
            r2b9.selected = true;
        }
        else if ( r3b1.selected ) {
            r3b1.selected = false;
            r3CapsLock.selected = true;
        }
        else if ( r3b2.selected ) {
            r3b2.selected = false;
            r3b1.selected = true;
        }
        else if ( r3b3.selected ) {
            r3b3.selected = false;
            r3b2.selected = true;
        }
        else if ( r3b4.selected ) {
            r3b4.selected = false;
            r3b3.selected = true;
        }
        else if ( r3b5.selected ) {
            r3b5.selected = false;
            r3b4.selected = true;
        }
        else if ( r3b6.selected ) {
            r3b6.selected = false;
            r3b5.selected = true;
        }
        else if ( r3b7.selected ) {
            r3b7.selected = false;
            r3b6.selected = true;
        }
        else if ( r3backspace.selected ) {
            r3backspace.selected = false;
            r3b7.selected = true;
        }
        //=========================
        // Row # 4
        //=========================
        else if ( r4NumLock.selected ) {
            r4NumLock.selected = false;
            r3backspace.selected = true;
        }
        else if ( r4b1.selected ) {
            r4b1.selected = false;
            r4NumLock.selected = true;
        }
        else if ( r4spaceBar.selected ) {
            r4spaceBar.selected = false;
            r4b1.selected = true;
        }
        else if ( r4return.selected ) {
            r4return.selected = false;
            r4spaceBar.selected = true;
        }
    }
    function rightKeyPressed() {
        //==========================
        // Row 1
        //==========================
        if ( r1b1.selected ) {
            r1b1.selected = false;
            r1b2.selected = true;
        }
        else if ( r1b2.selected ) {
            r1b2.selected = false;
            r1b3.selected = true;
        }
        else if ( r1b3.selected ) {
            r1b3.selected = false;
            r1b4.selected = true;
        }
        else if ( r1b4.selected ) {
            r1b4.selected = false;
            r1b5.selected = true;
        }
        else if ( r1b5.selected ) {
            r1b5.selected = false;
            r1b6.selected = true;
        }
        else if ( r1b6.selected ) {
            r1b6.selected = false;
            r1b7.selected = true;
        }
        else if ( r1b7.selected ) {
            r1b7.selected = false;
            r1b8.selected = true;
        }
        else if ( r1b8.selected ) {
            r1b8.selected = false;
            r1b9.selected = true;
        }
        else if ( r1b9.selected ) {
            r1b9.selected = false;
            r1b10.selected = true;
        }
        else if ( r1b10.selected ) {
            r1b10.selected = false;
            r2b1.selected = true;
        }
        //==========================
        // Row 2
        //==========================
        else if ( r2b1.selected ) {
            r2b1.selected = false;
            r2b2.selected = true;
        }
        else if ( r2b1.selected ) {
            r2b1.selected = false;
            r2b2.selected = true;
        }
        else if ( r2b2.selected ) {
            r2b2.selected = false;
            r2b3.selected = true;
        }
        else if ( r2b3.selected ) {
            r2b3.selected = false;
            r2b4.selected = true;
        }
        else if ( r2b4.selected ) {
            r2b4.selected = false;
            r2b5.selected = true;
        }
        else if ( r2b5.selected ) {
            r2b5.selected = false;
            r2b6.selected = true;
        }
        else if ( r2b6.selected ) {
            r2b6.selected = false;
            r2b7.selected = true;
        }
        else if ( r2b7.selected ) {
            r2b7.selected = false;
            r2b8.selected = true;
        }
        else if ( r2b8.selected ) {
            r2b8.selected = false;
            r2b9.selected = true;
        }
        else if ( r2b9.selected ) {
            r2b9.selected = false;
            r3CapsLock.selected = true;
        }
        //==========================
        // Row 3
        //==========================
        else if ( r3CapsLock.selected ) {
            r3CapsLock.selected = false;
            r3b1.selected = true;
        }
        else if ( r3b1.selected ) {
            r3b1.selected = false;
            r3b2.selected = true;
        }
        else if ( r3b1.selected ) {
            r3b1.selected = false;
            r3b2.selected = true;
        }
        else if ( r3b2.selected ) {
            r3b2.selected = false;
            r3b3.selected = true;
        }
        else if ( r3b3.selected ) {
            r3b3.selected = false;
            r3b4.selected = true;
        }
        else if ( r3b4.selected ) {
            r3b4.selected = false;
            r3b5.selected = true;
        }
        else if ( r3b5.selected ) {
            r3b5.selected = false;
            r3b6.selected = true;
        }
        else if ( r3b6.selected ) {
            r3b6.selected = false;
            r3b7.selected = true;
        }
        else if ( r3b7.selected ) {
            r3b7.selected = false;
            r3backspace.selected = true;
        }
        else if ( r3backspace.selected ) {
            r3backspace.selected = false;
            r4NumLock.selected = true;
        }
        //=========================
        // Row # 4
        //=========================
        else if ( r4NumLock.selected ) {
            r4NumLock.selected = false;
            r4b1.selected = true;
        }
        else if ( r4b1.selected ) {
            r4b1.selected = false;
            r4spaceBar.selected = true;
        }
        else if ( r4spaceBar.selected ) {
            r4spaceBar.selected = false;
            r4return.selected = true;
        }
        else if ( r4return.selected ) {
            r4return.selected = false;
            r1b1.selected = true;
        }
    }
    function returnKeyPressed() {
        //==========================
        // Row 1
        //==========================
        if ( r1b1.selected ) {
            oskbInputField.text += r1b1.label;
        }
        else if ( r1b2.selected ) {
            oskbInputField.text += r1b2.label;
        }
        else if ( r1b3.selected ) {
            oskbInputField.text += r1b3.label;
        }
        else if ( r1b4.selected ) {
            oskbInputField.text += r1b4.label;
        }
        else if ( r1b5.selected ) {
            oskbInputField.text += r1b5.label;
        }
        else if ( r1b6.selected ) {
            oskbInputField.text += r1b6.label;
        }
        else if ( r1b7.selected ) {
            oskbInputField.text += r1b7.label;
        }
        else if ( r1b8.selected ) {
            oskbInputField.text += r1b8.label;
        }
        else if ( r1b9.selected ) {
            oskbInputField.text += r1b9.label;
        }
        else if ( r1b10.selected ) {
            oskbInputField.text += r1b10.label;
        }
        //==========================
        // Row 2
        //==========================
        else if ( r2b1.selected ) {
            oskbInputField.text += r2b1.label;
        }
        else if ( r2b2.selected ) {
            oskbInputField.text += r2b2.label;
        }
        else if ( r2b3.selected ) {
            oskbInputField.text += r2b3.label;
        }
        else if ( r2b4.selected ) {
            oskbInputField.text += r2b4.label;
        }
        else if ( r2b5.selected ) {
            oskbInputField.text += r2b5.label;
        }
        else if ( r2b6.selected ) {
            oskbInputField.text += r2b6.label;
        }
        else if ( r2b7.selected ) {
            oskbInputField.text += r2b7.label;
        }
        else if ( r2b8.selected ) {
            oskbInputField.text += r2b8.label;
        }
        else if ( r2b9.selected ) {
            oskbInputField.text += r2b9.label;
        }
        //==========================
        // Row 3
        //==========================
        else if ( r3CapsLock.selected ) {
            capsLock = !(capsLock);
        }
        else if ( r3b1.selected ) {
            oskbInputField.text += r3b1.label;
        }
        else if ( r3b2.selected ) {
            oskbInputField.text += r3b2.label;
        }
        else if ( r3b3.selected ) {
            oskbInputField.text += r3b3.label;
        }
        else if ( r3b4.selected ) {
            oskbInputField.text += r3b4.label;
        }
        else if ( r3b5.selected ) {
            oskbInputField.text += r3b5.label;
        }
        else if ( r3b6.selected ) {
            oskbInputField.text += r3b6.label;
        }
        else if ( r3b7.selected ) {
            oskbInputField.text += r3b7.label;
        }
        else if ( r3backspace.selected ) {
            if ( oskbInputField.text.length > 0 ) {
                oskbInputField.text = oskbInputField.text.substring(0, (oskbInputField.text.length-1))
            }
        }
        //=========================
        // Row # 4
        //=========================
        else if ( r4NumLock.selected ) {
            alphabetKeysLock = !(alphabetKeysLock);
        }
        else if ( r4b1.selected ) {
            oskbInputField.text += r4b1.label;
        }
        else if ( r4spaceBar.selected ) {
            oskbInputField.text += ' ';
        }
        else if ( r4return.selected ) {
            inputComplete(oskbInputField.text);
        }
    }
    function turnOnCapsLock() {
        //==========================
        // Row 1
        //==========================
        r1b1.label = keys.charAt(0).toUpperCase();
        r1b2.label = keys.charAt(1).toUpperCase();
        r1b3.label = keys.charAt(2).toUpperCase();
        r1b4.label = keys.charAt(3).toUpperCase();
        r1b5.label = keys.charAt(4).toUpperCase();
        r1b6.label = keys.charAt(5).toUpperCase();
        r1b7.label = keys.charAt(6).toUpperCase();
        r1b8.label = keys.charAt(7).toUpperCase();
        r1b9.label = keys.charAt(8).toUpperCase();
        r1b10.label = keys.charAt(9).toUpperCase();

        //==========================
        // Row 2
        //==========================
        r2b1.label = keys.charAt(10).toUpperCase();
        r2b2.label = keys.charAt(11).toUpperCase();
        r2b3.label = keys.charAt(12).toUpperCase();
        r2b4.label = keys.charAt(13).toUpperCase();
        r2b5.label = keys.charAt(14).toUpperCase();
        r2b6.label = keys.charAt(15).toUpperCase();
        r2b7.label = keys.charAt(16).toUpperCase();
        r2b8.label = keys.charAt(17).toUpperCase();
        r2b9.label = keys.charAt(18).toUpperCase();

        //==========================
        // Row 3
        //==========================
        r3b1.label = keys.charAt(19).toUpperCase();
        r3b2.label = keys.charAt(20).toUpperCase();
        r3b3.label = keys.charAt(21).toUpperCase();
        r3b4.label = keys.charAt(22).toUpperCase();
        r3b5.label = keys.charAt(23).toUpperCase();
        r3b6.label = keys.charAt(24).toUpperCase();
        r3b7.label = keys.charAt(25).toUpperCase();
    }
    function turnOffCapsLock() {
        //==========================
        // Row 1
        //==========================
        r1b1.label = keys.charAt(0).toLowerCase();
        r1b2.label = keys.charAt(1).toLowerCase();
        r1b3.label = keys.charAt(2).toLowerCase();
        r1b4.label = keys.charAt(3).toLowerCase();
        r1b5.label = keys.charAt(4).toLowerCase();
        r1b6.label = keys.charAt(5).toLowerCase();
        r1b7.label = keys.charAt(6).toLowerCase();
        r1b8.label = keys.charAt(7).toLowerCase();
        r1b9.label = keys.charAt(8).toLowerCase();
        r1b10.label = keys.charAt(9).toLowerCase();

        //==========================
        // Row 2
        //==========================
        r2b1.label = keys.charAt(10).toLowerCase();
        r2b2.label = keys.charAt(11).toLowerCase();
        r2b3.label = keys.charAt(12).toLowerCase();
        r2b4.label = keys.charAt(13).toLowerCase();
        r2b5.label = keys.charAt(14).toLowerCase();
        r2b6.label = keys.charAt(15).toLowerCase();
        r2b7.label = keys.charAt(16).toLowerCase();
        r2b8.label = keys.charAt(17).toLowerCase();
        r2b9.label = keys.charAt(18).toLowerCase();

        //==========================
        // Row 3
        //==========================
        r3b1.label = keys.charAt(19).toLowerCase();
        r3b2.label = keys.charAt(20).toLowerCase();
        r3b3.label = keys.charAt(21).toLowerCase();
        r3b4.label = keys.charAt(22).toLowerCase();
        r3b5.label = keys.charAt(23).toLowerCase();
        r3b6.label = keys.charAt(24).toLowerCase();
        r3b7.label = keys.charAt(25).toLowerCase();
    }
    function turnOnNumLock() {
        keys = numericKeys;
        turnOnCapsLock();
    }
    function turnOffNumLock() {
        keys = alphabetKeys;
        if ( capsLock )
            turnOnCapsLock();
        else
            turnOffCapsLock();
    }
}
