#ifndef EXTERN_DEFS_H
#define EXTERN_DEFS_H

#define NETWORK_DEVICE_CONNECTED        8
#define NETWORK_DEVICE_DISCONNECTED     2

// Following constants are taken from NetworkManager.h
#define NM_DBUS_SERVICE             "org.freedesktop.NetworkManager"
#define NM_DBUS_PATH    "/org/freedesktop/NetworkManager"
#define NM_DBUS_IFACE   "org.freedesktop.NetworkManager"
#define NM_DBUS_PATH_SETTINGS       "/org/freedesktop/NetworkManager/Settings"
#define NM_DBUS_IFACE_SETTINGS      "org.freedesktop.NetworkManager.Settings"
#define NM_DEVICE_TYPE_ETHERNET 1
#define NM_DEVICE_TYPE_WIFI 2
#if 1
#define NM_DEVICE_STATE_UNKNOWN             0
#define NM_DEVICE_STATE_UNMANAGED           10
#define NM_DEVICE_STATE_UNAVAILABLE         20
#define NM_DEVICE_STATE_DISCONNECTED        30
#define NM_DEVICE_STATE_PREPARE             40
#define NM_DEVICE_STATE_CONFIG              50
#define NM_DEVICE_STATE_NEED_AUTH           60
#define NM_DEVICE_STATE_IP_CONFIG           70
#define NM_DEVICE_STATE_IP_CHECK            80
#define NM_DEVICE_STATE_SECONDARIES         90
#define NM_DEVICE_STATE_ACTIVATED           100
#define NM_DEVICE_STATE_DEACTIVATING        110
#define NM_DEVICE_STATE_FAILED              120
#else
#define NM_DEVICE_STATE_UNKNOWN             0
#define NM_DEVICE_STATE_UNMANAGED           1
#define NM_DEVICE_STATE_UNAVAILABLE         2
#define NM_DEVICE_STATE_DISCONNECTED        3
#define NM_DEVICE_STATE_PREPARE             4
#define NM_DEVICE_STATE_CONFIG              5
#define NM_DEVICE_STATE_NEED_AUTH           6
#define NM_DEVICE_STATE_IP_CONFIG           7
#define NM_DEVICE_STATE_IP_CHECK            8
#define NM_DEVICE_STATE_SECONDARIES         9
#define NM_DEVICE_STATE_ACTIVATED           10
#define NM_DEVICE_STATE_DEACTIVATING        11
#define NM_DEVICE_STATE_FAILED              12
#endif

#define XRNDR_LANDSCAPE_ORIENTITATION 1
#define XRNDR_PORTRAIT_ORIENTITATION 2

#endif // EXTERN_DEFS_H
