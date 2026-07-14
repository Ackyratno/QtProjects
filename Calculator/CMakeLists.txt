cmake_minimum_required(VERSION 3.16)

project(Calculator VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

# Называем наш исполняемый файл CalculatorApp, чтобы не было конфликта 
# с папкой QML-модуля (которая тоже называется Calculator)
qt_add_executable(CalculatorApp
    main.cpp
    calculatorbackend.h
    calculatorbackend.cpp
)

qt_add_qml_module(CalculatorApp
    URI Calculator
    VERSION 1.0
    QML_FILES Main.qml CalcButton.qml
)

set_target_properties(CalculatorApp PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.Calculator
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(CalculatorApp
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS CalculatorApp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
