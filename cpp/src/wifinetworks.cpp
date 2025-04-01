// Copyright 2012

// dataengine.cpp
// Implementation of WifiNetworks class.

#include "wifinetworks.h"
#include "extern_defs.h"
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>
#include <QDateTime>
#include <private/qdbusutil_p.h>

WifiNetworks* WifiNetworks::engineInstance = NULL;

WifiNetworks::WifiNetworks() :
    wirelessDeviceDbusPath("")
{   
    currentIndex = 0;
    newApIndex = -1;

    initializeWifiStuff();

    getActiveAPInfo();
    // First time scan all wireless networks and see if we are already connected to
    // some access poing.
    //scanWirelessNetworks();
}
void WifiNetworks::initializeWifiStuff()
{
    // Create New connection for this access point.
    // Check if Access point enforce security then ask for password otherwise
    // Just create a connection with dummy template and try to activate this connection.

    QDBusInterface interface(NM_DBUS_SERVICE, NM_DBUS_PATH, NM_DBUS_IFACE, QDBusConnection::systemBus());

    // Get a list of all devices
    QDBusReply<QList<QDBusObjectPath> > result = interface.call("GetDevices");
    foreach (const QDBusObjectPath& connection, result.value()) {
        QDBusInterface device(NM_DBUS_SERVICE, connection.path(), "org.freedesktop.NetworkManager.Device", QDBusConnection::systemBus());
        if ( device.property("DeviceType").toInt() == NM_DEVICE_TYPE_WIFI ) {
            wirelessDeviceDbusPath = connection.path();
        }
    }

    // Register some signals.
    QDBusConnection::systemBus().connect(NM_DBUS_SERVICE, wirelessDeviceDbusPath, "org.freedesktop.NetworkManager.Device", "StateChanged", this, SLOT(wifiDeviceStateChange(uint, uint, uint)));
    QDBusConnection::systemBus().connect(NM_DBUS_SERVICE, wirelessDeviceDbusPath, "org.freedesktop.NetworkManager.Device.Wireless", "AccessPointAdded", this, SLOT(newAccessPointFound(QDBusObjectPath)));
    QDBusConnection::systemBus().connect(NM_DBUS_SERVICE, wirelessDeviceDbusPath, "org.freedesktop.NetworkManager.Device.Wireless", "AccessPointRemoved", this, SLOT(accessPointLost(QDBusObjectPath)));
}
void WifiNetworks::waitConnectionStateChanged()
{

}
void WifiNetworks::newAccessPointFound(QDBusObjectPath path)
{
    QDBusInterface apIfc(NM_DBUS_SERVICE, path.path(), "org.freedesktop.NetworkManager.AccessPoint", QDBusConnection::systemBus());
    if ( apIfc.isValid() ) {
        AccessPoint ap_;
        ap_.apPath = path.path();
        // Ok, We have this Access Point here. Get SSID
        QVariant ssid = apIfc.property("Ssid");
        if ( ssid.isValid() ) {
            ap_.ssid_ = QString(qvariant_cast<QByteArray>(ssid));

            // Check if there are connection settings for this Access Point.
            ap_.connSettingsPath = getConnectionSettingsForAccessPoint(ap_.ssid_);
        }
        // Get the security flags of this access poing.
        QVariant flags = apIfc.property("WpaFlags");
        if ( flags.isValid() ) {
            ap_.wpaFlags_ = flags.toUInt();
        }
        flags = apIfc.property("RsnFlags");
        if ( flags.isValid() ) {
            ap_.rsnFlags_ = flags.toUInt();
        }
        // Save this AP in our list.
        wirelessAPs.push_back(ap_);
        insertRow((wirelessAPs.count() - 1), QModelIndex());

        // Tell GUI or all clients that our scan is over and we have the list of access points.
        emit apsListAvailable();
    }
}
void WifiNetworks::accessPointLost(QDBusObjectPath path)
{
    for ( int i = 0; i < wirelessAPs.count(); i++ ) {
        if ( wirelessAPs.at(i).apPath == path.path() ) {
            wirelessAPs.removeAt(i);
            removeRow(i, QModelIndex());
        }
    }
}

QHash<int, QByteArray> WifiNetworks::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[MODEL_ROLE_WIFI_NETWORK_SSID]  = "ssid";
    return roles;
}

