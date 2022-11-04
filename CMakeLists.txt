cmake_minimum_required(VERSION 3.16)

project(FMathCurve VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS Svg)

qt_add_executable(appFMathCurve
    main.cpp
    images.qrc
)

qt_add_qml_module(appFMathCurve
    URI FMathCurve
    VERSION 1.0
    QML_FILES main.qml 
)

set_target_properties(appFMathCurve PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appFMathCurve
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Svg)

install(TARGETS appFMathCurve
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
