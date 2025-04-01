// Copyright 2012

// dataengine.cpp
// Implementation of DataEngine class.

#include "dataengine.h"
#include <QDateTime>
#include <QDebug>

// Following 4 includes are required to gather networking information
#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusMessage>
#include <QtDBus/QDBusReply>
#include <QtDBus/QDBusMetaType>
#include <QtCore/QMetaProperty>
#include <private/qdbusutil_p.h>
#include <QtEndian>
#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>
#include "extern_defs.h"
#include "types.h"

DataEngine* DataEngine::engineInstance = NULL;

DataEngine::DataEngine(const WId wnd):
    wifiNetworks(NULL),
    playerFunctionality(true),          // Default system functionality as player.
    hdmiSound(true),
    appWnd(wnd),
    soundEngine(NULL)
{
    initializeWiredNetworkingModule();

    initializeWirelessNetworkingModule();

    initializeSoundModule();
}
DataEngine::~DataEngine()
{
    if ( soundEngine != NULL ) {
        delete soundEngine;
        soundEngine = NULL;
    }
    if ( wifiNetworks != NULL ) {
        WifiNetworks::destroyInstance();
        wifiNetworks = NULL;
    }
}
void DataEngine::destroyInstance()
{
    if ( engineInstance != NULL ) delete engineInstance;
    engineInstance = NULL;
}

DataEngine* DataEngine::instance(const WId wnd)
{
    if ( !engineInstance )
        engineInstance = new DataEngine(wnd);

    return engineInstance;
}
void DataEngine::performPowerOperation(QString op)
{
    // FIXME: Implement actual functionality
    exit(-1);
}
// ========================================================
// ========================================================
//          S O U N D    C O N F I G U R A T I O N
// ========================================================
void DataEngine::initializeSoundModule()
{
    soundEngine = new SoundEngine();
    if ( !soundEngine->initialize() ) {
        delete soundEngine;
        soundEngine = NULL;
    }
    QObject::connect(soundEngine, SIGNAL(updateSoundOutputGui()), this, SLOT(soundOutputChanged()));
}
QString DataEngine::getCurrentSystemSoundOutput()
{
    if ( soundEngine != NULL ) {
        return soundEngine->getCurrentSoundOutputSourceReadableName();
    }
    return QString("");
}
void DataEngine::setCurrentSystemSoundOutput(int idx)
{
    if ( soundEngine != NULL ) {
        soundEngine->setSoundOutputSource(idx);
    }
}
void DataEngine::soundOutputChanged()
{
    emit updateSoundOutput();
}

// ========================================================
// ========================================================
// ========================================================
//          S C R E E N    C O N F I G U R A T I O N
// ========================================================
// ========================================================
void DataEngine::setSystemOrientitationAsLandscape(bool landscape)
{
    Display                 *dpy;
    XRRScreenConfiguration  *conf;
    short                   original_rate;
    Rotation                original_rotation;
    SizeID                  original_size_id;
    dpy                     = XOpenDisplay(NULL);
    conf                    = XRRGetScreenInfo(dpy, appWnd);
    original_rate           = XRRConfigCurrentRate(conf);
    original_size_id        = XRRConfigCurrentConfiguration(conf, &original_rotation);

    bool update = false;
    if ( original_rotation == XRNDR_LANDSCAPE_ORIENTITATION && !landscape ) {
        original_rotation = XRNDR_PORTRAIT_ORIENTITATION;
        update = true;
    } else if ( original_rotation == XRNDR_PORTRAIT_ORIENTITATION && landscape ) {
        original_rotation = XRNDR_LANDSCAPE_ORIENTITATION;
        update = true;
    }
    if ( update ) {
        XRRSetScreenConfigAndRate(dpy, conf, appWnd, original_size_id, original_rotation, original_rate, CurrentTime);
        emit orientitationChanged();
    }
    XCloseDisplay(dpy);
}
bool DataEngine::getSystemOrientitationAsLanscape()
{
    Display                 *dpy;
    XRRScreenConfiguration  *conf;
    short                   original_rate;
    Rotation                original_rotation;
    SizeID                  original_size_id;
    dpy                     = XOpenDisplay(NULL);
    conf                    = XRRGetScreenInfo(dpy, appWnd);
    original_rate           = XRRConfigCurrentRate(conf);
    original_size_id        = XRRConfigCurrentConfiguration(conf, &original_rotation);
    if ( original_rotation == XRNDR_LANDSCAPE_ORIENTITATION )
        return true;
    else
        return false;
}

