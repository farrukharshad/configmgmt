
//import QtQuick 1.1
import QtQuick 1.0

Item {
    id: sound_screen
    width: 1920;
    height: 1080;

    FontLoader {
        id: lucida
        source: "qrc:/lucida.ttf"
    }
    Rectangle {
        width: parent.width;
        height: parent.height;
        color: "black";

        // Show Screen Header
        ScreenHeader {
            id: header;
            width:  parent.width;
            text: guiStrings.txtSound;
        }
        // Wifi Network Scan Screen
        Item {
            id: sound_output_screen;

            Component {
                id: soundOutputListDelegate

                MenuOption {
                    id: soundOutputOption;
                    text: sound_output;
                    expandableOption: false;
                    selection: "";
                    selected: if ( index == so_list_view.currentIndex ) true; else false;
                }
            }
            ListView {
                id: so_list_view
                width:      parent.width;
                height:     1080 - header.height;
                y: header.height;
                boundsBehavior: Flickable.StopAtBounds
                model: soundOutputsModel;
                delegate: soundOutputListDelegate;
                focus: true;
                Keys.onPressed: {
                    handleKeyEvent(event.key);
                }
            }
        }
    }
    function handleKeyEvent(key)
    {
        if ( key == Qt.Key_Up ) {
            if ( so_list_view.currentIndex == 0 )
                so_list_view.currentIndex = (so_list_view.count);
        } else if ( key == Qt.Key_Down ) {
            if ( so_list_view.currentIndex == (so_list_view.count - 1) )
                so_list_view.currentIndex = -1;
        } else if ( key == Qt.Key_Left ) {
            // Go back to previous screen cancelling the operation.
            guiBackend.ChangeCurrentPage("main");
        } else if ( key == Qt.Key_Return ) {
            // Go back to previous selecting any particular Access Point from list.
            guiStrings.SetSelectedSoundOutput(so_list_view.currentIndex);
            guiBackend.ChangeCurrentPage("main");
        }
    }
}
