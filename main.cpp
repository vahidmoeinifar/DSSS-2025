#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "DecisionEngine.h"

int main(int argc, char *argv[]) {

    qputenv("QML_XHR_ALLOW_FILE_READ", "1");

    QGuiApplication app(argc, argv);

    qmlRegisterType<DecisionEngine>("GDSS", 1, 0, "DecisionEngine");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:DSSS_2025/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
