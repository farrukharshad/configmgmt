
//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: binaryconfiginput_screen
    width: 1920;
    height: 1080;

    property alias title: header.text;
    property alias option1caption: optionOne.text;
    property alias option2caption: optionTwo.text;
    property alias isOption1Expandable: optionOne.expandableOption;
    property alias isOption2Expandable: optionTwo.expandableOption;
    property alias option1SelectionText: optionOne.selection;
    property alias option2SelectionText: optionTwo.selection;

    property int initialOption: 1;
    property int selectedOption: -1; // -1 = Initial Selection
                                     //  0 = Canceled the selection <-- Left key is pressed
                                     //  1 = First option is selected
                                     //  2 = Second option is selected
    property bool work_done: false;
    property bool input_focus: false;
    property string functionality: "";

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
        }

        // Show Function Menu Options Options
        Column {
            width:      parent.width;
            height:     1080 - header.height;
            y: header.height;

            MenuOption {
                id: optionOne;
                //text: guiStrings.txtAutomatic;
                //expandableOption: false;
                selected: if ( initialOption == 1 ) true; else false;
                focus: if ( input_focus ) {
                           if ( initialOption == 1 ) {
                               true
                           } else {
                               false;
                           }
                       } else {
                           false;
                       }

                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: optionTwo;
                //expandableOption: false;
                selected: if ( initialOption == 2 ) true; else false;
                focus: if ( input_focus ) {
                           if ( initialOption == 2 ) {
                               true;
                           } else {
                               false;
                           }
                       } else {
                           false;
                       }

                //selection: "";

                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
        }
    }
    function handelKeyEvent(key) {
        console.log("QML: BinaryConfigInput Key Handler");
        // Down / Up Key
        if ( key == Qt.Key_Down || key == Qt.Key_Up ) {
            gotoNextOption();
        }
        // Left Key
        if ( key == Qt.Key_Left ) {
            selectedOption = 0;
            work_done = true;
        }
        // ENTER Key is pressed
        if ( key == Qt.Key_Return ) {
            if ( optionOne.selected ) {
                selectedOption = 1;
            }
            else if ( optionTwo.selected ) {
                selectedOption = 2;
            }
            work_done = true;
        }
    }
    function gotoNextOption() {
        // Current Selection is HDMI Option
        if ( optionOne.selected ) {
            optionOne.selected = false;
            optionTwo.selected = true;
        }
        // Current Selection is Headphone Option
        else if ( optionTwo.selected ) {
            optionTwo.selected = false;
            optionOne.selected = true;
        }
        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
}
