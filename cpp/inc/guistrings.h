// Copyright 2012

// guiengine.h
// Declares class which is responsible for all the GUI frontend handling
// & update. This implements Singleton pattern.

#ifndef GUISTRINGS_H
#define GUISTRINGS_H

#include <QString>
#include <QObject>
#include <QApplication>
#include <QTranslator>
#include "dataengine.h"

class GUIStrings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString txtMainMenu          READ getTxtMainMenu                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtLanguage          READ getTxtLanguage                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtNetworkSettings   READ getTxtNetworkSettings          NOTIFY languageChanged)
    Q_PROPERTY(QString txtWirelessNetwork   READ getTxtWirelessNetwork          NOTIFY languageChanged)
    Q_PROPERTY(QString txtFunction          READ getTxtFunction                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtOrientitation     READ getTxtOrientitation            NOTIFY languageChanged)
    Q_PROPERTY(QString txtSound             READ getTxtSound                    NOTIFY languageChanged)
    Q_PROPERTY(QString txtPower             READ getTxtPower                    NOTIFY languageChanged)
    Q_PROPERTY(QString txtPlay              READ getTxtPlay                     NOTIFY languageChanged)
    Q_PROPERTY(QString txtCurrentLangStr    READ getCurrentLangStr              NOTIFY languageChanged)
    Q_PROPERTY(QString txtNetPropertiesStr  READ getCurrentNetPropertiesStr     NOTIFY languageChanged)
    Q_PROPERTY(QString txtWirelessStr       READ getCurrentWirelessStr          NOTIFY languageChanged)
    Q_PROPERTY(QString txtFunctionStr       READ getCurrentFunctionStr          NOTIFY languageChanged)
    Q_PROPERTY(QString txtOrientitationStr  READ getCurrentOrientitationStr     NOTIFY languageChanged)
    Q_PROPERTY(QString txtSoundStr          READ getCurrentSoundStr             NOTIFY languageChanged)
    Q_PROPERTY(QString txtFunctionAsPlayer  READ getTxtFuncAsPlayer             NOTIFY languageChanged)
    Q_PROPERTY(QString txtFunctionAsSrvr    READ getTxtFuncAsSrvr               NOTIFY languageChanged)
    Q_PROPERTY(QString txtOn                READ getTxtOn                       NOTIFY languageChanged)
    Q_PROPERTY(QString txtOff               READ getTxtOff                      NOTIFY languageChanged)
    Q_PROPERTY(QString txtFuncDescription   READ getTxtFuncDesc                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtLandscape         READ getTxtLandscape                NOTIFY languageChanged)
    Q_PROPERTY(QString txtPortrait          READ getTxtPortrait                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtPlayer            READ getTxtPlayer                   NOTIFY languageChanged)
    Q_PROPERTY(QString txtServer            READ getTxtServer                   NOTIFY languageChanged)
    Q_PROPERTY(QString txtHDMI              READ getTxtHDMI                     NOTIFY languageChanged)
    Q_PROPERTY(QString txtHeadphone         READ getTxtHeadphone                NOTIFY languageChanged)
    Q_PROPERTY(QString txtReboot            READ getTxtReboot                   NOTIFY languageChanged)
    Q_PROPERTY(QString txtShutdown          READ getTxtShutdown                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtConfigIp          READ getTxtConfigIp                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtIpAddr            READ getTxtIpAddr                   NOTIFY languageChanged)
    Q_PROPERTY(QString txtSubnet            READ getTxtSubnet                   NOTIFY languageChanged)
    Q_PROPERTY(QString txtRoute             READ getTxtRoute                    NOTIFY languageChanged)
    Q_PROPERTY(QString txtConfigDns         READ getTxtConfigDns                NOTIFY languageChanged)
    Q_PROPERTY(QString txtDnsIp             READ getTxtDnsIp                    NOTIFY languageChanged)
    Q_PROPERTY(QString txtAutomatic         READ getTxtAutomatic                NOTIFY languageChanged)
    Q_PROPERTY(QString txtManual            READ getTxtManual                   NOTIFY languageChanged)
    Q_PROPERTY(QString txtNetConfig         READ getNetConfig                   NOTIFY languageChanged)
    Q_PROPERTY(QString txtCurrentIpAddr     READ getCurrentIpAddr               NOTIFY languageChanged)
    Q_PROPERTY(QString txtCurrentSubnet     READ getCurrentSubnet               NOTIFY languageChanged)
    Q_PROPERTY(QString txtCurrentRoute      READ getCurrentRoute                NOTIFY languageChanged)
    Q_PROPERTY(QString txtAutoDns           READ getCurrentDnsConfig            NOTIFY languageChanged)
    Q_PROPERTY(QString txtDnsIpAddr         READ getDnsIpAddress                NOTIFY languageChanged)
    Q_PROPERTY(QString txtIpAddrDesc        READ getIpAddrDescription           NOTIFY languageChanged)
    Q_PROPERTY(QString txtDone              READ getTxtDone                     NOTIFY languageChanged)
    Q_PROPERTY(QString txtRouterIp          READ getTxtRouterIp                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtRouterIpDesc      READ getTxtRouterIpDesc             NOTIFY languageChanged)
    Q_PROPERTY(QString txtEnableWifi        READ getTxtEnableWifi               NOTIFY languageChanged)
    Q_PROPERTY(QString txtWifiNetwork       READ getTxtWifiNetwork              NOTIFY languageChanged)
    Q_PROPERTY(QString txtDisconnected      READ getTxtDisconnected             NOTIFY languageChanged)
    Q_PROPERTY(QString txtCancel            READ getTxtCancel                   NOTIFY languageChanged)
    Q_PROPERTY(QString txtSave              READ getTxtSave                     NOTIFY languageChanged)
    Q_PROPERTY(QString txtWifiSecurity      READ getTxtWifiSecurity             NOTIFY languageChanged)
    Q_PROPERTY(QString txtNone              READ getTxtNone                     NOTIFY languageChanged)
    Q_PROPERTY(QString txtKey               READ getTxtKey                      NOTIFY languageChanged)
    Q_PROPERTY(QString txtWepIndex          READ getTxtWepIndex                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtAuthentication    READ getTxtAuthentication           NOTIFY languageChanged)
    Q_PROPERTY(QString txtWepBitKey         READ getTxtWepBitKey                NOTIFY languageChanged)
    Q_PROPERTY(QString txtWepBitPassphrase  READ getTxtWepBitPassphrase         NOTIFY languageChanged)
    Q_PROPERTY(QString txtLeap              READ getTxtLeap                     NOTIFY languageChanged)
    Q_PROPERTY(QString txtWpaPersonal       READ getTxtWpaPersonal              NOTIFY languageChanged)
    Q_PROPERTY(QString txtSecurity          READ getTxtSecurity                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtPassword          READ getTxtPassword                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtUsername          READ getTxtUsername                 NOTIFY languageChanged)
    Q_PROPERTY(QString txtDisable           READ getTxtDisable                  NOTIFY languageChanged)
    Q_PROPERTY(QString txtEnable            READ getTxtEnable                   NOTIFY languageChanged)
    Q_PROPERTY(QString txtWifiPassword      READ getTxtWifiPassword             NOTIFY languageChanged)
    Q_PROPERTY(QString txtOpenSystem        READ getTxtOpenSystem               NOTIFY languageChanged)
    Q_PROPERTY(QString txtSharedKey         READ getTxtSharedKey                NOTIFY languageChanged)
