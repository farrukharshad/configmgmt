// Copyright 2012

#ifndef WIFINETWORKS_H
#define WIFINETWORKS_H

#include <QObject>
#include <QDebug>
#include <QTimer>
#include <QString>
#include <QDBusObjectPath>
#include <QAbstractListModel>
#include <QModelIndex>
#include <QVariant>
#include <QDeclarativeView>
#include <QByteArray>
#include <QVarLengthArray>
#include "types.h"

#define  UBUNTU_13_04

//#include <QtDBus/QDBusMetaType>
//typedef QMap<QString, QMap<QString, QVariant> > Connection;
//Q_DECLARE_METATYPE(Connection)

typedef class _ap {
public:
    QString     ssid_;
    int         signalStrength_;
    int         wpaFlags_;
    int         rsnFlags_;
    bool        active_;
    QString     security;
    QString     apPath;
    QString     connSettingsPath;
    _ap() : ssid_(""), signalStrength_(0), wpaFlags_(0), rsnFlags_(0), active_(false), security(""), apPath(""), connSettingsPath("") {}
} AccessPoint;

/* This is singlelton class */
class WifiNetworks : public QAbstractListModel
{
    Q_OBJECT
    enum {
        MODEL_ROLE_WIFI_NETWORK_SSID = Qt::UserRole + 1
    };
public:
    static WifiNetworks *engineInstance;
    static WifiNetworks* instance();
    static void destroyInstance();
    ~WifiNetworks();
    bool activateWirelessConnection(int apIndex);
    int getCurrentIndex() const { return currentIndex; }
    void setCurrentIndex(int idx) { currentIndex = idx; }
    void scanWirelessNetworks();
    QString getActiveWirelessStrength();
    QString getActiveWirelessSecurity();
    void enableDisableWifi(bool enable);
    QString getCurrentWirelessStatus() { return getActiveWirelessStatus(); }
    void saveWifiAuthOptionsTypeNone();
    void saveWifiAuthOptionsTypeWpaPersonal(QString password);
    void saveWifiAuthOptionsTypeLeap(QString username, QString password);
    void saveWifiAuthTypeWepKey(QString key, int index, bool authTypeSharedKey);
    void saveWifiAuthTypeWepPass(QString key, int index, bool authTypeSharedKey);

    // -------- OVERRIDES ------------
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    bool insertRow(int row, const QModelIndex &parent);
    bool removeRow(int row, const QModelIndex &parent);
    bool insertRows(int row, int count, const QModelIndex &parent);
    bool removeRows(int row, int count, const QModelIndex &parent);
public slots:
    void wifiDeviceStateChange(uint new_state, uint old_state, uint reason);
    void newAccessPointFound(QDBusObjectPath path);
    void accessPointLost(QDBusObjectPath path);
private:
    void initializeWifiStuff();
    QString getActiveWirelessStatus();
    QString getConnectionSettingsForAccessPoint(QString apPath);
    QString extractSsidFromConnectionSettingsString(const QString &settings);
    void getActiveAPInfo();
    void waitConnectionStateChanged();
    void scanAps();
    void createNewConnectionAndConnect(const NMConnectionSettings &conn);
private:
    bool wifiConnected;
    int currentIndex;
    int newApIndex;
    QString wirelessDeviceDbusPath;
    QString activeApDbusPath;
    QList<AccessPoint> wirelessAPs;
    AccessPoint activeAp;
    WifiNetworks();
    WifiNetworks(const WifiNetworks&);
    WifiNetworks& operator= (const WifiNetworks&);
signals:
    void wirelessStatusChanged();
    void wirelessScanStarted();
    void apsListAvailable();
    void needAuthenticationToConnect();
    void wifiActivated();
};

#endif // WIFINETWORKS_H
