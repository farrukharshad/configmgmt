
//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: netsettings_screen
    width: 1920;
    height: 1080;
    property string temp: "";

    FontLoader {
        id: lucida
        source: "qrc:/lucida.ttf"
    }
    Rectangle {
        id: netsettingsMenu;
        width: parent.width;
        height: parent.height;
        color: "black";

        // Show Screen Header
        ScreenHeader {
            id: header;
            width:  parent.width;
            text: guiStrings.txtNetworkSettings;
        }

        // Show Function Menu Options Options
        Item {
            id: netConfigMainMenu;
            visible: true
            Column {
                width:      parent.width;
                height:     1080 - header.height;
                y: header.height + 50;
                x: 200;

                MenuOption {
                    id: ipConfigMethodOption;
                    text: guiStrings.txtConfigIp;
                    expandableOption: true;
                    selected: true;
                    inside: true;
                    selection: guiStrings.txtNetConfig;
                    focus: true;
                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
                MenuOption {
                    id: ipAddressOption;
                    text: guiStrings.txtIpAddr;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: if ( guiStrings.txtCurrentIpAddr.length == 0 ) {
                                   guiStrings.txtDisconnected;
                               } else {
                                   guiStrings.txtCurrentIpAddr;
                               }
                    selection_disabled: if ( guiStrings.IsDhcpIp() ) true; else false;
                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
                MenuOption {
                    id: subnetOption;
                    text: guiStrings.txtSubnet;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: guiStrings.txtCurrentSubnet;
                    selection_disabled: if ( guiStrings.IsDhcpIp() ) true; else false;
                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
                MenuOption {
                    id: routerOption;
                    text: guiStrings.txtRoute;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: guiStrings.txtCurrentRoute;
                    selection_disabled: if ( guiStrings.IsDhcpIp() ) true; else false;
                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
                MenuOption {
                    id: dnsConfigMethodOption;
                    text: guiStrings.txtConfigDns;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: guiStrings.txtAutoDns;

                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
                MenuOption {
                    id: dnsIpAddrOption;
                    text: guiStrings.txtDnsIp;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: guiStrings.txtDnsIpAddr;

                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
                MenuOption {
                    id: saveNetSettings;
                    text: guiStrings.txtSave;
                    expandableOption: false;
                    selected: false;
                    inside: false;
                    selection: "";

                    Keys.onPressed: {
                        handelKeyEvent(event.key);
                    }
                }
            }
        }
    }
    BinaryConfigInput {
        id: binaryConfigInput;
        visible: false;
        work_done: false;
        input_focus: false;
    }
    IpInput {
        id: ipInput;
        visible: false;
        input_focus: false;
        functionality: "";
        work_done: false;
    }

    states: [
        State {
            name: "IPAddrInput2NetSetMenu";
            when: ipInput.work_done == true && ipInput.functionality == "ipaddress";
            StateChangeScript {
                name: "BackToNetMenuFromIpInput";
                script: ipAddrInput2NetSetMenuScreen();
            }
        },
        State {
            name: "SubnetInput2NetSetMenu";
            when: ipInput.work_done == true && ipInput.functionality == "subnet";
            StateChangeScript {
                name: "BackToNetMenuFromSubnetInput";
                script: subnetInput2NetSetMenuScreen();
            }
        },
        State {
            name: "RouterInput2NetSetMenu";
            when: ipInput.work_done == true && ipInput.functionality == "routerip";
            StateChangeScript {
                name: "BackToNetMenuFromRouterInput";
                script: routerInput2NetSetMenuScreen();
            }
        },
        State {
            name: "DnsIpInput2NetSetMenu";
            when: ipInput.work_done == true && ipInput.functionality == "dnsip";
            StateChangeScript {
                name: "BackToNetMenuFromDnsIpInput";
                script: dnsIpAddrInput2NetSetMenuScreen();
            }
        },
        State {
            name: "DnsConfigInput2NetSetMenu";
            when: binaryConfigInput.functionality == "dnsconfig" && binaryConfigInput.work_done == true;
            StateChangeScript {
                name: "BackToNetMenuFromDnsConfgInput";
                script: dnsConfigInput2NetSetMenuScreen();
            }
        },
        State {
            name: "IpConfigInput2NetSetMenu";
            when: binaryConfigInput.functionality == "ipconfig" && binaryConfigInput.work_done == true;
            StateChangeScript {
                name: "BackToNetMenuFromIpConfgInput";
                script: ipConfigInput2NetSetMenuScreen();
            }
        }
    ]
    function handelKeyEvent(key) {
        // Up / Down Key
        if ( key == Qt.Key_Down ) {
            gotoNextOption();
        }
        if ( key == Qt.Key_Up ) {
            gotoPreviousOption();
        }

        // Left Key
        if ( key == Qt.Key_Left ) {
            // We are at the Function selection menu
            guiStrings.CancelWiredNetworkSettings();
            guiBackend.ChangeCurrentPage("main");
        }
        // Right Key is pressed
        if ( key == Qt.Key_Right ) {
            if ( ipConfigMethodOption.selected )
                openIpConfigMethodInputScreen();
            else if ( ipAddressOption.selected )
                openIpAddressInputScreen();
            else if ( subnetOption.selected )
                openSubnetInputScreen();
            else if ( routerOption.selected )
                openRouteIpAddressInputScreen();
            else if ( dnsConfigMethodOption.selected )
                openDnsConfigMethodInputScreen();
            else if ( dnsIpAddrOption.selected )
                openDnsIpAddressInputScreen();
        }
        // ENTER Key is pressed
        if ( key == Qt.Key_Return ) {
            if ( saveNetSettings.selected ) {
                // TODO: Save network configurations here.
                console.log("QML : Saving network settings");
                guiStrings.SaveWiredNetworkSettings();
                guiBackend.ChangeCurrentPage("main");
            }
        }
    }
    function gotoNextOption() {
        // Current Selection is English Option
        if ( ipConfigMethodOption.selected ) {
            ipConfigMethodOption.selected = false;
            ipAddressOption.selected = true;
        }
        // Current Selection is Nederlands Option
        else if ( ipAddressOption.selected ) {
            ipAddressOption.selected = false;
            subnetOption.selected = true;
        }
        else if ( subnetOption.selected ) {
            subnetOption.selected = false;
            routerOption.selected = true;
        }
        else if ( routerOption.selected ) {
            routerOption.selected = false;
            dnsConfigMethodOption.selected = true;
        }
        else if ( dnsConfigMethodOption.selected ) {
            dnsConfigMethodOption.selected = false;
            dnsIpAddrOption.selected = true;
        }
        else if ( dnsIpAddrOption.selected ) {
            dnsIpAddrOption.selected = false;
            saveNetSettings.selected = true;
            //ipConfigMethodOption.selected = true;
        }
        else if ( saveNetSettings.selected ) {
            saveNetSettings.selected = false;
            ipConfigMethodOption.selected = true;
        }

        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
    function gotoPreviousOption() {
        // Current Selection is English Option
        if ( ipConfigMethodOption.selected ) {
            ipConfigMethodOption.selected = false;
            saveNetSettings.selected = true;
        }
        // Current Selection is Nederlands Option
        else if ( ipAddressOption.selected ) {
            ipAddressOption.selected = false;
            ipConfigMethodOption.selected = true;
        }
        else if ( subnetOption.selected ) {
            subnetOption.selected = false;
            ipAddressOption.selected = true;
        }
        else if ( routerOption.selected ) {
            routerOption.selected = false;
            subnetOption.selected = true;
        }
        else if ( dnsConfigMethodOption.selected ) {
            dnsConfigMethodOption.selected = false;
            routerOption.selected = true;
        }
        else if ( dnsIpAddrOption.selected ) {
            dnsIpAddrOption.selected = false;
            dnsConfigMethodOption.selected = true;
        }
        else if ( saveNetSettings.selected ) {
            saveNetSettings.selected = false;
            dnsIpAddrOption.selected = true;
        }

        // No Focus - This is an error
        else {
            console.debug("No default focus is defined");
        }
    }
    function openIpConfigMethodInputScreen() {
        binaryConfigInput.visible = true;
        binaryConfigInput.title = guiStrings.txtConfigIp;
        binaryConfigInput.option1caption = guiStrings.txtAutomatic;
        binaryConfigInput.option2caption = guiStrings.txtManual;
        binaryConfigInput.isOption1Expandable = false;
        binaryConfigInput.isOption2Expandable = false;
        binaryConfigInput.option1SelectionText = "";
        binaryConfigInput.option2SelectionText = "";
        binaryConfigInput.initialOption = 1;
        binaryConfigInput.selectedOption = 0;
        binaryConfigInput.work_done = false;
        binaryConfigInput.input_focus = true;
        binaryConfigInput.functionality = "ipconfig";

        netsettingsMenu.focus = false;
        netsettingsMenu.visible = false;
    }
    function openDnsConfigMethodInputScreen() {
        binaryConfigInput.visible = true;
        binaryConfigInput.title = guiStrings.txtConfigDns;
        binaryConfigInput.option1caption = guiStrings.txtAutomatic;
        binaryConfigInput.option2caption = guiStrings.txtManual;
        binaryConfigInput.isOption1Expandable = false;
        binaryConfigInput.isOption2Expandable = false;
        binaryConfigInput.option1SelectionText = "";
        binaryConfigInput.option2SelectionText = "";
        binaryConfigInput.initialOption = 1;
        binaryConfigInput.selectedOption = 0;
        binaryConfigInput.work_done = false;
        binaryConfigInput.input_focus = true;
        binaryConfigInput.functionality = "dnsconfig";

        netsettingsMenu.focus = false;
        netsettingsMenu.visible = false;
    }
    function openDnsIpAddressInputScreen() {
        ipInput.visible = true;
        ipInput.input_focus = true;
        ipInput.work_done = false;
        ipInput.caption = guiStrings.txtDnsIp;
        ipInput.description = "";
        ipInput.functionality = "dnsip";
        netsettingsMenu.focus = false;
        netsettingsMenu.visible = false;
    }

    function openSubnetInputScreen() {
        if ( !guiStrings.IsDhcpIp() ) {
            ipInput.visible = true;
            ipInput.input_focus = true;
            ipInput.work_done = false;
            ipInput.caption = guiStrings.txtSubnet;
            ipInput.description = "";
            ipInput.functionality = "subnet";

            // Set the default IP Address.
            assignIpInputDefaultValues(guiStrings.txtCurrentSubnet);

            netsettingsMenu.focus = false;
            netsettingsMenu.visible = false;
        }
    }

    function openIpAddressInputScreen() {
        if ( !guiStrings.IsDhcpIp() ) {
            ipInput.visible = true;
            ipInput.input_focus = true;
            ipInput.work_done = false;
            ipInput.functionality = "ipaddress";
            ipInput.caption = guiStrings.txtIpAddr;
            ipInput.description = guiStrings.txtIpAddrDesc;

            // Set the default IP Address.
            assignIpInputDefaultValues(guiStrings.txtCurrentIpAddr);

            netsettingsMenu.focus = false;
            netsettingsMenu.visible = false;
        }
    }
    function openRouteIpAddressInputScreen() {
        if ( !guiStrings.IsDhcpIp() ) {
            ipInput.visible = true;
            ipInput.input_focus = true;
            ipInput.work_done = false;
            ipInput.functionality = "routerip";
            ipInput.caption = guiStrings.txtRouterIp;
            ipInput.description = "";

            // Set the default IP Address.
            assignIpInputDefaultValues(guiStrings.txtCurrentRoute);

            netsettingsMenu.focus = false;
            netsettingsMenu.visible = false;
        }
    }
    function dnsIpAddrInput2NetSetMenuScreen() {
        ipInput.visible = false;
        ipInput.focus = false;

        netsettingsMenu.visible = true;
        dnsIpAddrOption.selected = true;
        dnsIpAddrOption.focus = true;
    }
    function ipAddrInput2NetSetMenuScreen() {
        ipInput.visible = false;
        ipInput.focus = false;

        netsettingsMenu.visible = true;
        ipAddressOption.selected = true;
        ipAddressOption.focus = true;
    }
    function subnetInput2NetSetMenuScreen() {
        ipInput.visible = false;
        ipInput.focus = false;

        netsettingsMenu.visible = true;
        subnetOption.selected = true;
        subnetOption.focus = true;
    }
    function routerInput2NetSetMenuScreen() {
        ipInput.visible = false;
        ipInput.focus = false;

        netsettingsMenu.visible = true;
        routerOption.selected = true;
        routerOption.focus = true;
    }
    function dnsConfigInput2NetSetMenuScreen() {
        // Save the user input from binary config option input screen
        if ( binaryConfigInput.selectedOption == 1 ) {
            // User has selected Automatic DNS option
            guiStrings.SetAutoDnsConfig(true);
        } else if ( binaryConfigInput.selectedOption == 2 ) {
            // User has selected Manual DNS option.
            guiStrings.SetAutoDnsConfig(false);
        }

        binaryConfigInput.visible = false;
        binaryConfigInput.input_focus = false;
        netsettingsMenu.visible = true;
        dnsConfigMethodOption.selected = true;
        dnsConfigMethodOption.focus = true;
    }
    function ipConfigInput2NetSetMenuScreen() {
        // Save the user input from binary config option input screen
        if ( binaryConfigInput.selectedOption == 1 ) {
            // User has selected Automatic IP option
            guiStrings.SetAutoIpConfig(true);
        } else if ( binaryConfigInput.selectedOption == 2 ) {
            // User has selected Manual IP option.
            guiStrings.SetAutoIpConfig(false);
        }
        console.log("State Changed - Going back to Net Settings Menu");

        binaryConfigInput.visible = false;
        binaryConfigInput.input_focus = false;
        netsettingsMenu.visible = true;
        ipConfigMethodOption.selected = true;
        ipConfigMethodOption.focus = true;
    }
    function assignIpInputDefaultValues(values) {
        var ipaddress = guiStrings.GetCompleteIpAddrString(values);
        ipInput.ipDigit1Value = guiStrings.ConvertCharToInt(ipaddress, 0);
        ipInput.ipDigit2Value = guiStrings.ConvertCharToInt(ipaddress, 1);
        ipInput.ipDigit3Value = guiStrings.ConvertCharToInt(ipaddress, 2);
        ipInput.ipDigit4Value = guiStrings.ConvertCharToInt(ipaddress, 4);
        ipInput.ipDigit5Value = guiStrings.ConvertCharToInt(ipaddress, 5);
        ipInput.ipDigit6Value = guiStrings.ConvertCharToInt(ipaddress, 6);
        ipInput.ipDigit7Value = guiStrings.ConvertCharToInt(ipaddress, 8);
        ipInput.ipDigit8Value = guiStrings.ConvertCharToInt(ipaddress, 9);
        ipInput.ipDigit9Value = guiStrings.ConvertCharToInt(ipaddress, 10);
        ipInput.ipDigit10Value = guiStrings.ConvertCharToInt(ipaddress, 12);
        ipInput.ipDigit11Value = guiStrings.ConvertCharToInt(ipaddress, 13);
        ipInput.ipDigit12Value = guiStrings.ConvertCharToInt(ipaddress, 14);
    }
    function refreshSelection() {
        if ( guiStrings.IsDhcpIp() ) {
            ipAddressOption.selection_disabled = true;
            subnetOption.selection_disabled = true;
            routerOption.selection_disabled = true;
        } else if ( !guiStrings.IsDhcpIp() ) {
            ipAddressOption.selection_disabled = false;
            subnetOption.selection_disabled = false;
            routerOption.selection_disabled = false;
        }
    }
}
