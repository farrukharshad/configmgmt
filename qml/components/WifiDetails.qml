
//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: wifidetails_screen
    width: 1920;
    height: 1080;

    property alias ssid: header.text;
    property bool input_focus: false;
    property bool work_done: false;
    property bool enableDisableOptionSelected: false;
    property alias enableDisableCaption: enableDisableOption.text;

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
            y: header.height + 50;
            x: 200;

            MenuOption {
                id: ipAddressOption;
                text: guiStrings.txtIpAddr;
                expandableOption: true;
                selected: false;
                inside: true;
                selection: guiStrings.txtWifiIpAddr;
                selection_disabled: true;
            }
            MenuOption {
                id: subnetOption;
                text: guiStrings.txtSubnet;
                expandableOption: true;
                selected: false;
                inside: true;
                selection: guiStrings.txtWifiNetmask;
                selection_disabled: true;
            }
            MenuOption {
                id: routeIpOption;
                text: guiStrings.txtRoute;
                expandableOption: true;
                selected: false;
                inside: true;
                selection: guiStrings.txtWifiRoute;
                selection_disabled: true;
            }
            MenuOption {
                id: dnsIpOption;
                text: guiStrings.txtDnsIp;
                expandableOption: true;
                selected: false;
                inside: true;
                selection: guiStrings.txtWifiDnsIp;
                selection_disabled: true;
            }
            MenuOption {
                id: signalStrengthOption;
                text: guiStrings.txtSignalStrength;
                expandableOption: true;
                selected: false;
                inside: true;
                selection: guiStrings.txtActApSigStrength;
                selection_disabled: true;
            }
            MenuOption {
                id: apSecurityOption;
                text: guiStrings.txtSecurity;
                expandableOption: true;
                selected: false;
                inside: true;
                selection: guiStrings.txtActApSecurity;
                selection_disabled: true;
            }
            MenuOption {
                id: enableDisableOption;
                expandableOption: true;
                selected: true;
                inside: true;
                focus: if ( input_focus ) true; else false;
                selection: "";
                selection_disabled: true;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
            MenuOption {
                id: passwordInputOption;
                text: guiStrings.txtPassword;
                expandableOption: true;
                selected: false;
                inside: true;
                selection: guiStrings.txtPasswordEncoded;
                selection_disabled: true;
                Keys.onPressed: {
                    handelKeyEvent(event.key);
                }
            }
        }
    }
    function handelKeyEvent(key) {
        if ( key == Qt.Key_Up || key == Qt.Key_Down ) {
            if ( enableDisableOption.selected ) {
                enableDisableOption.selected = false;
                passwordInputOption.selected = true;
            } else if ( passwordInputOption.selected ) {
                passwordInputOption.selected = false;
                enableDisableOption.selected = true;
            }
        }

        // Left Key
        if ( key == Qt.Key_Left ) {
            work_done = true;
            enableDisableOptionSelected = false;
        }
        // ENTER Key is pressed
        if ( key == Qt.Key_Return ) {
            if ( enableDisableOption.selected ) {
                enableDisableOptionSelected = true;
                work_done = true;
            }
        }
    }
}