WifiNetworks::~WifiNetworks()
{
}
WifiNetworks* WifiNetworks::instance()
{
    if ( !engineInstance )
        engineInstance = new WifiNetworks();

    return engineInstance;
}
void WifiNetworks::destroyInstance()
{
    if ( engineInstance != NULL ) delete engineInstance;
    engineInstance = NULL;
}
void WifiNetworks::scanWirelessNetworks()
{
    // Before we scan wireless networks we will clear our existing Access Points List
    removeRows(0, wirelessAPs.count(), QModelIndex());
    wirelessAPs.clear();
    activeApDbusPath = "";
    currentIndex = 0;

    // Make sure we do have some wireless device in the system.
    if ( wirelessDeviceDbusPath.length() > 0 ) {
        QDBusInterface device(NM_DBUS_SERVICE, wirelessDeviceDbusPath, "org.freedesktop.NetworkManager.Device.Wireless", QDBusConnection::systemBus());
        if ( device.isValid() ) {
            // Get all scanned access points.
            QDBusReply<QList<QDBusObjectPath> > result = device.call("GetAccessPoints");
            // Now we will gather some properties of all scanned access points.
            foreach (const QDBusObjectPath& ap, result.value()) {
                newAccessPointFound(ap);
            }
        } else {
            qDebug () << "Wireless device is not valid yet";
        }
    }
}
void WifiNetworks::scanAps()
{
    if ( wirelessDeviceDbusPath.length() > 0 ) {
        QDBusInterface device(NM_DBUS_SERVICE, wirelessDeviceDbusPath, "org.freedesktop.NetworkManager.Device.Wireless", QDBusConnection::systemBus());
        if ( device.isValid() ) {
            // Get all scanned access points.
            QMap<QString, QVariant> args;
            QDBusMessage result = device.call("RequestScan", args);
            if ( result.type() == QDBusMessage::ErrorMessage )
                qDebug () << "Error requesting scan";
            else
                qDebug () << "Scan requested successfully";
        }
    }
}
QString WifiNetworks::getActiveWirelessStatus()
{
    qDebug () << "Getting the status of active wireless device = " + activeAp.ssid_;
    return activeAp.ssid_;
}
QString WifiNetworks::getActiveWirelessSecurity()
{
    return activeAp.security;
}
QString WifiNetworks::getActiveWirelessStrength()
{
    return QString(activeAp.signalStrength_);
}
QString WifiNetworks::extractSsidFromConnectionSettingsString(const QString &settings)
{
    QString a = "\"ssid\" = [Variant(QByteArray): {";

    int idx = settings.indexOf(a);
    QString b = settings.mid((idx + a.length()));
    idx = b.indexOf("}");
    QString ssid = b.left(idx).trimmed();

    // Convert this byte array values string to byte array type.
    int count = 0;
    for ( int i = 0; i < ssid.length(); i++ ) {
        if ( ssid.at(i) == ',' )
            count ++;
    }
    QByteArray array;
    for ( int i = 0; i <= count; i++ ) {
        array.push_back(ssid.section(',', i, i).toUInt());
    }
    return QString(array);
}
QString WifiNetworks::getConnectionSettingsForAccessPoint(QString ssid)
{
    QString settingsObject = "";
#ifdef UBUNTU_10_04
    // Search connection for this access poing in User Settings.
    QDBusInterface usIfc("org.freedesktop.NetworkManagerUserSettings", "/org/freedesktop/NetworkManagerSettings", "org.freedesktop.NetworkManagerSettings", QDBusConnection::systemBus());
    QDBusReply<QList<QDBusObjectPath> > result = usIfc.call("ListConnections");
    foreach (const QDBusObjectPath& connection, result.value()) {
        QDBusInterface connIfc("org.freedesktop.NetworkManagerUserSettings", connection.path(), "org.freedesktop.NetworkManagerSettings.Connection", QDBusConnection::systemBus());
        if ( connIfc.isValid() ) {
            // Get settings of this connection. If SSID is given and same as our input. We have a valid connection.
            QDBusMessage reply = connIfc.call("GetSettings");

            if ( ssid == extractSsidFromConnectionSettingsString(QDBusUtil::argumentToString(reply.arguments().at(0))) ) {
                settingsObject = connection.path();
                break;
            }
        }
    }
#endif // UBUNTU_10_04
#ifdef UBUNTU_13_04
    QDBusInterface setIfc("org.freedesktop.NetworkManager", "/org/freedesktop/NetworkManager/Settings", "org.freedesktop.NetworkManager.Settings", QDBusConnection::systemBus());
    QDBusReply<QList<QDBusObjectPath> > connections = setIfc.call("ListConnections");
    foreach (const QDBusObjectPath &connection, connections.value() ) {
        QDBusInterface connIfc("org.freedesktop.NetworkManager", connection.path(), "org.freedesktop.NetworkManager.Settings.Connection", QDBusConnection::systemBus());
        if ( connIfc.isValid() ) {
            QDBusMessage reply = connIfc.call("GetSettings");
            if ( ssid == extractSsidFromConnectionSettingsString(QDBusUtil::argumentToString(reply.arguments().at(0)))) {
                settingsObject = connection.path();
                break;
            }
        }
    }
#endif // UBUNTU_10_04
    return settingsObject;
}

