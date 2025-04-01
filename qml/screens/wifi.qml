import QtQuick 1.1
//import QtQuick 1.0
//import QtQuick 2.0

Item {
    id: wifilist_screen
    width: 1920;
    height: 1080;

    property bool input_focus: false;
    property bool work_done: false;
    property int  selected_ap_idx: -1;
    property string currentScreen: "onoff";
    property string currentAuthType: "none";

    property string wpapassword_input: "";
    property string leapusername_input: "";
    property string leappassword_input: "";
    property string wepkey_input: "";
    property string wepindex_input: "";
    property string authentication_input: "";
    property bool wepAuthenticationType: false;         // 0 : Open System
                                                        // 1 : Shared Key

    Connections {
        target: guiStrings;
        onApsPageReadyToOpen: {
            hideEnableDisableScreen();
            showApsListScreen();
        }
    }
    Connections {
        target: guiStrings;
        onStartWirelessScanAnimation: openWirelessScanningAnimation();
    }
    Connections {
        target: guiStrings;
        onOpenWifiAuthenticationPage: {
            hideApsListScreen();
            showWifiAuthenticationPage();
        }
    }
    Connections {
        target: guiStrings;
        onSelectedWifiActivated: {
            console.log("QML : Selected Wifi is Activated");
            wifiIsDisabled(false);
        }
    }

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
        // ============== Wifi Authentication Screen
        Item {
            id: wifiAuthScreen;
            visible: false;
            focus: false;
            anchors.fill: parent;

            // Show Function Menu Options Options
            MenuOption {
                id: authTypeOption;
                y: header.height + 50;
                x: 200;
                text: guiStrings.txtSecurity;
                expandableOption: true;
                selected: true;
                inside: true;
                selection: guiStrings.txtNone;
                selection_disabled: true;
                Keys.onPressed: handleKeyEvent(event);
            }
            // For authentication type WEP 40/128-bit Key & WEP 128-bit passphrase
            Column {
                id: authTypeWepKey;
                y: authTypeOption.y + authTypeOption.height;
                x: authTypeOption.x;
                visible: false;
                MenuOption {
                    id: keyOption;
                    text: guiStrings.txtKey;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: ""
                    selection_disabled: true;
                    Keys.onPressed: handleKeyEvent(event);
                }
                MenuOption {
                    id: wepIndexOption;
                    text: guiStrings.txtWepIndex;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: ""
                    selection_disabled: true;
                    Keys.onPressed: handleKeyEvent(event);
                }
                MenuOption {
                    id: authenticationOption;
                    text: guiStrings.txtAuthentication;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: guiStrings.txtOpenSystem;
                    selection_disabled: true;
                    Keys.onPressed: handleKeyEvent(event);
                }
            }
            // For authentication type LEAP
            Column {
                id: leap;
                visible: false;
                y: authTypeOption.y + authTypeOption.height;
                x: authTypeOption.x;

                MenuOption {
                    id: leapUsernameOption;
                    text: guiStrings.txtUsername;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: ""
                    selection_disabled: true;
                    Keys.onPressed: handleKeyEvent(event);
                }
                MenuOption {
                    id: leapPasswordOption;
                    text: guiStrings.txtPassword;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: ""
                    selection_disabled: true;
                    Keys.onPressed: handleKeyEvent(event);
                }
            }
            // For authentication type WPA & WPA Personal
            Column {
                id: wpaPersonal;
                visible: false;
                y: authTypeOption.y + authTypeOption.height;
                x: authTypeOption.x;
                MenuOption {
                    id: wpaPasswordOption;
                    text: guiStrings.txtPassword;
                    expandableOption: true;
                    selected: false;
                    inside: true;
                    selection: ""
                    selection_disabled: true;
                    Keys.onPressed: handleKeyEvent(event);
                }
            }

            MenuOption {
                id: saveAuthOptions;
                y: authTypeOption.y + authTypeOption.height;
                x: authTypeOption.x;
                text: guiStrings.txtSave;
                expandableOption: false;
                selected: false;
                Keys.onPressed: handleKeyEvent(event);
            }
            Oskb {
                id: textInput;
                visible: false;
                onInputComplete: returnFromOskbInput(output);
            }
        }
        // ============== Enable / Disable Screen
        Item {
            id: enableDisableScreen;
            visible: true;
            focus: true;
            MenuOption {
                id: enableOption;
                y: header.height;
                text: guiStrings.txtOn;
                expandableOption: false;
                selection: "";
                selected: true;
            }
            MenuOption {
                id: disableOption;
                anchors.top: enableOption.bottom;
                text: guiStrings.txtOff;
                expandableOption: false;
                selection: "";
                selected: false;
            }
            Keys.onPressed: handleKeyEvent(event);
        }
        // ========== Wifi Access Points List Screen
        Component {
            id: listDelegate
            MenuOption {
                id: wifiOption;
                text: ssid;
                expandableOption: false;
                selection: "";
                selected: if ( index == list_view.currentIndex ) true; else false;
                Keys.onPressed: {
                    handleKeyEvent(event);
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
            visible: false;
        }
    }
    states: [
        State {
            name: "WepBitKeyOpenAuthSelected";
            when: wepAuthenticationType == false && currentAuthType == "wepkey" && wifiAuthScreen.visible == true;
            StateChangeScript {
                name: "OpenAuthTypeWepKeyOpen";
                script: openAuthTypeWepKeyPass("wepkey");
            }
            PropertyChanges {
                target: saveAuthOptions;
                y: authTypeWepKey.y + authTypeWepKey.height;
            }
        },
        State {
            name: "WepBitKeySharedAuthSelected";
            when: wepAuthenticationType == true && currentAuthType == "wepkey" && wifiAuthScreen.visible == true;
            StateChangeScript {
                name: "OpenAuthTypeWepKeyShared";
                script: openAuthTypeWepKeyPass("wepkey");
            }
            PropertyChanges {
                target: saveAuthOptions;
                y: authTypeWepKey.y + authTypeWepKey.height;
            }
        },
        State {
            name: "WepBitPassOpenAuthSelected";
            when: wepAuthenticationType == false && currentAuthType == "weppassphrase" && wifiAuthScreen.visible == true;
            StateChangeScript {
                name: "OpenAuthTypeWepPassOpen";
                script: openAuthTypeWepKeyPass("weppassphrase");
            }
            PropertyChanges {
                target: saveAuthOptions;
                y: authTypeWepKey.y + authTypeWepKey.height;
            }
        },
        State {
            name: "WepBitPassSharedAuthSelected";
            when: wepAuthenticationType == true && currentAuthType == "weppassphrase" && wifiAuthScreen.visible == true;
            StateChangeScript {
                name: "OpenAuthTypeWepPassShared";
                script: openAuthTypeWepKeyPass("weppassphrase");
            }
            PropertyChanges {
                target: saveAuthOptions;
                y: authTypeWepKey.y + authTypeWepKey.height;
            }
        },
        State {
            name: "NoneAuthSelected";
            when: currentAuthType == "none" && wifiAuthScreen.visible == true;
            StateChangeScript {
                name: "OpenAuthTypeNone";
                script: openAuthTypeNone();
            }
            PropertyChanges {
                target: saveAuthOptions;
                y: authTypeOption.y + authTypeOption.height;
            }
        },
        State {
            name: "LeapAuthSelected";
            when: currentAuthType == "leap" && wifiAuthScreen.visible == true
            StateChangeScript {
                name: "OpenAuthTypeLeap";
                script: openAuthTypeLeap();
            }
            PropertyChanges {
                target: saveAuthOptions;
                y: leap.y + leap.height;
            }
        },
        State {
            name: "WpaPersonalAuthSelected";
            when: currentAuthType == "wpapersonal" && wifiAuthScreen.visible == true
            StateChangeScript {
                name: "OpenAuthTypeWpaPersonal";
                script: openAuthTypeWpaPersonal();
            }
            PropertyChanges {
                target: saveAuthOptions;
                y: wpaPersonal.y + wpaPersonal.height;
            }
        }
    ]
    function openWirelessScanningAnimation()
    {
        console.log("TODO: QML : Start some animation for scanning wireless access points");
    }
    function wifiIsDisabled(disable) {
        if ( disable ) {
            guiStrings.EnableDisableWifi(!disable);
        }
        guiBackend.ChangeCurrentPage("main");
    }
    function handleKeyEvent(event)
    {
        // --------------------------------------
        // We are showing Wifi Enable / Disable screen
        // --------------------------------------
        if ( enableDisableScreen.visible ) {
            if ( event.key == Qt.Key_Up || event.key == Qt.Key_Down ) {
                if ( enableOption.selected ) {
                    enableOption.selected = false;
                    disableOption.selected = true;
                } else if ( disableOption.selected ) {
                    disableOption.selected = false;
                    enableOption.selected = true;
                }
            } else if ( event.key == Qt.Key_Return ) {
                if ( enableOption.selected ) {
                    guiStrings.EnableDisableWifi(true);
                } else if ( disableOption.selected ) {
                    wifiIsDisabled(true);
                }
            } else if ( event.key == Qt.Key_Left ) {
                wifiIsDisabled(false);
            }
        }
        // --------------------------------------
        // We are showing Wifi Access Points List screen
        // --------------------------------------
        else if ( list_view.visible ) {
            if ( event.key == Qt.Key_Up ) {
                if ( list_view.currentIndex == 0 )
                    list_view.currentIndex = (list_view.count);
            } else if ( event.key == Qt.Key_Down ) {
                if ( list_view.currentIndex == (list_view.count - 1))
                    list_view.currentIndex = -1;
            } else if ( event.key == Qt.Key_Left ) {
                event.accepted = true;
                hideApsListScreen();
                showEnableDisableScreen();
            } else if ( event.key == Qt.Key_Return ) {
                guiStrings.ActivateWifiConnection(list_view.currentIndex);
                event.accepted = true;
            }
        }
        // --------------------------------------
        // We are showing wifi authentication screen
        // --------------------------------------
        else if ( wifiAuthScreen.visible ) {
            if ( event.key == Qt.Key_Return ) {
                if ( saveAuthOptions.selected )
                    saveWifiAuthOptions();
            } else if ( event.key == Qt.Key_Left ) {
                hideWifiAuthenticationPage();
                showApsListScreen();
            } else if ( event.key == Qt.Key_Right ) {
                if ( authTypeOption.selected ) {
                    if ( currentAuthType == "none" ) {
                        currentAuthType = "wepkey";
                    } else if ( currentAuthType == "wepkey" ) {
                        currentAuthType = "weppassphrase";
                    } else if ( currentAuthType == "weppassphrase" ) {
                        currentAuthType = "leap";
                    } else if ( currentAuthType == "leap" ) {
                        currentAuthType = "wpapersonal";
                    } else if ( currentAuthType == "wpapersonal" ) {
                        currentAuthType = "none";
                    }
                } else if ( wpaPasswordOption.selected ) {
                    openTextInputPage(guiStrings.txtWifiPassword, "password");
                } else if ( leapUsernameOption.selected ) {
                    openTextInputPage(guiStrings.txtUsername, "normal");
                } else if ( leapPasswordOption.selected ) {
                    openTextInputPage(guiStrings.txtPassword, "password");
                } else if ( keyOption.selected ) {
                    openTextInputPage(guiStrings.txtKey, "normal" );
                } else if ( wepIndexOption.selected ) {
                    openTextInputPage(guiStrings.txtWepBitKey, "normal" );
                } else if ( authenticationOption.selected ) {
                    wepAuthenticationType = !(wepAuthenticationType);
                }
            } else if ( event.key == Qt.Key_Down ) {
                if ( currentAuthType == "none" ) {
                    if ( authTypeOption.selected ) {
                        authTypeOption.selected = false;
                        saveAuthOptions.selected = true;
                    } else if ( saveAuthOptions.selected ) {
                        saveAuthOptions.selected = false;
                        authTypeOption.selected = true;
                    }
                } else if ( currentAuthType == "wepkey" || currentAuthType == "weppassphrase" ) {
                    if ( authTypeOption.selected ) {
                        authTypeOption.selected = false;
                        keyOption.selected = true;
                    } else if ( keyOption.selected ) {
                        wepIndexOption.selected = true;
                        keyOption.selected = false;
                    } else if ( wepIndexOption.selected ) {
                        authenticationOption.selected = true;
                        authenticationOption.focus = true;
                        wepIndexOption.selected = false;
                    } else if ( authenticationOption.selected ) {
                        authTypeOption.focus = false;
                        authenticationOption.selected = false;
                        saveAuthOptions.selected = true;
                    } else if ( saveAuthOptions.selected ) {
                        saveAuthOptions.selected = false;
                        authTypeOption.selected = true;
                    }
                } else if ( currentAuthType == "leap" ) {
                    if ( authTypeOption.selected ) {
                        leapUsernameOption.selected = true;
                        authTypeOption.selected = false;
                    } else if ( leapUsernameOption.selected ) {
                        leapPasswordOption.selected = true;
                        leapUsernameOption.selected = false;
                    } else if ( leapPasswordOption.selected ) {
                        saveAuthOptions.selected = true;
                        leapPasswordOption.selected = false;
                    } else if ( saveAuthOptions.selected ) {
                        saveAuthOptions.selected = false;
                        authTypeOption.selected = true;
                    }
                } else if ( currentAuthType == "wpapersonal" ) {
                    if ( authTypeOption.selected ) {
                        wpaPasswordOption.selected = true;
                        authTypeOption.selected = false;
                    }  else if ( wpaPasswordOption.selected ) {
                        saveAuthOptions.selected = true;
                        wpaPasswordOption.selected = false;
                    } else if ( saveAuthOptions.selected ) {
                        saveAuthOptions.selected = false;
                        authTypeOption.selected = true;
                    }
                }
            } else if ( event.key == Qt.Key_Up ) {
                if ( currentAuthType == "none" ) {
                    if ( authTypeOption.selected ) {
                        authTypeOption.selected = false;
                        saveAuthOptions.selected = true;
                    } else if ( saveAuthOptions.selected ) {
                        saveAuthOptions.selected = false;
                        authTypeOption.selected = true;
                    }
                } else if ( currentAuthType == "wepkey" || currentAuthType == "weppassphrase" ) {
                    if ( authTypeOption.selected ) {
                        authTypeOption.selected = false;
                        saveAuthOptions.selected = true;
                    } else if ( saveAuthOptions.selected ) {
                        saveAuthOptions.selected = false;
                        authenticationOption.selected = true;
                    } else if ( keyOption.selected ) {
                        authTypeOption.selected = true;
                        keyOption.selected = false;
                    } else if ( wepIndexOption.selected ) {
                        keyOption.selected = true;
                        wepIndexOption.selected = false;
                    } else if ( authenticationOption.selected ) {
                        wepIndexOption.selected = true;
                        authenticationOption.selected = false;
                    }
                } else if ( currentAuthType == "leap" ) {
                    if ( authTypeOption.selected ) {
                        saveAuthOptions.selected = true;
                        authTypeOption.selected = false;
                    } else if ( saveAuthOptions.selected ) {
                        saveAuthOptions.selected = false;
                        leapPasswordOption.selected = true;
                    } else if ( leapUsernameOption.selected ) {
                        authTypeOption.selected = true;
                        leapUsernameOption.selected = false;
                    } else if ( leapPasswordOption.selected ) {
                        leapUsernameOption.selected = true;
                        leapPasswordOption.selected = false;
                    }
                } else if ( currentAuthType == "wpapersonal" ) {
                    if ( authTypeOption.selected ) {
                        saveAuthOptions.selected = true;
                        authTypeOption.selected = false;
                    }  else if ( saveAuthOptions.selected ) {
                        saveAuthOptions.selected = false;
                        wpaPasswordOption.selected = true;
                    } else if ( wpaPasswordOption.selected ) {
                        authTypeOption.selected = true;
                        wpaPasswordOption.selected = false;
                    }
                }
            }
        }
    }
    function showEnableDisableScreen() {
        enableDisableScreen.visible = true;
        enableDisableScreen.focus = true;
        enableOption.selected = true;
        disableOption.selected = false;
    }
    function hideEnableDisableScreen() {
        enableDisableScreen.visible = false;
        enableDisableScreen.focus = false;
    }
    function showApsListScreen() {
        list_view.focus = true;
        list_view.visible = true;
        list_view.currentIndex = 0;
    }
    function hideApsListScreen() {
        list_view.focus = false;
        list_view.visible = false;
    }
    function showWifiAuthenticationPage() {
        wifiAuthScreen.visible = true;
        authTypeOption.focus = true;
        authTypeOption.selected = true;
        keyOption.selected = false;
        wepIndexOption.selected = false;
        authenticationOption.selected = false;
        leapUsernameOption.selected = false;
        leapPasswordOption.selected = false;
        wpaPasswordOption.selected = false;
        saveAuthOptions.selected = false;
        currentAuthType = "none";
    }
    function hideWifiAuthenticationPage() {
        wifiAuthScreen.focus = false;
        wifiAuthScreen.visible = false;
    }
    function openAuthTypeNone() {
        authTypeOption.selection = guiStrings.txtNone;
        wpaPersonal.visible = false;
        leap.visible = false;
        authTypeWepKey.visible = false;
    }
    function openAuthTypeWepKeyPass(type) {
        if ( type == "wepkey" )
            authTypeOption.selection = guiStrings.txtWepBitKey;
        else
            authTypeOption.selection = guiStrings.txtWepBitPassphrase;

        if ( wepAuthenticationType ) {
            authenticationOption.selection = guiStrings.txtSharedKey;
        } else {
            authenticationOption.selection = guiStrings.txtOpenSystem;
        }
        authTypeWepKey.visible = true;
        wpaPersonal.visible = false;
        leap.visible = false;
    }
    function openAuthTypeLeap() {
        authTypeOption.selection = guiStrings.txtLeap;
        leap.visible = true;
        authTypeWepKey.visible = false;
        wpaPersonal.visible = false;
    }
    function openAuthTypeWpaPersonal() {
        authTypeOption.selection = guiStrings.txtWpaPersonal;
        wpaPersonal.visible = true;
        leap.visible = false;
        authTypeWepKey = false;
    }

    function openTextInputPage(caption, type) {
        // Hide everything on current page which is Wifi Authentication Page
        authTypeOption.visible = false;
        authTypeWepKey.visible = false;
        leap.visible = false;
        wpaPersonal.visible = false;
        header.visible = false;
        saveAuthOptions.visible = false;

        // Show text input page.
        showOnScreenKeyBoard(caption, type);
    }
    function showOnScreenKeyBoard(caption, type) {
        // Show text input page.
        textInput.visible = true;
        textInput.title = caption;
        textInput.input_type = type;
        textInput.input_focus = true;
        textInput.focus = true;
        textInput.input = "";
    }
    function hideOnScreenKeyBoard() {
        // Hide On Screen Keyboard Stuff
        textInput.visible = false;
        textInput.title = "";
        textInput.input_type = "normal";
        textInput.input_focus = false;
        textInput.focus = false;

        // Show Authentication Page Stuff
        header.visible = true;
        authTypeOption.visible = true;
        authTypeOption.focus = true;
        saveAuthOptions.visible = true;
    }
    function showAuthScreenFromPassInput(output) {        
        if ( currentAuthType == "wpapersonal" ) {
            wpapassword_input = output;
            openAuthTypeWpaPersonal();
        } else if ( currentAuthType == "leap" ) {
            if ( leapUsernameOption.selected ) {
                leapusername_input = output;
            } else if ( leapPasswordOption.selected ) {
                leappassword_input = output;
            }
            openAuthTypeLeap();
        } else if ( currentAuthType == "wepkey" ) {
            if ( keyOption.selected ) {
                wepkey_input = output;
            } else if ( wepIndexOption.selected ) {
                wepindex_input = output;
            }
            openAuthTypeWepKeyPass("wepkey");
        } else if ( currentAuthType == "weppass" ) {
            if ( keyOption.selected ) {
                wepkey_input = output;
            } else if ( wepIndexOption.selected ) {
                wepindex_input = output;
            }
            openAuthTypeWepKeyPass("weppass");
        }
    }
    function returnFromOskbInput(output) {
        hideOnScreenKeyBoard();
        showAuthScreenFromPassInput(output);
    }
    function saveWifiAuthOptions()
    {
        if ( currentAuthType == "none" ) {
            guiStrings.SaveWifiAuthTypeNone();
        } else if ( currentAuthType == "wpapersonal" ) {
            guiStrings.SaveWifiAuthTypeWpaPersonal(wpapassword_input);
        } else if ( currentAuthType == "leap" ) {
            guiStrings.SaveWifiAuthTypeLeap(leapusername_input, leappassword_input);
        } else if ( currentAuthType == "wepkey" ) {
            // wepAuthenticationType false means "Open System" & true means "Shared Key";
            guiStrings.SaveWifiAuthTypeWepKey(wepkey_input, wepindex_input, wepAuthenticationType);
        } else if ( currentAuthType == "weppass" ) {
            guiStrings.SaveWifiAuthTypeWepPass(wepkey_input, wepindex_input, wepAuthenticationType);
        }
    }
}
