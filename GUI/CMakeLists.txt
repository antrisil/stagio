cmake_minimum_required(VERSION 3.16)

project(GUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_BUILD_TYPE Debug)

find_package(Qt6 REQUIRED COMPONENTS Concurrent)
find_package(Qt6 REQUIRED COMPONENTS Charts Core Gui Qml Quick Sql)
find_package(Qt6 6.2 COMPONENTS Quick SerialBus REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS Sql)
find_library(SOCKETCAN_LIB socketcan)
find_package(Qt6LinguistTools REQUIRED)

qt_standard_project_setup()

qt_add_executable(appGUI
    main.cpp
    dbmanager.h
    dbmanager.cpp
    includes.h
    pcan.h
    pcan.cpp
    timer.cpp
    timer.h
    useractivitydetector.h
    useractivitydetector.cpp
)

qt_add_qml_module(appGUI
    URI GUI
    VERSION 1.0
    QML_FILES Main.qml
    QML_FILES booting.qml
    QML_FILES languages.qml
    QML_FILES metric.qml
    QML_FILES MONITOR.qml
    QML_FILES output.qml
    QML_FILES settings.qml
    QML_FILES standby.qml
    QML_FILES temperature.qml
    QML_FILES grafic.qml
    QML_FILES bypass.qml
)

set_target_properties(appGUI PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appGUI PUBLIC
    Qt::Charts
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::Sql
    Qt::Concurrent
    Qt6::SerialBus
    socketcan
)

install(TARGETS appGUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