bool WifiNetworks::activateWirelessConnection(int apIndex)
{
    bool status = false;
    if ( apIndex < wirelessAPs.count() ) {

        // First enable wireless device.
        // enableDisableWifi(true);

        QDBusInterface nmIfc(NM_DBUS_SERVICE, NM_DBUS_PATH, NM_DBUS_IFACE, QDBusConnection::systemBus());

        // Now activate the given access point.
        if ( wirelessAPs.at(apIndex).connSettingsPath.length() > 0 ) {
            // We already have connection created for this Access Point.
            // We just need to activate it.

            QList<QVariant> arguments;
#ifdef UBUNTU_10_04
            arguments << "org.freedesktop.NetworkManagerUserSettings"
                      << QVariant::fromValue(QDBusObjectPath(wirelessAPs.at(apIndex).connSettingsPath))
                      << QVariant::fromValue(QDBusObjectPath(wirelessDeviceDbusPath))
                      << QVariant::fromValue(QDBusObjectPath(wirelessAPs.at(apIndex).apPath));
#endif // UBUNTU_10_04
#ifdef UBUNTU_13_04

            // arguments << "org.freedesktop.NetworkManager"
            arguments   << QVariant::fromValue(QDBusObjectPath(wirelessAPs.at(apIndex).connSettingsPath))
                        << QVariant::fromValue(QDBusObjectPath(wirelessDeviceDbusPath))
                        << QVariant::fromValue(QDBusObjectPath(wirelessAPs.at(apIndex).apPath));

#endif // UBUNTU_13_04
            // Get a list of all devices
            QDBusMessage reply = nmIfc.callWithArgumentList(QDBus::Block, "ActivateConnection", arguments);
            if ( reply.type() == QDBusMessage::ErrorMessage ) {
                qDebug () << "Unable to activate given wireless access point. Error = " << nmIfc.lastError().message();
            } else {
                AccessPoint ap = wirelessAPs.at(apIndex);
                ap.active_ = true;
                wirelessAPs.replace(apIndex, ap);
                status = true;
                qDebug () << "Wireless Connection Activated Successfully";
            }
        } else {
            // Ok, we don't have any existing connection for this access point.
            // and we need to create a new connection, for our new connection
            // first of all we need authentication information for this
            // access point.
            newApIndex = apIndex;
            emit needAuthenticationToConnect();
        }
    }
    return status;
}
//====================================================
// Reference: https://developer.gnome.org/NetworkManager/unstable/ref-settings.html
//====================================================
void WifiNetworks::saveWifiAuthOptionsTypeNone()
{
    if ( newApIndex >= 0 && newApIndex < wirelessAPs.count() ) {
        // Create a new connection object
        NMConnectionSettings connection;

        // Build up the 'connection' Setting
        connection["connection"]["name"] = "Auto_" + wirelessAPs.at(newApIndex).ssid_;
        connection["connection"]["id"]   = "Auto_" + wirelessAPs.at(newApIndex).ssid_;
        connection["connection"]["type"] = "802-11-wireless";

        // Build up the '802-3-ethernet' Setting
        connection["802-11-wireless"]["ssid"] = wirelessAPs.at(newApIndex).ssid_;

        // Build up the 'ipv4' Setting
        connection["ipv4"]["method"] = "auto";

        // Now finally create new connection & connect
        createNewConnectionAndConnect(connection);
    }
}
void WifiNetworks::saveWifiAuthOptionsTypeWpaPersonal(QString password)
{
    if ( newApIndex >= 0 && newApIndex < wirelessAPs.count() ) {
        // Create a new connection object
        NMConnectionSettings connection;

        // Build up the 'connection' Setting
        connection["connection"]["name"] = "Auto_" + wirelessAPs.at(newApIndex).ssid_;
        connection["connection"]["id"]   = "Auto_" + wirelessAPs.at(newApIndex).ssid_;
        connection["connection"]["type"] = "802-11-wireless";

        // Build up the 'ipv4' Setting
        connection["ipv4"]["method"] = "auto";

        // Build up the '802-11-wireless' Setting
        connection["802-11-wireless"]["ssid"] = wirelessAPs.at(newApIndex).ssid_;
        connection["802-11-wireless"]["security"] = "802-11-wireless-security";

        // Build up the '802-11-wireless-security' settings.
        connection["802-11-wireless-security"]["psk"] = password;
        connection["802-11-wireless-security"]["psk-flags"] = 0x1;

        qDebug () << "Now we are saving new connection";
        // Now finally create new connection & connect
        createNewConnectionAndConnect(connection);
    }
}
void WifiNetworks::saveWifiAuthOptionsTypeLeap(QString username, QString password)
{
    if ( newApIndex >= 0 && newApIndex < wirelessAPs.count() ) {
        // Create a new connection object
        NMConnectionSettings connection;

        // Build up the 'connection' Setting
        connection["connection"]["name"] = "Auto_" + wirelessAPs.at(newApIndex).ssid_;
        connection["connection"]["id"]   = "Auto_" + wirelessAPs.at(newApIndex).ssid_;
        connection["connection"]["type"] = "802-11-wireless";

        // Build up the 'ipv4' Setting
        connection["ipv4"]["method"] = "auto";

        // Build up the '802-11-wireless' Setting
        connection["802-11-wireless"]["ssid"] = wirelessAPs.at(newApIndex).ssid_;
        connection["802-11-wireless"]["security"] = "802-11-wireless-security";

        // Build up the '802-11-wireless-security' settings.
        connection["802-11-wireless-security"]["key-mgmt"] = "ieee8021x";
        connection["802-11-wireless-security"]["auth-alg"] = "leap";
        connection["802-11-wireless-security"]["leap-username"] = username;
        connection["802-11-wireless-security"]["leap-password"] = password;
        connection["802-11-wireless-security"]["leap-password-flags"] = 0x1;

        // Now finally create new connection & connect
        createNewConnectionAndConnect(connection);
    }
}
void WifiNetworks::saveWifiAuthTypeWepKey(QString key, int index, bool authTypeSharedKey)
{
    if ( newApIndex >= 0 && newApIndex < wirelessAPs.count() ) {
        // Create a new connection object
        NMConnectionSettings connection;

        // Build up the 'connection' Setting
        connection["connection"]["name"] = "Auto_" + wirelessAPs.at(newApIndex).ssid_;
        connection["connection"]["id"]   = "Auto_" + wirelessAPs.at(newApIndex).ssid_;
        connection["connection"]["type"] = "802-11-wireless";

        // Build up the 'ipv4' Setting
        connection["ipv4"]["method"] = "auto";

        // Build up the '802-11-wireless' Setting
        connection["802-11-wireless"]["ssid"] = wirelessAPs.at(newApIndex).ssid_;
        connection["802-11-wireless"]["security"] = "802-11-wireless-security";

        // Build up the '802-11-wireless-security' settings.
        connection["802-11-wireless-security"]["key-mgmt"] = "ieee8021x";
        if ( authTypeSharedKey ) {
            connection["802-11-wireless-security"]["auth-alg"] = "shared";
        } else {
            connection["802-11-wireless-security"]["auth-alg"] = "open";
        }
        switch(index) {
        case 0:
            connection["802-11-wireless-security"]["wep-key0"] = key;
            break;
        case 1:
            connection["802-11-wireless-security"]["wep-key1"] = key;
            break;
        case 2:
            connection["802-11-wireless-security"]["wep-key2"] = key;
            break;
        case 3:
            connection["802-11-wireless-security"]["wep-key3"] = key;
            break;
        }
        connection["802-11-wireless-security"]["wep-key-type"] = 1;         // 1 = WEP Keys are hexadecimal, 2 = WEP Keys are passphrase
        connection["802-11-wireless-security"]["wep-key-flags"] = 0x1;

        // Now finally create new connection & connect
        createNewConnectionAndConnect(connection);
    }
}

