// Copyright 2011

// Button.qml
// This file contains the implementation of Button component. This
// component is used in all the buttons on the application except
// On screen keyboard buttons. This component does not communicate with
// QT C++ application.
// The mouse events are not being handled by this component rather in the calling screen / component.

import QtQuick 1.0

Item {
    width: 1920;
    height: 100;
    smooth: true;
    property alias text: caption.text
    property alias selection: selection.text;
    property alias background: selectionImage.source;

    Image {
        x: 100;
        id: selectionImage;
        width: 1250;
        height: 151;
        fillMode: Image.PreserveAspectCrop;

        Text {
            x: 60;
            id: caption;
            height: parent.height;
            font.pointSize: 30;
            font.bold: true;
            color: "#FFFFFF";
            horizontalAlignment: Text.AlignLeft;
            verticalAlignment: Text.AlignVCenter;
        }
        Image {
            id: arrow;
            x: 1110;
            source: "qrc:/arrow.png";
            fillMode: Image.PreserveAspectCrop;
            anchors.verticalCenter: caption.verticalCenter;
        }
    }
    Text {
        width: 300;
        id: selection;
        height: parent.height;
        font.pointSize: 24;
        color: "#FFFFFF";
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        anchors.left: selectionImage.right;
        anchors.verticalCenter: selectionImage.verticalCenter;
    }
}
