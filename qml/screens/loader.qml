import QtQuick 1.1

Rectangle {
    width: 1920;
    height: 1080;
    id: loaderPage;

    Loader {
        id: mainLoader;
        focus: true;
        source: guiBackend.currentpage;
    }
}
