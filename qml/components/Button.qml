// Copyright 2011

// Button.qml
// This file contains the implementation of Button component. This
// component is used in all the buttons on the application except
// On screen keyboard buttons. This component does not communicate with
// QT C++ application.
// The mouse events are not being handled by this component rather in the calling screen / component.

import QtQuick 1.0

Image {
    id:     button
    smooth: true;
    width: 147;
    height: 117;
    //source: if ( selected ) "qrc:/done_button.png"; else "";
    fillMode: Image.PreserveAspectCrop

    property bool selected: false;
    property alias text: label.text

    Text {
        id: label
        anchors.fill: parent;
        font.pointSize: 22
        color: "#FFFFFF"
        verticalAlignment: Text.AlignVCenter;
        horizontalAlignment: Text.AlignHCenter;
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    states: [
        State {
            name: "DoneSelected";
            when: selected == true;
            PropertyChanges {
                target: button;
                source: "qrc:/done_button.png";
            }
        },
        State {
            name: "DoneUnselected";
            when: selected == false;
            PropertyChanges {
                target: button;
                source: "";
            }
        }
    ]
}
