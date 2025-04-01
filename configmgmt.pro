# Add more folders to ship with the application, here
folder_01.source = qml
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xEE2BBAAB

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# Following macro will enforce all the strings should be covered by
# tr call, for our translation to work.
DEFINE += QT_NO_CAST_FROM_ASCII
# DEFINE += UBUNTU_13_04

QT += dbus-private xml

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES +=  cpp/src/main.cpp                \
            cpp/src/guiengine.cpp           \
            cpp/src/guistrings.cpp          \
            cpp/src/dataengine.cpp          \
            cpp/src/wifinetworks.cpp        \
            cpp/src/soundengine.cpp

HEADERS +=  cpp/inc/guiengine.h             \
            cpp/inc/dataengine.h            \
            cpp/inc/guistrings.h            \
            cpp/inc/extern_defs.h           \
            cpp/inc/wifinetworks.h          \
            cpp/inc/types.h                 \
            cpp/inc/soundengine.h

INCLUDEPATH += cpp/inc
LIBS += -lXrandr -lX11 -lpulse

# Qt Libs
# libstdc++.so.6
# libgobject-2.0.so.0
# libglib-2.0.so.0
# libX11
# libgthread
# libXext
# libpcre
# libxcb
# libXau
# libXdmcp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

RESOURCES += \
    res/resources.qrc

OTHER_FILES += \
    qml/screens/language.qml \
    qml/screens/netsettings.qml \
    installer.txt \
    qml/components/CustomTextInput.qml \
    qml/components/WifiAuthentication.qml \
    qml/components/WifiAuth.qml
