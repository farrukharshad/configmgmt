#ifndef TYPES_H
#define TYPES_H

#include <QtNetwork/QHostAddress>
#include <QtDBus/QDBusMetaType>
#include <QtCore/QMetaProperty>

typedef QMap<QString, QMap<QString, QVariant> > NMConnectionSettings;
typedef QList<QList<uint> >                     NMAddresses;
typedef QList<uint>                             NMAddress;
//typedef QMap<QString, QMap<QString, QVariant> > Connection;
//Q_DECLARE_METATYPE(Connection)

// This class represents current network settings
// for wired network.
typedef class _wired_net_settings {
public:
    QHostAddress ip_;
    QHostAddress mask_;
    QHostAddress route_;
    QHostAddress dns_;
    bool         dhcp_;
    bool         auto_dns_;
    _wired_net_settings() : ip_(""), mask_(""), route_(""), dns_(""), dhcp_(true), auto_dns_(true) { }
    inline bool operator!=(const _wired_net_settings &right) {
        if ( this->ip_ != right.ip_ || this->mask_ != right.mask_ || this->route_ != right.route_ || this->dns_ != right.dns_ ||
             this->dhcp_ != right.dhcp_ || this->auto_dns_ != right.auto_dns_ )
            return true;
        else
            return false;
    }
} WiredNetworkSettings;

typedef class _wired_device {
public:
    WiredNetworkSettings currentSettings;
    WiredNetworkSettings sessionSettings;
    NMConnectionSettings nmConnectionSettings;
    QByteArray mac;
    QString nm_dev_path_;
    QString nm_conn_settings_path_;
    int dev_state_;
    bool settings_modified_;
    _wired_device() : nm_dev_path_(""), nm_conn_settings_path_(""), dev_state_(0), settings_modified_(false) { }
} WiredNetworkDevice;

//// Following types needs to register with QT Meta Type system.
Q_DECLARE_METATYPE(NMConnectionSettings)
Q_DECLARE_METATYPE(NMAddresses)
Q_DECLARE_METATYPE(NMAddress)

class CustomMetaTypes {
public:
    static void registerNMTypesForDBus()
    {
        // Register types with D-Bus
        qDBusRegisterMetaType<NMConnectionSettings>();
        qDBusRegisterMetaType<NMAddresses>();
        qDBusRegisterMetaType<NMAddress>();
    }
};

#endif // TYPES_H
