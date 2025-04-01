// Copyright 2012

// guiengine.cpp
// Implementation of GUIEngine class.

#include "guistrings.h"

GUIStrings* GUIStrings::engineInstance = NULL;

GUIStrings::GUIStrings(QApplication *app_, DataEngine *dataEngine_) :
    app(app_), dataEngine(dataEngine_)
{
    // Load default language
    ChangeSystemLanguage("en");

    // Connect with Data Engine Signals
    QObject::connect(dataEngine, SIGNAL(networkInformationUpdated()), this, SLOT(networkInformationUpdated()));
    QObject::connect(dataEngine, SIGNAL(openApsListPage()), this, SLOT(openAccessPointsPage()));
    QObject::connect(dataEngine, SIGNAL(scanningWirelessAps()), this, SLOT(wirelessScanStarted()));
    QObject::connect(dataEngine, SIGNAL(orientitationChanged()), this, SLOT(orientitationUpdated()));
    QObject::connect(dataEngine, SIGNAL(updateSoundOutput()), this, SLOT(soundOutputUpdated()));
    QObject::connect(dataEngine, SIGNAL(openWifiAuthenticationPage()), this, SLOT(needAuthenticationForWifi()));
    QObject::connect(dataEngine, SIGNAL(wifiActivated()), this, SLOT(wifiActivated()));
}
GUIStrings::~GUIStrings()
{
    if ( engineInstance != NULL ) delete engineInstance;
    engineInstance = NULL;
}

GUIStrings* GUIStrings::instance(QApplication *app, DataEngine *dataEngine_)
{
    if ( !engineInstance )
        engineInstance = new GUIStrings(app, dataEngine_);

    return engineInstance;
}
QString GUIStrings::getTxtFuncDesc()
{
    return tr("If Function as Player is set on, you will need to enter the IP address of ZieChannel\nServer. If Function as Server is set on, this device will be able to play presentations\nthat are locally stored and other Ziechannel Players will be able to connect");
}
QString GUIStrings::getIpAddrDescription()
{
    return tr("The IP Address can be manually or automatically set. If this device is set as\nZiechannel Server, you need to assign other Ziechannel Players to this device. The\nIP Address below will then be the server IP address");
}
QString GUIStrings::getTxtRouterIpDesc()
{
    return tr("Please enter the ip address of the ZieChannel Server. The last three digits can be\nused to assign a port number. Leave it blank if you do not need to configure a port number");
}

void GUIStrings::ChangeSystemLanguage(const QString &lang)
{
    if ( lang == QString("nl") ) {
        currentLanguageStr = "Nederlands";
        nlTranslator.load("configmgmt_nl", ":/translations");
        app->installTranslator(&nlTranslator);
        app->removeTranslator(&enTranslator);
        app->removeTranslator(&deTranslator);
    } else if ( lang == QString("de") ) {
        currentLanguageStr = "Deutsch";
        deTranslator.load("configmgmt_de", ":/translations");
        app->installTranslator(&deTranslator);
        app->removeTranslator(&nlTranslator);
        app->removeTranslator(&enTranslator);
    } else if ( lang == QString("en") ) {
        currentLanguageStr = "English";
        app->installTranslator(&enTranslator);
        app->removeTranslator(&nlTranslator);
        app->removeTranslator(&deTranslator);
    }

    // Send signal to GUI to refresh text strings
    emit languageChanged();
}
void GUIStrings::SetFuncAsPlayer(bool player)
{
    dataEngine->setSystemFunctionalityAsPlayer(player);
    emit languageChanged();
}
void GUIStrings::SetOrientitationLandscape(bool landscape)
{
    dataEngine->setSystemOrientitationAsLandscape(landscape);
    emit languageChanged();
}
void GUIStrings::SetManualIpAddress(QString address, QString functionality)
{
    dataEngine->setManualIpAddress(address, functionality);
    emit languageChanged();
}
void GUIStrings::SetAutoDnsConfig(bool auto_)
{
    dataEngine->setAutoDns(auto_);
    emit languageChanged();
}
void GUIStrings::SetAutoIpConfig(bool auto_)
{
    dataEngine->setDhcpConfiguration(auto_);
    emit languageChanged();
}
void GUIStrings::needAuthenticationForWifi()
{
    emit openWifiAuthenticationPage();
}
void GUIStrings::wifiActivated()
{
    emit languageChanged();
    emit selectedWifiActivated();
}

void GUIStrings::networkInformationUpdated()
{
    qDebug () << "We need to update networking information";
    emit languageChanged();
}
void GUIStrings::orientitationUpdated()
{
    emit languageChanged();
}

void GUIStrings::openAccessPointsPage()
{
    emit apsPageReadyToOpen();
}

void GUIStrings::wirelessScanStarted()
{
    emit startWirelessScanAnimation();
}

void GUIStrings::EnableDisableWifi(bool enable)
{
    dataEngine->enableDisableWifi(enable);
    emit languageChanged();
}
bool GUIStrings::ActivateWifiConnection(int index)
{
    bool status = false;
    if ( (status = dataEngine->activateWirelessConnection(index)) ) {
        emit languageChanged();
    }
    return status;
}
void GUIStrings::SaveWiredNetworkSettings()
{
    dataEngine->saveWiredNetworkSettings();
    // We may not need it because after updating settings
    // we are already emitting networ settings update signal
    // which is effectively doing the same thing.
//    emit languageChanged();
}
void GUIStrings::soundOutputUpdated()
{
    emit languageChanged();
}

/*----------------------------------------
  S L O T S    D E F I N I T I O N S
  *-------------------------------------*/
