cmake_minimum_required(VERSION 3.16)

project(ImageGallery VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appImageGallery
    main.cpp
    cpp/models/ImageGalleryModel.cpp
    cpp/models/ImageGalleryModel.h
)

set_source_files_properties(qml/themes/Style.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appImageGallery
    URI ImageGallery
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/themes/Style.qml
        qml/pages/GalleryPage.qml
        qml/components/ImageCardDelegate.qml
)

target_link_libraries(appImageGallery
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appImageGallery
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