// ========================================================
// ========================================================
//          W I R E L E S S    N E T W O R K I N G
// ========================================================
// ========================================================
void DataEngine::initializeWirelessNetworkingModule()
{
    if ( wifiNetworks == NULL )
        wifiNetworks = WifiNetworks::instance();

    // Register any signals you want to register here which are related to wifi modules.
    QObject::connect(wifiNetworks, SIGNAL(wirelessStatusChanged()), this, SLOT(wifiSettingsChanged()));
    QObject::connect(wifiNetworks, SIGNAL(apsListAvailable()), this, SLOT(accessPointsListAvailable()));
    QObject::connect(wifiNetworks, SIGNAL(wirelessScanStarted()), this, SLOT(wirelessScanStarted()));
    QObject::connect(wifiNetworks, SIGNAL(needAuthenticationToConnect()), this, SLOT(needAuthenticationForWifi()));
    QObject::connect(wifiNetworks, SIGNAL(wifiActivated()), this, SLOT(selectedWifiActivated()));
}
void DataEngine::selectedWifiActivated()
{
    emit wifiActivated();
}

void DataEngine::needAuthenticationForWifi()
{
    emit openWifiAuthenticationPage();
}
void DataEngine::wifiSettingsChanged()
{
    emit networkInformationUpdated();
}
void DataEngine::accessPointsListAvailable()
{
    qDebug () << "Access Points List Avaialble";
    emit openApsListPage();
}
void DataEngine::wirelessScanStarted()
{
    emit scanningWirelessAps();
}

