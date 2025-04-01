// Copyright 2012

// guiengine.h
// Declares class which is responsible for all the GUI frontend handling
// & update. This implements Singleton pattern.

#ifndef GUIENGINE_H
#define GUIENGINE_H

#include <QString>
#include <QObject>
#include <QThread>
#include <QDeclarativeView>
#include "dataengine.h"
#include "guistrings.h"

class GUIEngine : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE void ExitApplication(int status);
    Q_INVOKABLE void ChangeCurrentPage(QString page);
    //Q_INVOKABLE void SetFuncAsPlayer(bool player) { dataEngine->setSystemFunctionalityAsPlayer(player); }
    Q_PROPERTY(QString currentpage READ openPage NOTIFY changeCurrentPage)
public:
    static GUIEngine* instance(GUIStrings *stringsEngine, DataEngine *dataEngine);
    ~GUIEngine();
    void setViewObject(QDeclarativeView *view) { appView = view;}
    DataEngine* getDataModel() const { return dataEngine; }
    WifiNetworks *getWifiNetworksModel() const { return dataEngine->getWifiNetworksList(); }
signals:
    void changeCurrentPage();
public:
    QString openPage() const { return currentPage; }
private:
    explicit GUIEngine() {}
    explicit GUIEngine(GUIStrings *stringsEngine, DataEngine *dataEngine);
    static GUIEngine *engineInstance;
    GUIEngine(const GUIEngine&);
    GUIEngine& operator= (const GUIEngine&);
private:
    QDeclarativeView *appView;
    DataEngine *dataEngine;
    GUIStrings *stringsEngine;
    QString currentPage;
};

#endif // GUIENGINE_H
