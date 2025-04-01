// Copyright 2012

// dataengine.h
// Declares class which is responsible for all application data
// handling & processing. This is implemented using Singleton pattern.
// This does not directly communicate with GUI / QML rather, whenever
// it needs some data or value to be updated on GUI it send signal
// "dataChanged" to GUIEngine class

#ifndef DATAENGINE_H
#define DATAENGINE_H

#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusMessage>
#include <QObject>
#include <QtNetwork/QHostAddress>
#include <QDebug>
#include "wifinetworks.h"
#include "types.h"
#include "soundengine.h"

#define REMOVE_WIFI_FROM_HERE

/* This is singlelton class */
class DataEngine : public QObject
{
    Q_OBJECT
public:
    static DataEngine *engineInstance;

    /* Singleton class initializer method */
    static DataEngine* instance(const WId wnd);
    static void destroyInstance();
    ~DataEngine();

// Wireless Networking Module
    WifiNetworks* getWifiNetworksList() const { return wifiNetworks; }
    QString getCurrentWirelessStatus() const { return wifiNetworks->getCurrentWirelessStatus(); }
    void scanWifiNetworks() { wifiNetworks->scanWirelessNetworks(); }
    void enableDisableWifi(bool enable);
    bool activateWirelessConnection(int apidx) { return wifiNetworks->activateWirelessConnection(apidx); }
    void saveWifiAuthTypeNone() { wifiNetworks->saveWifiAuthOptionsTypeNone(); }
    void saveWifiAuthTypeWpaPersonal(QString password) { wifiNetworks->saveWifiAuthOptionsTypeWpaPersonal(password); }
    void saveWifiAuthTypeLeap(QString username, QString password) { wifiNetworks->saveWifiAuthOptionsTypeLeap(username, password); }
    void saveWifiAuthTypeWepKey(QString key, int index, bool authTypeSharedKey) { wifiNetworks->saveWifiAuthTypeWepKey(key, index, authTypeSharedKey); }
    void saveWifiAuthTypeWepPass(QString key, int index, bool authTypeSharedKey) { wifiNetworks->saveWifiAuthTypeWepPass(key, index, authTypeSharedKey); }

// Wired Networking Module
    QString getCurrentNetworkingStatus() const { return eth.sessionSettings.ip_.toString(); }
    QString getCurrentIpAddress() const { return eth.sessionSettings.ip_.toString(); }
    QString getCurrentSubnet() const { return eth.sessionSettings.mask_.toString(); }
    QString getCurrentRoute() const { return eth.sessionSettings.route_.toString(); }
    QString getCurrentDnsIp() const { return eth.sessionSettings.dns_.toString(); }
    QString getCompleteIpAddString(QString string_);
    void saveWiredNetworkSettings();
    bool isDhcpIp() const { return eth.sessionSettings.dhcp_; }
    bool isAutoDns() const { return eth.sessionSettings.auto_dns_; }
    void setDhcpConfiguration(bool dhcp_);
    void setAutoDns(bool auto_);
    void setManualIpAddress(QString address, QString functionality);
    void cancelSettingsSession();

// Screen Orientitation Module
    bool getSystemOrientitationAsLanscape();
    void setSystemOrientitationAsLandscape(bool landscape);

// Sound Module
    SoundOutputModel *getSoundOutputModel() const { return soundEngine->getSoundOutputsModel(); }
    QString getCurrentSystemSoundOutput();
    void setCurrentSystemSoundOutput(int idx);

// Misc Stuff
    bool getSystemFunctionalityAsPlayer() const { return playerFunctionality; }

    // FIXME: Following set functions will be filled with their respective actual
    // functionality.

    // If it is not player, it is server.
    void setSystemFunctionalityAsPlayer(bool player) { playerFunctionality = player; }

    void performPowerOperation(QString op);
signals:
    void networkInformationUpdated();
    void scanningWirelessAps();
    void openApsListPage();
    void openWifiAuthenticationPage();
    void orientitationChanged();
    void updateSoundOutput();
    void wifiActivated();
public slots:
    void wifiSettingsChanged();
    void wirelessScanStarted();
    void accessPointsListAvailable();
    void soundOutputChanged();
    void needAuthenticationForWifi();
    void selectedWifiActivated();
private slots:
#if 0
    void dumpMessage(const QDBusMessage &message);
#endif
private: // Networking Stuff
    void initializeWirelessNetworkingModule();
    void initializeWiredNetworkingModule();
    void extractNetworkPropertiesFromString(const QString &property, QHostAddress &ip, QHostAddress &mask, QHostAddress &router);
    void extractNetworkPropertiesFromString(const QString &property, QHostAddress &ip);
    void saveWiredNetworkSettingsToDevice();
    quint32 convertSubnetToMask(const quint32 subnet);
    QString getConnectionSettings(const QByteArray& devMac, NMConnectionSettings &connectionSettings);
    QByteArray getMacAddressOfWiredDev(const QString &devPath);
    // Sound Stuff
    void initializeSoundModule();
private:
    explicit DataEngine() {}
    explicit DataEngine(const WId wnd);
    DataEngine(const DataEngine&);
    DataEngine& operator= (const DataEngine&);
    bool playerFunctionality;
    bool hdmiSound;
    WifiNetworks *wifiNetworks;
    WiredNetworkDevice eth;
    WId appWnd;
    SoundEngine *soundEngine;
};

#endif // DATAENGINE_H