public:
    static GUIStrings* instance(QApplication *app, DataEngine *dataEngine);
    ~GUIStrings();
public:
    QString getTxtOpenSystem()          { return tr("Open System", "WEP Authentication Type"); }
    QString getTxtSharedKey()           { return tr("Shared Key", "WEP Authentication Type"); }
    QString getTxtWifiPassword()        { return tr("Wifi Password"); }
    QString getTxtWepBitKey()           { return tr("WEP 40/128-bit Key", "Wireless Security Type"); }
    QString getTxtWepBitPassphrase()    { return tr("WEP 128-bit Passphrase", "Wireless Security Type"); }
    QString getTxtLeap()                { return tr("LEAP", "Wireless Security Type"); }
    QString getTxtWpaPersonal()         { return tr("WPA & WPA2 Personal", "Wireless Security Type"); }
    QString getTxtAuthentication()      { return tr("Authentication"); }
    QString getTxtWepIndex()            { return tr("WEP Index"); }
    QString getTxtKey()                 { return tr("Key"); }
    QString getTxtNone()                { return tr("None"); }
    QString getTxtWifiSecurity()        { return tr("Wireless Security"); }
    QString getTxtCancel()              { return tr("Cancel"); }
    QString getTxtSave()                { return tr("Save"); }
    QString getTxtPassword()            { return tr("Password"); }
    QString getTxtUsername()            { return tr("Username"); }
    QString getTxtDisable()             { return tr("Disable"); }
    QString getTxtEnable()              { return tr("Enable"); }
    QString getTxtSignalStrength()      { return tr("Signal Strength"); }
    QString getTxtSecurity()            { return tr("Security"); }
    QString getTxtDisconnected()        { return tr("Disconnected"); }
    QString getTxtWifiNetwork()         { return tr("Wifi Networks"); }
    QString getTxtEnableWifi()          { return tr("Enable Wifi Network"); }
    QString getTxtRouterIp()            { return tr("Router IP"); }
    QString getTxtRouterIpDesc();
    QString getTxtDone()                { return tr("Done"); }
    QString getTxtAutomatic()           { return tr("Automatic"); }
    QString getTxtManual()              { return tr("Manual"); }
    QString getTxtConfigIp()            { return tr("Configure IP"); }
    QString getTxtIpAddr()              { return tr("IP Address"); }
    QString getTxtSubnet()              { return tr("Subnet Mask"); }
    QString getTxtRoute()               { return tr("Router"); }
    QString getTxtConfigDns()           { return tr("Configure DNS"); }
    QString getTxtDnsIp()               { return tr("DNS IP"); }
    QString getTxtReboot()              { return tr("Reboot"); }
    QString getTxtShutdown()            { return tr("Turn Off"); }
    QString getTxtPlayer()              { return tr("Player"); }
    QString getTxtServer()              { return tr("Server"); }
    QString getTxtHDMI()                { return tr("HDMI"); }
    QString getTxtHeadphone()           { return tr("Headphone Port"); }
    QString getTxtLandscape()           { return tr("Landscape"); }
    QString getTxtPortrait()            { return tr("Portrait"); }
    QString getTxtOn()                  { return tr("On"); }
    QString getTxtOff()                 { return tr("Off"); }
    QString getTxtMainMenu()            { return tr("Main Menu"); }
    QString getTxtLanguage()            { return tr("Language"); }
    QString getTxtNetworkSettings()     { return tr("Network Settings"); }
    QString getTxtWirelessNetwork()     { return tr("Wireless Network"); }
    QString getTxtFunction()            { return tr("Function"); }
    QString getTxtOrientitation()       { return tr("Orientitation"); }
    QString getTxtSound()               { return tr("Sound"); }
    QString getTxtPower()               { return tr("Power"); }
    QString getTxtPlay()                { return tr("Play"); }
    QString getTxtFuncAsPlayer()        { return tr("Function as Player"); }
    QString getTxtFuncAsSrvr()          { return tr("Function as Server"); }
    QString getCurrentLangStr()         { return currentLanguageStr; }
    QString getCurrentIpAddr()          { return dataEngine->getCurrentIpAddress(); }
    QString getCurrentSubnet()          { return dataEngine->getCurrentSubnet(); }
    QString getCurrentRoute()           { return dataEngine->getCurrentRoute(); }
    QString getCurrentNetPropertiesStr(){ return dataEngine->getCurrentNetworkingStatus(); }
    QString getCurrentWirelessStr()     { return ( dataEngine->getCurrentWirelessStatus().length() == 0 ) ? getTxtOff() : dataEngine->getCurrentWirelessStatus(); }
    QString getCurrentFunctionStr()     { return (dataEngine->getSystemFunctionalityAsPlayer()) ? getTxtPlayer() : getTxtServer(); }
    QString getCurrentOrientitationStr(){ return (dataEngine->getSystemOrientitationAsLanscape()) ? getTxtLandscape() : getTxtPortrait(); }
    QString getCurrentSoundStr()        { return dataEngine->getCurrentSystemSoundOutput(); }
    QString getNetConfig()              { return (dataEngine->isDhcpIp()) ? getTxtAutomatic() : getTxtManual(); }
    QString getCurrentDnsConfig()       { return (dataEngine->isAutoDns()) ? getTxtAutomatic() : getTxtManual(); }
    QString getDnsIpAddress()           { return dataEngine->getCurrentDnsIp(); }
    QString getTxtFuncDesc();
    QString getIpAddrDescription();