void WifiNetworks::saveWifiAuthTypeWepPass(QString key, int index, bool authTypeSharedKey)
{
    if ( newApIndex >= 0 && newApIndex < wirelessAPs.count() ) {
        // Create a new connection object
        NMConnectionSettings connection;

        // Build up the 'connection' Setting
        connection["connection"]["name"] = "Auto_" + wirelessAPs.at(newApIndex).ssid_;
        connection["connection"]["id"]   = "Auto_" + wirelessAPs.at(newApIndex).ssid_;
        connection["connection"]["type"] = "802-11-wireless";

        // Build up the 'ipv4' Setting
        connection["ipv4"]["method"] = "auto";

        // Build up the '802-11-wireless' Setting
        connection["802-11-wireless"]["ssid"] = wirelessAPs.at(newApIndex).ssid_;
        connection["802-11-wireless"]["security"] = "802-11-wireless-security";

        // Build up the '802-11-wireless-security' settings.
        connection["802-11-wireless-security"]["key-mgmt"] = "ieee8021x";
        if ( authTypeSharedKey ) {
            connection["802-11-wireless-security"]["auth-alg"] = "shared";
        } else {
            connection["802-11-wireless-security"]["auth-alg"] = "open";
        }
        switch(index) {
        case 0:
            connection["802-11-wireless-security"]["wep-key0"] = key;   // Convert key to MD5 hash
            break;
        case 1:
            connection["802-11-wireless-security"]["wep-key1"] = key;
            break;
        case 2:
            connection["802-11-wireless-security"]["wep-key2"] = key;
            break;
        case 3:
            connection["802-11-wireless-security"]["wep-key3"] = key;
            break;
        }

        connection["802-11-wireless-security"]["wep-key-type"] = 2;         // 1 = WEP Keys are hexadecimal, 2 = WEP Keys are passphrase
        connection["802-11-wireless-security"]["wep-key-flags"] = 0x1;

        // Now finally create new connection & connect
        createNewConnectionAndConnect(connection);
    }
}

