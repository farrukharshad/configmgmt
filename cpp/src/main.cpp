// Copyright 2012

// main.cpp
// Application main entry point.

#include <QApplication>
#include <QDeclarativeContext>
#include <QDeclarativeProperty>
#include <QDeclarativeComponent>
#include <QDeclarativeEngine>
#include "qmlapplicationviewer.h"
#include "guiengine.h"
#include "guistrings.h"
#include "dataengine.h"
#include "types.h"
#include <QVariant>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeView view;

    // First of all we will register our custom meta types to be
    // used with D-Bus system.
    CustomMetaTypes::registerNMTypesForDBus();

    DataEngine *dataEngine = DataEngine::instance(view.winId());
    GUIStrings *guiStrings = GUIStrings::instance(&app, dataEngine);
    GUIEngine *guiEngine = GUIEngine::instance(guiStrings, dataEngine);
    view.rootContext()->setContextProperty("guiBackend", guiEngine);
    view.rootContext()->setContextProperty("guiStrings", guiStrings);
    view.rootContext()->setContextProperty("wifiNetworksModel", guiStrings->getWifiNetworksModel());
    view.rootContext()->setContextProperty("soundOutputsModel", guiStrings->getSoundOutputsModel());

    view.setSource(QUrl("qrc:/loader.qml"));
    view.setAttribute(Qt::WA_AcceptTouchEvents);
#ifdef UBUNTU_13_04
    view.showFullScreen();
    //view.show();
#else
    view.show();
#endif
    guiEngine->setViewObject(&view);
    return app.exec();
}
