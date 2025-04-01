// Copyright 2012

// guiengine.cpp
// Implementation of GUIEngine class.

#include <QDeclarativeContext>
#include <QDeclarativeProperty>
#include <QtDebug>
#include <QTime>

#include "guiengine.h"

GUIEngine* GUIEngine::engineInstance = NULL;

GUIEngine::GUIEngine(GUIStrings *stringsEngine_, DataEngine *dataEngine_) :
    dataEngine(dataEngine_),
    stringsEngine(stringsEngine_),
    currentPage("qrc:/main.qml")
{
}
GUIEngine::~GUIEngine()
{
    delete dataEngine;
    dataEngine = NULL;

    if ( engineInstance != NULL ) delete engineInstance;
    engineInstance = NULL;
}

GUIEngine* GUIEngine::instance(GUIStrings *stringsEngine_, DataEngine *dataEngine_)
{
    if ( !engineInstance )
        engineInstance = new GUIEngine(stringsEngine_, dataEngine_);

    return engineInstance;
}

void GUIEngine::ExitApplication(int status)
{
    // FIXME: Do a proper exit
    exit(status);
}
void GUIEngine::ChangeCurrentPage(QString page)
{
    if ( page == "network" )
        currentPage = "qrc:/netsettings.qml";
    else if ( page == "main" )
        currentPage = "qrc:/main.qml";
    else if ( page == "language" )
        currentPage = "qrc:/language.qml";
    else if ( page == "power" )
        currentPage = "qrc:/power.qml";
    else if ( page == "function" )
        currentPage = "qrc:/function.qml";
    else if ( page == "orientitation" )
        currentPage = "qrc:/orientitation.qml";
    else if ( page == "sound" )
        currentPage = "qrc:/sound.qml";
    else if ( page == "ipconfiginput" )
        currentPage = "qrc:/ipconfiginput.qml";
    else if ( page == "wireless" )
        currentPage = "qrc:/wifi.qml";

    // Tell GUI to load new page.
    emit changeCurrentPage();
}