void WifiNetworks::createNewConnectionAndConnect(const NMConnectionSettings &connection)
{
    QDBusInterface nmIfc(NM_DBUS_SERVICE, NM_DBUS_PATH, NM_DBUS_IFACE, QDBusConnection::systemBus());

    QList<QVariant> arguments;
    arguments << QVariant::fromValue(connection)
              << QVariant::fromValue(QDBusObjectPath(wirelessDeviceDbusPath))
              << QVariant::fromValue(QDBusObjectPath(wirelessAPs.at(newApIndex).apPath));
    QDBusMessage reply = nmIfc.callWithArgumentList(QDBus::Block, "AddAndActivateConnection", arguments);
    if ( reply.type() == QDBusMessage::ErrorMessage ) {
        qDebug () << "Unable to activate given wireless access point. Error = " << nmIfc.lastError().message();
        newApIndex = -1;
    } else {
        qDebug () << "Wireless Connection Activated Successfully";
    }
}

void WifiNetworks::enableDisableWifi(bool enable)
{
    QDBusInterface interface(NM_DBUS_SERVICE, NM_DBUS_PATH, NM_DBUS_IFACE, QDBusConnection::systemBus());

    if ( enable ) {
        // Tell GUI or any other client that we are starting wireless access point scanning.
        emit wirelessScanStarted();
    }

    QVariant deviceEnabled = interface.property("WirelessEnabled");
    if ( deviceEnabled.toBool() && !enable ) {
        // Device is enabled and we want to disable it
        interface.setProperty("WirelessEnabled", QVariant(false));
    } else if ( !deviceEnabled.toBool() && enable ) {
        // Device is disabled and we want to enable it.
        interface.setProperty("WirelessEnabled", QVariant(true));
    } else if ( deviceEnabled.toBool() && enable ) {
        // Device is enabled and we want to enable it, in this
        // case we will scan wireless devices.
        scanWirelessNetworks();
    }
}
void WifiNetworks::getActiveAPInfo()
{
    // Make sure we do have some wireless device in the system.
    if ( wirelessDeviceDbusPath.length() > 0 ) {
        QDBusInterface device(NM_DBUS_SERVICE, wirelessDeviceDbusPath, "org.freedesktop.NetworkManager.Device.Wireless", QDBusConnection::systemBus());
        if ( device.isValid() ) {
            // Check if this wifi device has some active access point.
            QVariant ap = device.property("ActiveAccessPoint");
            if ( ap.isValid() ) {
                QDBusObjectPath p = qvariant_cast<QDBusObjectPath>(ap);
                if ( p.path().length() > 1 ) {
                    activeApDbusPath = p.path();
                    QDBusInterface apIfc(NM_DBUS_SERVICE, activeApDbusPath, "org.freedesktop.NetworkManager.AccessPoint", QDBusConnection::systemBus());
                    if ( apIfc.isValid() ) {

                        activeAp.apPath = p.path();

                        // Ok, We have this Access Point here. Get SSID
                        QVariant ssid = apIfc.property("Ssid");
                        if ( ssid.isValid() ) {
                            activeAp.ssid_ = QString(qvariant_cast<QByteArray>(ssid));

                            // Check if there are connection settings for this Access Point.
                            activeAp.connSettingsPath = getConnectionSettingsForAccessPoint(activeAp.ssid_);
                        }

                        // Check if it is active AP.
                        activeAp.active_ = true;

                        // Get the security flags of this access poing.
                        QVariant flags = apIfc.property("WpaFlags");
                        if ( flags.isValid() ) {
                            activeAp.wpaFlags_ = flags.toUInt();
                        }
                        flags = apIfc.property("RsnFlags");
                        if ( flags.isValid() ) {
                            activeAp.rsnFlags_ = flags.toUInt();
                        }
                    }
                } else {
                    // We don't have any active access point now.
                    activeApDbusPath = "";
                    activeAp = AccessPoint();
                }
            }
        }
    }
}
void WifiNetworks::wifiDeviceStateChange(uint new_state, uint old_state, uint reason)
{
    switch(new_state) {
    case NM_DEVICE_STATE_UNAVAILABLE:
        activeAp = AccessPoint();
        wifiConnected = false;
        emit wirelessStatusChanged();
        break;
    case NM_DEVICE_STATE_FAILED:
        emit needAuthenticationToConnect();
        break;
    case NM_DEVICE_STATE_ACTIVATED:
        getActiveAPInfo();
        emit wifiActivated();
        break;
    }
}

