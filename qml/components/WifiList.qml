//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: wifilist_screen
    width: 1920;
    height: 1080;

    property bool input_focus: false;
    property bool work_done: false;
    property int  selected_ap_idx: -1;

//    Component.onCompleted: {
////        // First of all we will enable Wifi device.
////        guiStrings.EnableDisableWifi(true);

////        // Now we will scan wireless devices.
////        guiStrings.ScanWirelessNetworks();
//        console.log("Wifi List page loaded");
//    }
//    Item {
//        Connections {
//            target: guiStrings
//            onOpenWifiAuthenticationPage: openWifiAuthenticationPage();
//        }
//    }
    Rectangle {
        id: listScreen;
        width: parent.width;
        height: parent.height;
        color: "black";

        // Show Screen Header
        ScreenHeader {
            id: header;
            width:  parent.width;
            text: guiStrings.txtWifiNetwork;
        }

        // Wifi Network Scan Screen

        Component {
            id: listDelegate
            MenuOption {
                id: wifiOption;
                text: ssid;
                expandableOption: false;
                selection: "";
                selected: if ( index == list_view.currentIndex ) true; else false;
                Keys.onPressed: {
                    handleKeyEvent(event.key);
                }
            }
        }
        ListView {
            id: list_view
            width:      parent.width;
            height:     1080 - header.height;
            y: header.height;
            currentIndex: 0;
            boundsBehavior: Flickable.StopAtBounds
            model: wifiNetworksModel;
            delegate: listDelegate;
            focus: if ( input_focus ) true; else false;
        }
    }
    states: [
        State {
            name: "LostFocus";
            when: input_focus == false;
            PropertyChanges {
                target: list_view
                visible: false;
            }
        },
        State {
            name: "HasFocus";
            when: input_focus == true;
            PropertyChanges {
                target: list_view
                visible: true;
            }
        }
    ]
    function handleKeyEvent(key)
    {
        console.log("QML: WifiList Key handler");
        if ( key == Qt.Key_Up ) {
            if ( list_view.currentIndex == 0 )
                list_view.currentIndex = (list_view.count);
        } else if ( key == Qt.Key_Down ) {
            if ( list_view.currentIndex == (list_view.count - 1) )
                list_view.currentIndex = -1;
        } else if ( key == Qt.Key_Left ) {
            // Go back to previous screen cancelling the operation.
            selected_ap_idx = -1;
            work_done = true;
            nextOperation = "enabledisable";
        } else if ( key == Qt.Key_Return ) {
            // Go back to previous selecting any particular Access Point from list.
            console.log("QML: WifiList: We have selected an AP at Index = " + list_view.currentIndex);
            selected_ap_idx = list_view.currentIndex;
            work_done = true;
            nextOperation = "activate";
        }
    }
}
