// Copyright 2011

// Button.qml
// This file contains the implementation of Button component. This
// component is used in all the buttons on the application except
// On screen keyboard buttons. This component does not communicate with
// QT C++ application.
// The mouse events are not being handled by this component rather in the calling screen / component.

import QtQuick 1.0

Image {
    id:     ipInput
    width:  1920;
    height: 1080  // These are the dimensions of the background image.
    smooth: true;
    source: "qrc:/bg_ip.png"
    fillMode: Image.PreserveAspectCrop

    property alias caption: header.text;
    property alias description: desc.text;
    property alias input_focus: tupleInputSelector.focus;
    property int ip_tuple: 1;
    property bool work_done: false;
    property bool update_ip_value: false;
    property int fontSize: 32;
    property int boxWidth: 55;
    property int boxHeight: 97;
    property string functionality: "none";

    property int ipDigit1Value: 1;
    property int ipDigit2Value: 1;
    property int ipDigit3Value: 1;
    property int ipDigit4Value: 1;
    property int ipDigit5Value: 1;
    property int ipDigit6Value: 1;
    property int ipDigit7Value: 1;
    property int ipDigit8Value: 1;
    property int ipDigit9Value: 1;
    property int ipDigit10Value: 1;
    property int ipDigit11Value: 1;
    property int ipDigit12Value: 1;

    ScreenHeader {
        id: header;
    }
    Text {
        id: desc
        width: parent.width;
        height: 180;
        y: header.height;
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        font.pointSize: 16;
        color: "white";
    }
    Button {
        id: doneButton;
        x: 1310;
        y: 470;
        selected: false;
        text: guiStrings.txtDone;
    }
    Item {
        id: tupleInputSelector;
        Image {
            id: uparrow;
            smooth: true;
            source: "qrc:/arrowup.png";
            fillMode: Image.PreserveAspectCrop;
            anchors.horizontalCenter: selectorImg.horizontalCenter;
        }

        Image {
            id: selectorImg;
            smooth: true;
            source: "qrc:/ip_tuple_selector.png";
            fillMode: Image.PreserveAspectCrop;
            anchors.top: uparrow.bottom;
        }
        Image {
            id: downarrow;
            smooth: true;
            source: "qrc:/arrowdown.png";
            fillMode: Image.PreserveAspectCrop;
            anchors.top: selectorImg.bottom;
            anchors.horizontalCenter: selectorImg.horizontalCenter;
        }

        Keys.onPressed: handleKeyEvent(event.key);
    }
    Item {
        Row {
            x: 529;
            y: 482;
            id: tuple1Col;
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit1Text;
                    anchors.fill: parent;
                    text: ipDigit1Value;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit2Text
                    text: ipDigit2Value;
                    anchors.fill: parent;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit3Text
                    text: ipDigit3Value;
                    anchors.fill: parent;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
        }
        Row {
            x: 729;
            y: 482;
            id: tuple2Col;
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit4Text
                    anchors.fill: parent;
                    text: ipDigit4Value;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit5Text
                    text: ipDigit5Value;
                    anchors.fill: parent;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit6Text
                    text: ipDigit6Value;
                    anchors.fill: parent;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
        }
        Row {
            x: 928;
            y: 482;
            id: tuple3Col;
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit7Text
                    anchors.fill: parent;
                    text: ipDigit7Value;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit8Text
                    text: ipDigit8Value;
                    anchors.fill: parent;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit9Text
                    text: ipDigit9Value;
                    anchors.fill: parent;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
        }
        Row {
            x: 1126;
            y: 482;
            id: tuple4Col;
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit10Text
                    anchors.fill: parent;
                    text: ipDigit10Value;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit11Text
                    text: ipDigit11Value;
                    anchors.fill: parent;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
            Item {
                width: boxWidth;
                height: boxHeight;
                Text {
                    id: ipDigit12Text
                    text: ipDigit12Value;
                    anchors.fill: parent;
                    color: "#FFFFFF";
                    font.pointSize: fontSize;
                    verticalAlignment: Text.AlignVCenter;
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
        }
    }
    states: [
        State {
            name: "1.1Selected";
            when: ip_tuple == 1;

            PropertyChanges {
                target: tupleInputSelector;
                x: 520;
                y: 458;
            }
        },
        State {
            name: "1.2Selected";
            when: ip_tuple == 2;

            PropertyChanges {
                target: tupleInputSelector;
                x: 576;
                y: 458;
            }
        },
        State {
            name: "1.3Selected";
            when: ip_tuple == 3;

            PropertyChanges {
                target: tupleInputSelector;
                x: 632;
                y: 458;
            }
        },
        State {
            name: "2.1Selected";
            when: ip_tuple == 4;

            PropertyChanges {
                target: tupleInputSelector;
                x: 718;
                y: 458;
            }
        },
        State {
            name: "2.2Selected";
            when: ip_tuple == 5;

            PropertyChanges {
                target: tupleInputSelector;
                x: 774;
                y: 458;
            }
        },
        State {
            name: "2.3Selected";
            when: ip_tuple == 6;

            PropertyChanges {
                target: tupleInputSelector;
                x: 830;
                y: 458;
            }
        },
        State {
            name: "3.1Selected";
            when: ip_tuple == 7;

            PropertyChanges {
                target: tupleInputSelector;
                x: 917;
                y: 458;
            }
        },
        State {
            name: "3.2Selected";
            when: ip_tuple == 8;

            PropertyChanges {
                target: tupleInputSelector;
                x: 973;
                y: 458;
            }
        },
        State {
            name: "3.3Selected";
            when: ip_tuple == 9;

            PropertyChanges {
                target: tupleInputSelector;
                x: 1029;
                y: 458;
            }
        },
        State {
            name: "4.1Selected";
            when: ip_tuple == 10;

            PropertyChanges {
                target: tupleInputSelector;
                x: 1115;
                y: 458;
            }
        },
        State {
            name: "4.2Selected";
            when: ip_tuple == 11;

            PropertyChanges {
                target: tupleInputSelector;
                x: 1171;
                y: 458;
            }
        },
        State {
            name: "4.3Selected";
            when: ip_tuple == 12;

            PropertyChanges {
                target: tupleInputSelector;
                x: 1227;
                y: 458;
                visible: true;
            }
        },
        State {
            name: "DoneStateForTuple";
            when: doneButton.selected == true;

            PropertyChanges {
                target: tupleInputSelector;
                //visible: false;
                opacity: 0;
            }
        }

    ]

    function handleKeyEvent(key) {
        if ( key == Qt.Key_Right ) {
            if ( ip_tuple <= 12 ) {
                ip_tuple++;
                if ( ip_tuple == 13 ) {
                    doneButton.selected = true;
                }
            } else {
                //ip_tuple++;
                doneButton.selected = true;
            }
        } else if ( key == Qt.Key_Left ) {
            doneButton.selected = false;
            if ( ip_tuple > 1 ) {
                ip_tuple--;
                if ( ip_tuple == 12 ) {
                    doneButton.selected = false;
                }
            } else {
                ip_tuple = 1;
            }
            doneButton.selected = false;
        } else if ( key == Qt.Key_Up ) {
            handleDigitDecrement();
        } else if ( key == Qt.Key_Down ) {
            handleDigitIncrement();
        } else if ( key == Qt.Key_Return ) {
            if ( doneButton.selected ) {
                // TODO:
                // Additionally we can verify if the provided input is a valid IP address or not.
                // Save the input IP Address.
                guiStrings.SetManualIpAddress((ipDigit1Text.text + ipDigit2Text.text + ipDigit3Text.text + "." + ipDigit4Text.text + ipDigit5Text.text + ipDigit6Text.text + "." + ipDigit7Text.text + ipDigit8Text.text + ipDigit9Text.text + "." + ipDigit10Text.text + ipDigit11Text.text + ipDigit12Text.text),
                                              functionality);
                work_done = true;
            }
        }
    }
    function handleDigitIncrement()
    {
        if ( ip_tuple == 1 ) {
            if ( ipDigit1Value < 2 )
                ipDigit1Value++;
        } else if ( ip_tuple == 2 ) {
            if ( ipDigit2Value < 9 )
                ipDigit2Value++;
        } else if ( ip_tuple == 3 ) {
            if ( ipDigit3Value < 9 )
                ipDigit3Value++;
        } else if ( ip_tuple == 4 ) {
            if ( ipDigit4Value < 2 )
                ipDigit4Value++;
        } else if ( ip_tuple == 5 ) {
            if ( ipDigit5Value < 9 )
                ipDigit5Value++;
        } else if ( ip_tuple == 6 ) {
            if ( ipDigit6Value < 9 )
                ipDigit6Value++;
        } else if ( ip_tuple == 7 ) {
            if ( ipDigit7Value < 2 )
                ipDigit7Value++;
        } else if ( ip_tuple == 8 ) {
            if ( ipDigit8Value < 9 )
                ipDigit8Value++;
        } else if ( ip_tuple == 9 ) {
            if ( ipDigit9Value < 9 )
                ipDigit9Value++;
        } else if ( ip_tuple == 10 ) {
            if ( ipDigit10Value < 2 )
                ipDigit10Value++;
        } else if ( ip_tuple == 11 ) {
            if ( ipDigit11Value < 9 )
                ipDigit11Value++;
        } else if ( ip_tuple == 12 ) {
            if ( ipDigit12Value < 9 )
                ipDigit12Value++;
        }
    }
    function handleDigitDecrement()
    {
        if ( ip_tuple == 1 ) {
            if ( ipDigit1Value > 0 )
                ipDigit1Value--;
        } else if ( ip_tuple == 2 ) {
            if ( ipDigit2Value > 0 )
                ipDigit2Value--;
        } else if ( ip_tuple == 3 ) {
            if ( ipDigit3Value > 0 )
                ipDigit3Value--;
        } else if ( ip_tuple == 4 ) {
            if ( ipDigit4Value > 0 )
                ipDigit4Value--;
        } else if ( ip_tuple == 5 ) {
            if ( ipDigit5Value > 0 )
                ipDigit5Value--;
        } else if ( ip_tuple == 6 ) {
            if ( ipDigit6Value > 0 )
                ipDigit6Value--;
        } else if ( ip_tuple == 7 ) {
            if ( ipDigit7Value > 0 )
                ipDigit7Value--;
        } else if ( ip_tuple == 8 ) {
            if ( ipDigit8Value > 0 )
                ipDigit8Value--;
        } else if ( ip_tuple == 9 ) {
            if ( ipDigit9Value > 0 )
                ipDigit9Value--;
        } else if ( ip_tuple == 10 ) {
            if ( ipDigit10Value > 0 )
                ipDigit10Value--;
        } else if ( ip_tuple == 11 ) {
            if ( ipDigit11Value > 0 )
                ipDigit11Value--;
        } else if ( ip_tuple == 12 ) {
            if ( ipDigit12Value > 0 )
                ipDigit12Value--;
        }
    }
}
