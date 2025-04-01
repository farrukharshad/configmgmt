// Copyright 2012

// dataengine.h
// Declares class which is responsible for all application data
// handling & processing. This is implemented using Singleton pattern.
// This does not directly communicate with GUI / QML rather, whenever
// it needs some data or value to be updated on GUI it send signal
// "dataChanged" to GUIEngine class

#ifndef SOUNDENGINE_H
#define SOUNDENGINE_H

#include <QAbstractListModel>
#include <QObject>
#include <pulse/pulseaudio.h>

class SoundOutputModel : public QAbstractListModel {
    Q_OBJECT
    enum {
        MODEL_ROLE_SOUND_OUTPUT_NAME = Qt::UserRole + 2
    };
public:
    SoundOutputModel(QList<QString> outputs) : outputNames(outputs) { insertRows(0, outputs.count(), QModelIndex()); }
    // -------- OVERRIDES ------------
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    bool insertRows(int row, int count, const QModelIndex &parent);
    bool removeRows(int row, int count, const QModelIndex &parent);
private:
    QList<QString> outputNames;
};

/* This is singlelton class */
class SoundEngine : public QObject
{
    Q_OBJECT
public: // PulseAudio Callback Functions
    static void contextStateCallbackInit(pa_context *context, void *userdata);
    static void contextStateCallback(pa_context *context, void *userdata);
    static void sinkInfoCallback(pa_context *context, const pa_sink_info *info, int isLast, void *userdata);
    static void setDefaultSinkCallback(pa_context *c, int success, void *userdata);
    static void serverInfoCallback(pa_context *context, const pa_server_info *info, void *userdata);
public:
    explicit SoundEngine();
    ~SoundEngine();
    bool initialize();
    pa_threaded_mainloop *getMainLoop() { return mainLoop; }
    void addSinkName(const QString &name) { sinks.append(name); }
    void addSinkReadableName(const QString &name) { sinkReadableNames.append(name); }
    void setSoundOutputSource(int index);
    void setCurrentSoundOutputSourceReadableName(const QString &name);
    QString getCurrentSoundOutputSourceReadableName() const { return currentDefaultSinkName; }
    int getSinksCount() const { return sinks.count(); }
    QList<QString> getAllSinkReadableNames() const { return sinkReadableNames; }
    SoundOutputModel *getSoundOutputsModel() const { return outputModel; }
private slots:
    void updateChangedSoundOutput();
signals:
    void soundOutputChanged();
    void updateSoundOutputGui();
private:
    void getSinksInformation();
    void getServerInformation();
private:
    bool initialized;
    pa_mainloop_api *mainLoopApi;
    pa_threaded_mainloop *mainLoop;
    pa_context *context;
    QList<QString> sinks;
    QList<QString> sinkReadableNames;
    QString currentDefaultSinkName;
public:
    SoundOutputModel *outputModel;
};

#endif // SOUNDENGINE_H
