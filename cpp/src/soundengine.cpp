// Copyright 2012

#include "soundengine.h"
#include <QDebug>

//=============================================================================
//      P U L S E    A U D I O    C A L L B A C K S
//=============================================================================
void SoundEngine::contextStateCallbackInit(pa_context *context, void *userdata)
{
    SoundEngine *engine = reinterpret_cast<SoundEngine*>(userdata);
    pa_threaded_mainloop_signal(engine->getMainLoop(), 0);
}
void SoundEngine::contextStateCallback(pa_context *context, void *userdata)
{
}
void SoundEngine::sinkInfoCallback(pa_context *context, const pa_sink_info *info, int last, void *userdata)
{
    SoundEngine *engine = reinterpret_cast<SoundEngine*>(userdata);
    if ( last < 0 ) {
        qDebug () << "Error occurred while getting sound output devices list";
        engine->initialized = false;
    }
    if ( last ) {
        if ( engine->outputModel == NULL ) {
            engine->outputModel = new SoundOutputModel(engine->getAllSinkReadableNames());
        }
        pa_threaded_mainloop_signal(engine->getMainLoop(), 0);
        return;
    }
    if ( info != NULL ) {
        engine->addSinkReadableName(info->description);
        engine->addSinkName(info->name);
    }
}
void SoundEngine::serverInfoCallback(pa_context *context, const pa_server_info *info, void *userdata)
{
    SoundEngine *engine = reinterpret_cast<SoundEngine*>(userdata);
    if ( info != NULL ) {
        engine->setCurrentSoundOutputSourceReadableName(info->default_sink_name);
    }
    pa_threaded_mainloop_signal(engine->getMainLoop(), 0);
    engine->updateSoundOutputGui();
}

void SoundEngine::setDefaultSinkCallback(pa_context *c, int success, void *userdata)
{
    SoundEngine *engine = reinterpret_cast<SoundEngine*>(userdata);
    pa_threaded_mainloop_signal(engine->getMainLoop(), 0);

    if ( success ) {
        engine->soundOutputChanged();
    }
}

//=============================================================================
//      C L A S S    D E F I N I T I O N
//=============================================================================
SoundEngine::SoundEngine() :
    initialized(false),
    mainLoopApi(NULL),
    mainLoop(NULL),
    context(NULL),
    outputModel(NULL)
{
    QObject::connect(this, SIGNAL(soundOutputChanged()), this, SLOT(updateChangedSoundOutput()));
}
SoundEngine::~SoundEngine()
{
    if ( initialized ) {
        if ( outputModel != NULL ) {
            delete outputModel;
            outputModel = NULL;
        }
        if ( context ) {
            pa_threaded_mainloop_lock(mainLoop);
            pa_context_disconnect(context);
            pa_threaded_mainloop_unlock(mainLoop);
            context = NULL;
        }
        if ( mainLoop ) {
            pa_threaded_mainloop_stop(mainLoop);
            pa_threaded_mainloop_free(mainLoop);
            mainLoop = NULL;
        }
    }
}

