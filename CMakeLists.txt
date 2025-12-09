cmake_minimum_required(VERSION 3.16)

project(DSSS_2025 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)


qt_add_executable(appDSSS_2025
    main.cpp
)

qt_add_qml_module(appDSSS_2025
    URI DSSS_2025
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES decisionengine.h decisionengine.cpp
        RESOURCES scripts/fuse.py
        QML_FILES temp.qml
        QML_FILES MyButton.qml
        QML_FILES MyTextfield.qml
        QML_FILES SpaceLine.qml
        QML_FILES SpaceLine_V.qml
        QML_FILES
        QML_FILES MyMenu.qml
        RESOURCES fonts/FontAwesomeFree-Regular-400.otf fonts/FontAwesomeFree-Solid-900.otf fonts/Roboto-Light.ttf fonts/Roboto-LightItalic.ttf fonts/Roboto-SemiBold.ttf fonts/Roboto-SemiBoldItalic.ttf fonts/Roboto-Thin.ttf fonts/Roboto-ThinItalic.ttf
        RESOURCES icons/open-source.png
        RESOURCES icons/help.png
        RESOURCES icons/about.png icons/exit.png
        QML_FILES About.qml
        RESOURCES scripts/neural.py
        RESOURCES scripts/weighted.py
        RESOURCES scripts/fuzzy.py
        RESOURCES scripts/random_forest.py
        RESOURCES scripts/consensus.py
        QML_FILES MyCombobox.qml
        QML_FILES MyTextfArea.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appDSSS_2025 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appDSSS_2025
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appDSSS_2025
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appDSSS_2025
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
