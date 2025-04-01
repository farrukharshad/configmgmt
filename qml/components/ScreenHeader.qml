// Copyright 2012

// Header.qml
// This file contains the implementation of GUI element which
// creates header on all screens of the GUI. This component does communicates
// with QT C++ backend application. It displays time using its own functions

import QtQuick 1.0

Item {
    id:         header
    width:      1920
    height:     100

    property alias text: label.text

    Text {
        id: label
        font.pointSize: 40
        font.bold: true;
        color: "white"
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
