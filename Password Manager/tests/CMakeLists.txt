add_executable(crypto_tests
    test_crypto.cpp
    ${CMAKE_SOURCE_DIR}/cpp/security/CryptoService.cpp
)

target_link_libraries(crypto_tests
    PRIVATE
        GTest::gtest_main
        Qt6::Core
        OpenSSL::Crypto
)

target_include_directories(crypto_tests
    PRIVATE
        ${CMAKE_SOURCE_DIR}/cpp
        ${OPENSSL_INCLUDE_DIR}
)

include(GoogleTest)
gtest_discover_tests(crypto_tests)
