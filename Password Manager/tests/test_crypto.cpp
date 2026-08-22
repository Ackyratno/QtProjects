#include <gtest/gtest.h>
#include "security/CryptoService.h"
#include <QString>
#include <QByteArray>
#include <stdexcept>

// 1. Тест Roundtrip: шифрование и дешифрование возвращают исходный текст
TEST(CryptoServiceTest, EncryptDecryptRoundtrip) {
    const QByteArray plainData = "SuperSecretPassword123!@#_Secure_Vault";
    const QByteArray key = CryptoService::generateRandomBytes(32);
    const QByteArray iv = CryptoService::generateRandomBytes(16);

    // Шифруем
    const QByteArray cipherData = CryptoService::encrypt(plainData, key, iv);

    // Зашифрованные данные не должны быть пустыми и не должны равняться открытому тексту
    EXPECT_FALSE(cipherData.isEmpty());
    EXPECT_NE(cipherData, plainData);

    // Расшифровываем
    const QByteArray decryptedData = CryptoService::decrypt(cipherData, key, iv);

    // Расшифрованные данные должны побайтово совпадать с оригиналом
    EXPECT_EQ(decryptedData, plainData);
}

// 2. Тест уникальности IV: при одинаковых данных и ключе разные IV дают разный шифротекст
TEST(CryptoServiceTest, DifferentIVProducesDifferentCiphertext) {
    const QByteArray plainData = "SameDataToBeEncryptedTwice";
    const QByteArray key = CryptoService::generateRandomBytes(32);

    const QByteArray iv1 = CryptoService::generateRandomBytes(16);
    const QByteArray iv2 = CryptoService::generateRandomBytes(16);

    const QByteArray cipher1 = CryptoService::encrypt(plainData, key, iv1);
    const QByteArray cipher2 = CryptoService::encrypt(plainData, key, iv2);

    EXPECT_NE(iv1, iv2);
    EXPECT_NE(cipher1, cipher2);

    // Оба должны корректно расшифровываться со своими IV в исходный текст
    EXPECT_EQ(CryptoService::decrypt(cipher1, key, iv1), plainData);
    EXPECT_EQ(CryptoService::decrypt(cipher2, key, iv2), plainData);
}

// 3. Тест защиты от неверного ключа: дешифрование с чужим ключом должно бросать исключение
TEST(CryptoServiceTest, DecryptWithWrongKeyThrowsException) {
    const QByteArray plainData = "TopSecretAccountCredentials";
    const QByteArray keyA = CryptoService::generateRandomBytes(32);
    const QByteArray keyB = CryptoService::generateRandomBytes(32);
    const QByteArray iv = CryptoService::generateRandomBytes(16);

    const QByteArray cipherData = CryptoService::encrypt(plainData, keyA, iv);

    // Попытка расшифровать чужим ключом keyB обязана выбросить исключение
    EXPECT_THROW(CryptoService::decrypt(cipherData, keyB, iv), std::runtime_error);
}

// 4. Тест влияния неверного IV: в AES-CBC неверный IV искажает расшифрованные данные (первый блок)
TEST(CryptoServiceTest, DecryptWithWrongIVCorruptsData) {
    const QByteArray plainData = "TopSecretAccountCredentials1234567890";
    const QByteArray key = CryptoService::generateRandomBytes(32);
    const QByteArray iv1 = CryptoService::generateRandomBytes(16);
    const QByteArray iv2 = CryptoService::generateRandomBytes(16);

    const QByteArray cipherData = CryptoService::encrypt(plainData, key, iv1);

    // В AES-CBC неверный IV побитово искажает первый блок расшифрованного текста
    const QByteArray corruptedDecrypted = CryptoService::decrypt(cipherData, key, iv2);
    EXPECT_NE(corruptedDecrypted, plainData);
}

// 5. Тест деривации ключа PBKDF2: детерминированность генерации
TEST(CryptoServiceTest, PBKDF2Deterministic) {
    const QString password = "MasterUserPassword2026!";
    const QByteArray salt = CryptoService::generateRandomBytes(16);

    const QByteArray key1 = CryptoService::deriveKey(password, salt, 10000);
    const QByteArray key2 = CryptoService::deriveKey(password, salt, 10000);

    // Размер ключа строго 32 байта (256 бит)
    EXPECT_EQ(key1.size(), 32);
    EXPECT_EQ(key2.size(), 32);

    // Один и тот же пароль и соль всегда дают абсолютно одинаковый ключ
    EXPECT_EQ(key1, key2);
}

// 6. Тест влияния соли на PBKDF2: разная соль дает разные ключи
TEST(CryptoServiceTest, PBKDF2DifferentSaltProducesDifferentKey) {
    const QString password = "MasterUserPassword2026!";
    const QByteArray salt1 = CryptoService::generateRandomBytes(16);
    const QByteArray salt2 = CryptoService::generateRandomBytes(16);

    const QByteArray key1 = CryptoService::deriveKey(password, salt1, 10000);
    const QByteArray key2 = CryptoService::deriveKey(password, salt2, 10000);

    EXPECT_NE(key1, key2);
}

// 7. Тест генератора случайных байт: размеры и случайность
TEST(CryptoServiceTest, GenerateRandomBytes) {
    const QByteArray bytes16 = CryptoService::generateRandomBytes(16);
    const QByteArray bytes32 = CryptoService::generateRandomBytes(32);

    EXPECT_EQ(bytes16.size(), 16);
    EXPECT_EQ(bytes32.size(), 32);

    const QByteArray bytes16_second = CryptoService::generateRandomBytes(16);
    EXPECT_NE(bytes16, bytes16_second);

    // Проверка граничных случаев (невалидные размеры)
    EXPECT_TRUE(CryptoService::generateRandomBytes(0).isEmpty());
    EXPECT_TRUE(CryptoService::generateRandomBytes(-5).isEmpty());
}

// 8. Тест валидации размеров ключа и IV в encrypt и decrypt
TEST(CryptoServiceTest, InvalidKeyOrIVSizeThrowsException) {
    const QByteArray plainData = "SomeData";
    const QByteArray validKey = CryptoService::generateRandomBytes(32);
    const QByteArray invalidKey = CryptoService::generateRandomBytes(16); // 16 вместо 32
    const QByteArray validIv = CryptoService::generateRandomBytes(16);
    const QByteArray invalidIv = CryptoService::generateRandomBytes(8);   // 8 вместо 16

    EXPECT_THROW(CryptoService::encrypt(plainData, invalidKey, validIv), std::invalid_argument);
    EXPECT_THROW(CryptoService::encrypt(plainData, validKey, invalidIv), std::invalid_argument);

    const QByteArray cipherData = CryptoService::encrypt(plainData, validKey, validIv);
    EXPECT_THROW(CryptoService::decrypt(cipherData, invalidKey, validIv), std::invalid_argument);
    EXPECT_THROW(CryptoService::decrypt(cipherData, validKey, invalidIv), std::invalid_argument);
}