bool SoundEngine::initialize()
{
    if ( !initialized ) {
        initialized = true;
        mainLoop = pa_threaded_mainloop_new();
        if ( mainLoop == NULL ) {
            qDebug () << "Error creating PulseAudio main loop";
            initialized = false;
            return initialized;
        }
        if ( pa_threaded_mainloop_start(mainLoop) != 0 ) {
            qDebug () << "Error starting PulseAudio main loop";
            initialized = false;
            pa_threaded_mainloop_free(mainLoop);
            return initialized;
        }

        mainLoopApi = pa_threaded_mainloop_get_api(mainLoop);
        pa_threaded_mainloop_lock(mainLoop);
        context = pa_context_new(mainLoopApi, "configmgmt");
        pa_context_set_state_callback(context, contextStateCallbackInit, this);
        if ( context == NULL ) {
            qDebug () << "Error creating PulseAudio Context";
            pa_threaded_mainloop_free(mainLoop);
            initialized = false;
            return initialized;
        }
        if ( pa_context_connect(context, NULL, (pa_context_flags_t)0, NULL) < 0 ) {
            qDebug () << "Error creating context connection";
            pa_context_unref(context);
            pa_threaded_mainloop_free(mainLoop);
            initialized = false;
            return initialized;
        }
        pa_threaded_mainloop_wait(mainLoop);
        bool waiting = true;
        while ( waiting ) {
            switch(pa_context_get_state(context)) {
            case PA_CONTEXT_CONNECTING:
            case PA_CONTEXT_AUTHORIZING:
            case PA_CONTEXT_SETTING_NAME:
                break;
            case PA_CONTEXT_READY:
                waiting = false;
                break;
            case PA_CONTEXT_TERMINATED:
                qDebug () << "Error. PulseAudio context terminated";
                initialized = false;
                waiting = false;
                break;
            case PA_CONTEXT_FAILED:
            default:
                qDebug () << QString("Error. PulseAudio context failed. Error %1").arg(pa_strerror(pa_context_errno(context)));
                initialized = false;
                waiting = false;
                break;
            }
            if ( waiting )
                pa_threaded_mainloop_wait(mainLoop);
        }
        if ( initialized ) {
            pa_context_set_state_callback(context, contextStateCallback, this);
        } else {
            if ( context ) {
                pa_context_unref(context);
                context = 0;
            }
        }
        pa_threaded_mainloop_unlock(mainLoop);
        if ( initialized ) {
            getSinksInformation();
            getServerInformation();
        }
    }
    return initialized;
}
void SoundEngine::getSinksInformation()
{
    if ( initialized ) {
        pa_operation *op;
        pa_threaded_mainloop_lock(mainLoop);
        op = pa_context_get_sink_info_list(context, sinkInfoCallback, this);
        while ( pa_operation_get_state(op) == PA_OPERATION_RUNNING )
            pa_threaded_mainloop_wait(mainLoop);
        pa_operation_unref(op);
        pa_threaded_mainloop_unlock(mainLoop);
    }
}
void SoundEngine::getServerInformation()
{
    if ( initialized ) {
        pa_operation *op;
        pa_threaded_mainloop_lock(mainLoop);
        op = pa_context_get_server_info(context, serverInfoCallback, this);
        while ( pa_operation_get_state(op) == PA_OPERATION_RUNNING )
            pa_threaded_mainloop_wait(mainLoop);
        pa_operation_unref(op);
        pa_threaded_mainloop_unlock(mainLoop);
    }
}
void SoundEngine::setSoundOutputSource(int idx)
{
    if ( initialized ) {
        pa_operation *op;
        pa_threaded_mainloop_lock(mainLoop);
        op = pa_context_set_default_sink(context, sinks.at(idx).toStdString().c_str(), setDefaultSinkCallback, this);
        while ( pa_operation_get_state(op) == PA_OPERATION_RUNNING )
            pa_threaded_mainloop_wait(mainLoop);
        pa_operation_unref(op);
        pa_threaded_mainloop_unlock(mainLoop);
    }
}
void SoundEngine::setCurrentSoundOutputSourceReadableName(const QString &name_)
{
    for ( int i = 0; i < sinks.count(); i++ ) {
        if ( sinks.at(i) == name_ ) {
            currentDefaultSinkName = sinkReadableNames.at(i);
            break;
        }
    }
}
void SoundEngine::updateChangedSoundOutput()
{
    if ( initialized ) {
        getServerInformation();
    }
}
// ----------------------------------------------------------------------------
//          O V E R R I D E S
// ----------------------------------------------------------------------------
QHash<int, QByteArray> SoundOutputModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[MODEL_ROLE_SOUND_OUTPUT_NAME]  = "sound_output";
    return roles;
}
int SoundOutputModel::rowCount(const QModelIndex &parent) const
{
    return outputNames.count();
}
QVariant SoundOutputModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (index.row() >= outputNames.count())
        return QVariant();

    // Return data as per role
    switch(role) {
    case MODEL_ROLE_SOUND_OUTPUT_NAME:
        return QString(outputNames.at(index.row()));
    default:
        return QVariant();
    }
    return QVariant();
}
bool SoundOutputModel::insertRows(int row, int count, const QModelIndex &parent)
{
    if ( parent.isValid() )
        return false;
    beginInsertRows(parent, row, count);
    endInsertRows();
    return true;
}
bool SoundOutputModel::removeRows(int row, int count, const QModelIndex &parent)
{
    beginRemoveRows(parent, row, count);
    endRemoveRows();
    return true;
}