void DataEngine::enableDisableWifi(bool enable)
{
    wifiNetworks->enableDisableWifi(enable);
}
// ========================================================
// ========================================================
//          W I R E D    N E T W O R K I N G
// ========================================================
// ========================================================
void DataEngine::initializeWiredNetworkingModule()
{
    QDBusInterface interface(NM_DBUS_SERVICE, NM_DBUS_PATH, NM_DBUS_IFACE, QDBusConnection::systemBus());

    // Get a list of all devices
    QDBusReply<QList<QDBusObjectPath> > result = interface.call("GetDevices");
    foreach (const QDBusObjectPath& devPath, result.value()) {
        QDBusInterface device(NM_DBUS_SERVICE, devPath.path(), "org.freedesktop.NetworkManager.Device", QDBusConnection::systemBus());
        if ( device.property("DeviceType").toInt() == NM_DEVICE_TYPE_ETHERNET ) {

            eth.mac = getMacAddressOfWiredDev(devPath.path());
            // Save the ethernet device DBus path
            eth.nm_dev_path_ = devPath.path();
            // Get the status of the device
            eth.dev_state_ = device.property("State").toInt();
            // Get the IPv4 information if the device is active
            if ( eth.dev_state_ == NM_DEVICE_STATE_ACTIVATED ) {
                // IMPORTANT: We can get networking addresses from different
                // places, but it will be good if we get it from Ip4Config because
                // this information will always be there, but if we get this information
                // from connection settings, it is possible for automatically created connections
                // this information is not there. Though we will always write
                // this information in connection settings whenever we want to modify
                // these parameters.
                QVariant ipv4config = device.property("Ip4Config");

                if ( ipv4config.isValid() ) {
                    QDBusObjectPath path = qvariant_cast<QDBusObjectPath>(ipv4config);
                    QDBusMessage message = QDBusMessage::createMethodCall(NM_DBUS_SERVICE, path.path(), QLatin1String("org.freedesktop.DBus.Properties"), QLatin1String("Get"));
                    QList<QVariant> arguments;

                    // Get network addresses (i.e IP, Netmask, Route Ip)
                    arguments << "org.freedesktop.NetworkManager.IP4Config" << "Addresses";
                    message.setArguments(arguments);
                    QDBusConnection connection = QDBusConnection::systemBus();
                    QDBusMessage reply = connection.call(message);
                    QString property = QDBusUtil::argumentToString(reply.arguments().at(0)).toHtmlEscaped();
                    extractNetworkPropertiesFromString(property, eth.currentSettings.ip_, eth.currentSettings.mask_, eth.currentSettings.route_);

                    // Get network dns information
                    QDBusMessage msg = QDBusMessage::createMethodCall(NM_DBUS_SERVICE, path.path(), QLatin1String("org.freedesktop.DBus.Properties"), QLatin1String("Get"));
                    QList<QVariant> args;
                    args << "org.freedesktop.NetworkManager.IP4Config" << "Nameservers";
                    msg.setArguments(args);
                    QDBusMessage dns_reply = connection.call(msg);
                    QString dns_property = QDBusUtil::argumentToString(dns_reply.arguments().at(0)).toHtmlEscaped();
                    extractNetworkPropertiesFromString(dns_property, eth.currentSettings.dns_);
                }
#ifdef UBUNTU_13_04
                eth.nm_conn_settings_path_ = getConnectionSettings(eth.mac, eth.nmConnectionSettings);
                if ( eth.nm_conn_settings_path_.length() > 0 ) {
                    QVariantMap ipv4Settings = eth.nmConnectionSettings.value("ipv4");
                    if ( ipv4Settings.value("method").toString() == "auto" )
                        eth.currentSettings.dhcp_ = true;
                    else
                        eth.currentSettings.dhcp_ = false;
                }
#endif // UBUNTU_13_04
            }

            // Once we have gather all the information. Save it also as session settings.
            eth.sessionSettings = eth.currentSettings;
            eth.settings_modified_ = false;
        }
    }
    emit networkInformationUpdated();
}
void DataEngine::setDhcpConfiguration(bool dhcp_)
{
    eth.sessionSettings.dhcp_ = dhcp_;
    eth.settings_modified_ = true;
    emit networkInformationUpdated();
}
void DataEngine::setAutoDns(bool auto_)
{
    eth.sessionSettings.auto_dns_ = auto_;
    eth.settings_modified_ = true;
    emit networkInformationUpdated();
}
void DataEngine::saveWiredNetworkSettings()
{
    if ( eth.settings_modified_ && (eth.sessionSettings != eth.currentSettings) ) {
        saveWiredNetworkSettingsToDevice();

        // Now again read all settings from the device
        initializeWiredNetworkingModule();
    }
}
void DataEngine::cancelSettingsSession()
{
    eth.sessionSettings = eth.currentSettings;
    emit networkInformationUpdated();
}
void DataEngine::setManualIpAddress(QString address, QString functionality)
{
    if ( functionality == "ipaddress" ) {
        eth.sessionSettings.ip_.setAddress(address);
        eth.settings_modified_ = true;
    } else if ( functionality == "subnet" ) {
        eth.sessionSettings.mask_.setAddress(address);
        eth.settings_modified_ = true;
    } else if ( functionality == "routerip" ) {
        eth.sessionSettings.route_.setAddress(address);
        eth.settings_modified_ = true;
    } else if ( functionality == "dnsip" ) {
        eth.sessionSettings.dns_.setAddress(address);
        eth.settings_modified_ = true;
    }
    emit networkInformationUpdated();
}

// ==============================================
//      N E W O R K I N G   H E L P E R S
// ==============================================
QByteArray DataEngine::getMacAddressOfWiredDev(const QString &devPath)
{
    QDBusInterface ethIfc(NM_DBUS_IFACE, devPath, "org.freedesktop.NetworkManager.Device.Wired", QDBusConnection::systemBus());
    if ( ethIfc.isValid() ) {
        QString mac = ethIfc.property("HwAddress").toString().remove(":");
        if ( mac.length() > 0 )
            return QByteArray(mac.toUtf8());
    }
    return QByteArray();
}

