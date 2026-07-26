cmake_minimum_required(VERSION 3.16)

project(ToDoList VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appToDoList
    src/main.cpp
    src/todomodel.cpp
    src/todomodel.h
)

qt_add_qml_module(appToDoList
    URI ToDoList
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/components/TodoDelegate.qml
    RESOURCES
        qml/icons/sun.svg
        qml/icons/moon.svg
)

target_link_libraries(appToDoList
    PRIVATE Qt6::Quick
)

set_target_properties(appToDoList PROPERTIES OUTPUT_NAME "ToDoListApp")

