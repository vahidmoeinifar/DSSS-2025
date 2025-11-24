#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>
#include <QtCore/qhash.h>
#include <QtCore/qstring.h>

namespace QmlCacheGeneratedCode {
namespace _0x5f_DSSS_2025_Main_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::TypedFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_DSSS_2025_temp_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::TypedFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_DSSS_2025_MyButton_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::TypedFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_DSSS_2025_MyTextfield_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::TypedFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_DSSS_2025_SpaceLine_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::TypedFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_DSSS_2025_SpaceLine_V_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::TypedFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_DSSS_2025_MyTextfArea_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::TypedFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_DSSS_2025_MyMenu_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::TypedFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    ~Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
    resourcePathToCachedUnit.insert(QStringLiteral("/DSSS_2025/Main.qml"), &QmlCacheGeneratedCode::_0x5f_DSSS_2025_Main_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/DSSS_2025/temp.qml"), &QmlCacheGeneratedCode::_0x5f_DSSS_2025_temp_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/DSSS_2025/MyButton.qml"), &QmlCacheGeneratedCode::_0x5f_DSSS_2025_MyButton_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/DSSS_2025/MyTextfield.qml"), &QmlCacheGeneratedCode::_0x5f_DSSS_2025_MyTextfield_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/DSSS_2025/SpaceLine.qml"), &QmlCacheGeneratedCode::_0x5f_DSSS_2025_SpaceLine_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/DSSS_2025/SpaceLine_V.qml"), &QmlCacheGeneratedCode::_0x5f_DSSS_2025_SpaceLine_V_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/DSSS_2025/MyTextfArea.qml"), &QmlCacheGeneratedCode::_0x5f_DSSS_2025_MyTextfArea_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/DSSS_2025/MyMenu.qml"), &QmlCacheGeneratedCode::_0x5f_DSSS_2025_MyMenu_qml::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.structVersion = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
}

Registry::~Registry() {
    QQmlPrivate::qmlunregister(QQmlPrivate::QmlUnitCacheHookRegistration, quintptr(&lookupCachedUnit));
}

const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appDSSS_2025)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appDSSS_2025))
int QT_MANGLE_NAMESPACE(qCleanupResources_qmlcache_appDSSS_2025)() {
    return 1;
}
