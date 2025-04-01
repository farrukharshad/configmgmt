
// Copyright 2012

// OSKBButton.qml
// This file contains the implementation of On Screen Keyboard button GUI object.
// This component is handling mouse events.

import QtQuick 1.0

Rectangle {
    id: oskb_btn_bg
    property int custom_width: 0
    property bool selected: false;
    property bool pressed: false;
    property bool input_focus: false;
    property alias label: oskbButtonCaption.text
    property alias icon_bg: icon.source;
    property string size: "small";          // This button can have following different sizes.
                                            // Small
                                            // Medium Small
                                            // Medium
                                            // Medium Large
                                            // Large
                                            // Empty 1
                                            // Empty 2
                                            // Empty 3

    radius: 2;
    height: 76;
    //focus: if ( input_focus ) true; else false;
    focus: false;
    border.width: 5;
    border.color: getBorderColor();
    color: getBackgroundColor();
    width: {
        if ( size == "small" )
            95;
        else if ( size == "medium_small" )
            130;
        else if ( size == "medium" )
            170;
        else if ( size == "medium_large" )
            220;
        else if ( size == "large" )
            420;
        else if ( size == "large_large" )
            550;
        else if ( size == "empty1" )
            68;
        else if ( size == "empty2" )
            40;
        else if ( size == "empty3" )
            55;
        else if ( size == "pagap" )
            50;
        else if ( size == "underscoregap" )
            88;
        else if ( size == "custom" )
            custom_width;
    }
    Image {
        id: icon
        focus: false;
        fillMode: Image.PreserveAspectCrop
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
        id: oskbButtonCaption
        color: "white"
        anchors.fill: parent
        font.bold: true
        focus: false;
        font.pointSize: 20;
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    states: [
        State {
            name: "ButtonPressed"
            when: mouseArea.pressed

            PropertyChanges {
                target: oskb_btn_bg
                color: getBackgroundColor();
            }
        },
        State {
            name: "ButtonSelected"
            when: selected == true;
            PropertyChanges {
                target: oskb_btn_bg;
                border.color:getBorderColor();
            }
        },
        State {
            name: "ButtonUnselected";
            when: selected == false;
            PropertyChanges {
                target: oskb_btn_bg;
                border.color: getBorderColor();
            }
        }
    ]
    function getBorderColor()
    {
        if ( size != "empty1" && size != "empty2" && size != "empty3" && size != "pagap" && size != "underscoregap" && size != "custom" ) {
            if ( selected ) {
                return "blue";
            } else {
                return "gray";
            }
        }
        return "transparent";
    }
    function getBackgroundColor()
    {
        if ( size != "empty1" && size != "empty2" && size != "empty3" && size != "pagap" && size != "underscoregap" && size != "custom" ) {
            if ( !pressed )
                return "black";
            else
                return "blue";
        }
        return "transparent";
    }
}
