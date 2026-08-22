cmake_minimum_required(VERSION 3.16)

project(PasswordManager VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Qt 6 Packages
find_package(Qt6 6.5 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
    QuickLayouts
    Sql
)

# Find OpenSSL for AES-256 and PBKDF2 encryption
find_package(OpenSSL REQUIRED)

qt_standard_project_setup(REQUIRES 6.5)

# Executable target
qt_add_executable(appPasswordManager
    main.cpp
    cpp/security/CryptoService.cpp
)

set_source_files_properties(qml/themes/Theme.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
)

# QML Module definition
qt_add_qml_module(appPasswordManager
    URI PasswordManager
    VERSION 1.0
    RESOURCE_PREFIX "/"
    QML_FILES
        qml/Main.qml
        qml/themes/Theme.qml
)

# Link libraries
target_link_libraries(appPasswordManager
    PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Sql
        OpenSSL::Crypto
)

# Include directories
target_include_directories(appPasswordManager
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/cpp
        ${OPENSSL_INCLUDE_DIR}
)

# ==========================================
# Unit Tests (Google Test)
# ==========================================
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.tar.gz
)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

enable_testing()
add_subdirectory(tests)