QString DataEngine::getConnectionSettings(const QByteArray& devMac, NMConnectionSettings &connectionSettings)
{
    NMConnectionSettings settings;
    QDBusInterface *ifaceForSettings;

    // Create a D-Bus proxy; NM_DBUS_* defined in NetworkManager.h
    QDBusInterface interface(
                    NM_DBUS_SERVICE,
                    NM_DBUS_PATH_SETTINGS,
                    NM_DBUS_IFACE_SETTINGS,
                    QDBusConnection::systemBus());

    // Get connection list and find the connection with 'connectionUuid'
    QDBusReply<QList<QDBusObjectPath> > result1 = interface.call("ListConnections");

    foreach (const QDBusObjectPath& connection, result1.value()) {
        ifaceForSettings = new QDBusInterface(
                                    NM_DBUS_SERVICE,
                                    connection.path(),
                                    "org.freedesktop.NetworkManager.Settings.Connection",
                                    QDBusConnection::systemBus());
        QDBusReply<NMConnectionSettings> result2 = ifaceForSettings->call("GetSettings");
        delete ifaceForSettings;

        settings = result2.value();
        QVariantMap devSettings = settings.value("802-3-ethernet");
        QByteArray mac = devSettings.value("mac-address").toByteArray();

        // We have saved our device MAC address already in Hex so we do not want
        // to convert that to Hex.
        if ( mac.toHex().toUpper() == devMac.toUpper() ) {
            connectionSettings = settings;
            return connection.path();
        }
    }

    return QString();
}
void DataEngine::saveWiredNetworkSettingsToDevice()
{
    if ( eth.sessionSettings.dhcp_ ) {
        eth.nmConnectionSettings["ipv4"]["method"] = "auto";
    } else {
        NMAddresses addresses;
        NMAddress address;
        address << qToBigEndian(eth.sessionSettings.ip_.toIPv4Address())
                << convertSubnetToMask(eth.sessionSettings.mask_.toIPv4Address()) // Remember we have converted mask to a full IPv4 Subnet Address
                                                                                  // similarly from the user input we have got a complete subnet
                                                                                  // address so we have to convert it back to just mask.
                << qToBigEndian(eth.sessionSettings.route_.toIPv4Address());
        addresses << address;
        eth.nmConnectionSettings["ipv4"]["method"] = "manual";
        eth.nmConnectionSettings["ipv4"]["addresses"] = QVariant::fromValue(addresses);
    }
    // See if we are also updating the DNS IP address.,
    if ( eth.currentSettings.dns_ != eth.sessionSettings.dns_ ) {
        NMAddress dns;
        dns << qToBigEndian(eth.sessionSettings.dns_.toIPv4Address());  // Multiple DNS IPs can be added here as done above for addresses.
                                                                        // but this will remain an array of uints
        eth.nmConnectionSettings["ipv4"]["dns"] = QVariant::fromValue(dns);
    }
    // Now update device settings.
    QDBusInterface setIfc(NM_DBUS_SERVICE, eth.nm_conn_settings_path_, "org.freedesktop.NetworkManager.Settings.Connection", QDBusConnection::systemBus());
    QDBusReply<void> result = setIfc.call("Update", QVariant::fromValue(eth.nmConnectionSettings));
    if ( result.isValid() ) {
        // Deactivate connection first.
        QDBusInterface devIfc(NM_DBUS_SERVICE, eth.nm_dev_path_, "org.freedesktop.NetworkManager.Device", QDBusConnection::systemBus());
        if ( devIfc.isValid() ) {
            devIfc.call("Deactivate");
            // TODO: Instead of waiting for 3 seconds, make it event based.
            sleep(3);
            QDBusInterface nmIfc(NM_DBUS_SERVICE, NM_DBUS_PATH, "org.freedesktop.NetworkManager", QDBusConnection::systemBus());
            if ( nmIfc.isValid() ) {
                QList<QVariant> arguments;
#ifdef UBUNTU_13_04
                arguments   << QVariant::fromValue(QDBusObjectPath(eth.nm_conn_settings_path_))
                            << QVariant::fromValue(QDBusObjectPath(eth.nm_dev_path_))
                            << QVariant::fromValue(QDBusObjectPath("/"));

#endif // UBUNTU_13_04
                QDBusMessage reply = nmIfc.callWithArgumentList(QDBus::Block, "ActivateConnection", arguments);
                if ( reply.type() == QDBusMessage::ErrorMessage ) {
                    qDebug () << "Unable to activate ethernet connection with updated networking configuration. Error = " << nmIfc.lastError().message();
                }
            }
        }
    } else {
        qDebug() << QString("Error: could not update connection: %1 - %2").arg(result.error().name()).arg(result.error().message());
    }
}

