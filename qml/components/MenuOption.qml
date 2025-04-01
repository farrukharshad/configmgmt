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
    property bool  expandableOption: true;
    property bool  selected: false;
    property bool  inside: false;
    property bool  disabled: false;
    property bool  selection_disabled: false;
    states: [
        State {
            name: "OptionSelected";
            when: selected == true;
            PropertyChanges {
                target: selectionImage;
                source: if ( expandableOption ) "qrc:/menu_selector_arrow.png"; else "qrc:/menu_selector_noarrow.png";
            }
        },
        State {
            name: "OptionUnselected";
            when: selected == false;
            PropertyChanges {
                target: selectionImage;
                source: "";
            }
        },
        State {
            name: "DisabledSelection";
            when: selection_disabled == true;
            PropertyChanges {
                target: selection;
                color: "#656565";

            }
        },
        State {
            name: "EnabledSelection";
            when: selection_disabled == false;
            PropertyChanges {
                target: selection;
                color: "#FFFFFF";

            }
        },
        State {
            name: "DisabledOption";
            when: disabled == true;
            PropertyChanges {
                target: caption;
                color: "#656565";
            }
            PropertyChanges {
                target: selection;
                color: "#656565";
            }
        },
        State {
            name: "EnabledOption";
            when: disabled == false;
            PropertyChanges {
                target: caption;
                color: "#FFFFFF";
            }
            PropertyChanges {
                target: selection;
                color: "#FFFFFF";
            }
        }
    ]
    Image {
        x: 100;
        id: selectionImage;
        width: 1250;
        height: 151;
        fillMode: Image.PreserveAspectCrop;
        focus: false;
        Text {
            x: 60;
            id: caption;
            height: parent.height;
            width: parent.width;
            font.pointSize: 30;
            font.bold: true;
            color: if ( !disabled ) "#FFFFFF"; else "#656565";
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: {
                if ( expandableOption )
                    Text.AlignLeft;
                else
                    Text.AlignHCenter;
            }
        }
        Image {
            id: arrow;
            x: 1110;
            source: {
                if ( expandableOption )
                    "qrc:/arrow.png";
                else
                    "";
            }
            focus: false;
            fillMode: Image.PreserveAspectCrop;
            anchors.verticalCenter: caption.verticalCenter;
        }
        Text {
            width: 300;
            id: selection;
            focus: false;
            height: parent.height;
            font.pointSize: 24;
            color: if ( !selection_disabled ) "#FFFFFF"; else "#656565";
            horizontalAlignment: if ( !inside) Text.AlignHCenter; else Text.AlignRight;
            verticalAlignment: Text.AlignVCenter;
            anchors.left: if ( !inside ) selectionImage.right;
            anchors.right: if ( inside ) arrow.left;
            anchors.rightMargin: 20;
            anchors.verticalCenter: selectionImage.verticalCenter;
        }
    }
}