public:
    Q_INVOKABLE void CancelWiredNetworkSettings() { dataEngine->cancelSettingsSession(); }
    Q_INVOKABLE void SaveWiredNetworkSettings();
    Q_INVOKABLE void ScanWirelessNetworks() { dataEngine->scanWifiNetworks(); }
    //Q_INVOKABLE QString GetCurrentWirelessStatus() { return dataEngine->getCurrentWirelessStatus(); }
    Q_INVOKABLE QString GetCompleteIpAddrString( QString string_ ) { return dataEngine->getCompleteIpAddString(string_); }
    Q_INVOKABLE int  ConvertCharToInt(QString string_, int index) { return string_.at(index).digitValue(); }
    Q_INVOKABLE void SetAutoDnsConfig(bool auto_);
    Q_INVOKABLE void SetAutoIpConfig(bool auto_);
    Q_INVOKABLE void PerformPowerOperation(QString op) { dataEngine->performPowerOperation(op); }
    Q_INVOKABLE void SetOrientitationLandscape(bool landscape);
    Q_INVOKABLE void SetFuncAsPlayer(bool player);
    Q_INVOKABLE void SetManualIpAddress(QString address, QString functionality);
    Q_INVOKABLE void ChangeSystemLanguage(const QString &lang);
    Q_INVOKABLE bool IsFunctionAsPlayer() const { return dataEngine->getSystemFunctionalityAsPlayer(); }
    Q_INVOKABLE bool IsOrientitationLandscape() const { return dataEngine->getSystemOrientitationAsLanscape(); }
    Q_INVOKABLE bool IsDhcpIp() const { return dataEngine->isDhcpIp(); }
    Q_INVOKABLE void EnableDisableWifi(bool enable);
    Q_INVOKABLE bool ActivateWifiConnection(int index);// { return dataEngine->activateWirelessConnection(index); }
    Q_INVOKABLE void SetSelectedSoundOutput(int index) { dataEngine->setCurrentSystemSoundOutput(index); }
    Q_INVOKABLE void SaveWifiAuthTypeNone() { dataEngine->saveWifiAuthTypeNone(); }
    Q_INVOKABLE void SaveWifiAuthTypeWpaPersonal(QString password) { dataEngine->saveWifiAuthTypeWpaPersonal(password); }
    Q_INVOKABLE void SaveWifiAuthTypeLeap(QString username, QString password) { dataEngine->saveWifiAuthTypeLeap(username, password); }
    Q_INVOKABLE void SaveWifiAuthTypeWepKey(QString key, int index, bool authTypeSharedKey) { dataEngine->saveWifiAuthTypeWepKey(key, index, authTypeSharedKey); }
    Q_INVOKABLE void SaveWifiAuthTypeWepPass(QString key, int index, bool authTypeSharedKey) { dataEngine->saveWifiAuthTypeWepPass(key, index, authTypeSharedKey); }
    WifiNetworks *getWifiNetworksModel() const { return dataEngine->getWifiNetworksList(); }
    SoundOutputModel *getSoundOutputsModel() const { return dataEngine->getSoundOutputModel(); }
private slots:
    void networkInformationUpdated();
    void wirelessScanStarted();
    void openAccessPointsPage();
    void orientitationUpdated();
    void soundOutputUpdated();
    void needAuthenticationForWifi();
    void wifiActivated();
signals:
    // This signal will be emitted when the system has loaded a new language.
    void languageChanged();
    void apsPageReadyToOpen();
    void startWirelessScanAnimation();
    void openWifiAuthenticationPage();
    void selectedWifiActivated();
private:
    explicit GUIStrings() {}
    explicit GUIStrings(QApplication *app_, DataEngine *dataEngine);
    static GUIStrings *engineInstance;
    GUIStrings(const GUIStrings&);
    GUIStrings& operator= (const GUIStrings&);
private:
    QTranslator deTranslator;
    QTranslator nlTranslator;
    QTranslator enTranslator;
    QApplication *app;
    DataEngine *dataEngine;
    QString currentLanguageStr;
};

#endif // GUISTRINGS_H