void DataEngine::extractNetworkPropertiesFromString(const QString &property, QHostAddress &ip, QHostAddress &mask, QHostAddress &router)
{
    int startindex = 0;
    int endindex = 0;
    for ( int i = 0; i < property.size(); i++ ) {
        if ( i < (property.size() - 2) ) {
            if ( property.at(i) == '{' && property.at(i+1) != '[' ) {
                startindex = i + 1;
            }
            if ( property.at(i) == '}' )
                endindex = (i - 2);
        }
    }
    QString information = property.mid(startindex, (endindex - startindex));
    QString uip = information.section(',', 0, 0, QString::SectionSkipEmpty);
    QString umask = information.section(',', 1, 1, QString::SectionSkipEmpty);
    QString urouter = information.section(',', 2, 2, QString::SectionSkipEmpty);

    ip.setAddress(qToBigEndian(uip.trimmed().toUInt()));
    mask.setAddress(0xFFFFFFFF << (32 - umask.trimmed().toUInt()));
    router.setAddress(qToBigEndian(urouter.trimmed().toUInt()));
}
void DataEngine::extractNetworkPropertiesFromString(const QString &property, QHostAddress &ip)
{
    int startindex = 0;
    int endindex = 0;
    for ( int i = 0; i < property.size(); i++ ) {
        if ( i < (property.size() - 2) ) {
            if ( property.at(i) == '{' && property.at(i+1) != '[' ) {
                startindex = i + 1;
            }
            if ( property.at(i) == '}' )
                endindex = i;
        }
    }
    QString information = property.mid(startindex, (endindex - startindex));
    QString uip = information.section(',', 0, 0, QString::SectionSkipEmpty);

    ip.setAddress(qToBigEndian(uip.trimmed().toUInt()));
}
QString DataEngine::getCompleteIpAddString(QString string_)
{
    QString tuple1 = string_.section('.', 0, 0);
    QString tuple2 = string_.section('.', 1, 1);
    QString tuple3 = string_.section('.', 2, 2);
    QString tuple4 = string_.section('.', 3, 3);

    if ( tuple1.length() == 1 ) tuple1.insert(0, "00"); else if ( tuple1.length() == 2 ) tuple1.insert(0, "0");
    if ( tuple2.length() == 1 ) tuple2.insert(0, "00"); else if ( tuple2.length() == 2 ) tuple2.insert(0, "0");
    if ( tuple3.length() == 1 ) tuple3.insert(0, "00"); else if ( tuple3.length() == 2 ) tuple3.insert(0, "0");
    if ( tuple4.length() == 1 ) tuple4.insert(0, "00"); else if ( tuple4.length() == 2 ) tuple4.insert(0, "0");

    return (tuple1 + "." + tuple2 + "." + tuple3 + "." + tuple4);
}
quint32 DataEngine::convertSubnetToMask(const quint32 subnet)
{
    for ( int i = 0; i <= 32; i++ ) {
        if ( ((2 << i ) - 1) == ~(subnet) ) {
            return(32 - (i+1));
        }
    }
    return 0;
}