// ----------------------------------------------------------------------------
//          O V E R R I D E S
// ----------------------------------------------------------------------------
int WifiNetworks::rowCount(const QModelIndex &parent) const
{
    return wirelessAPs.count();
}
QVariant WifiNetworks::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (index.row() >= wirelessAPs.count())
        return QVariant();

    // Return data as per role
    QString str;
    switch(role) {
    case MODEL_ROLE_WIFI_NETWORK_SSID:
        return QString(wirelessAPs.at(index.row()).ssid_);
    default:
        return QVariant();
    }
    return QVariant();
}
bool WifiNetworks::insertRows(int row, int count, const QModelIndex &parent)
{
    if ( parent.isValid() )
        return false;
    beginInsertRows(parent, row, count);
    endInsertRows();
    return true;
}
bool WifiNetworks::removeRows(int row, int count, const QModelIndex &parent)
{
    if ( count > 0 ) {
        beginRemoveRows(parent, row, count);
        endRemoveRows();
    }
    return true;
}
bool WifiNetworks::insertRow(int row, const QModelIndex &parent)
{
    // first and last are the row numbers that the new rows will have after they have been inserted.
    if ( parent.isValid() )
        return false;
    beginInsertRows(parent, row, row);
    endInsertRows();
    return true;
}
bool WifiNetworks::removeRow(int row, const QModelIndex &parent)
{
    // first and last are the row numbers of the rows to be removed.
    beginRemoveRows(parent, row, row);
    endRemoveRows();
    return true;
}
