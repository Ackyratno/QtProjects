cmake_minimum_required(VERSION 3.16)

project(NotesApp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Поиск необходимых компонентов Qt 6
find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Sql)

qt_standard_project_setup()

# Создание исполняемого файла приложения
qt_add_executable(appNotesApp
    main.cpp
    cpp/models/Note.h
    cpp/models/NoteModel.h
    cpp/models/NoteModel.cpp
    cpp/repository/INoteRepository.h
    cpp/repository/SqliteNoteRepository.h
    cpp/repository/SqliteRepository.cpp
)

# Каталоги для поиска C++ заголовочных файлов
target_include_directories(appNotesApp PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/models
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/repository
)

set_source_files_properties(qml/themes/Theme.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appNotesApp
    URI NotesApp
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/components/CustomButton.qml
        qml/components/NoteCardDelegate.qml
        qml/pages/NoteListPage.qml
        qml/pages/NoteEditorDialog.qml
        qml/themes/Theme.qml
)

# Линковка библиотек Qt
target_link_libraries(appNotesApp PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Sql
)
