#include "CryptoService.h"
#include <openssl/evp.h>
#include <openssl/rand.h>
#include <qnamespace.h>
#include <stdexcept>

// Генерация 32-байтного ключа из пароля и соли
QByteArray CryptoService::deriveKey(const QString &masterPassword,
                                    const QByteArray &salt, int iterations) {

  const QByteArray password = masterPassword.toUtf8();

  QByteArray buff(32, Qt::Uninitialized);

  // Вызываем PBKDF2 с 100 000 итерациями SHA-256
  if (PKCS5_PBKDF2_HMAC(
          password.constData(), password.size(),
          reinterpret_cast<const unsigned char *>(salt.constData()),
          salt.size(), iterations, EVP_sha256(), buff.size(),
          reinterpret_cast<unsigned char *>(buff.data())) != 1) {
    throw std::runtime_error("Failed to derive key via PBKDF2");
  }

  return buff;
}

// Шифрование данных алгоритмом AES-256-CBC
QByteArray CryptoService::encrypt(const QByteArray &plainData,
                                  const QByteArray &key, const QByteArray &iv) {

  if (key.size() != 32 || iv.size() != 16) {
    throw std::invalid_argument("Invalid key or IV size for AES-256-CBC");
  }

  EVP_CIPHER_CTX *ciph = EVP_CIPHER_CTX_new();
  if (ciph == nullptr) {
    throw std::runtime_error("Failed to create OpenSSL EVP cipher context");
  }

  const EVP_CIPHER *cipher = EVP_aes_256_cbc();

  // Инициализируем шифратор алгоритмом AES-256-CBC, ключом и вектором IV
  if (EVP_EncryptInit_ex(
          ciph, cipher, nullptr,
          reinterpret_cast<const unsigned char *>(key.constData()),
          reinterpret_cast<const unsigned char *>(iv.constData())) != 1) {
    EVP_CIPHER_CTX_free(ciph);
    throw std::runtime_error("Failed to initialize AES-256-CBC encryption");
  }

  // Выделяем память под зашифрованные данные
  QByteArray cipherText(plainData.size() + 16, Qt::Uninitialized);

  int len1 = 0;
  // Шифруем основные блоки данных
  if (EVP_EncryptUpdate(
          ciph, reinterpret_cast<unsigned char *>(cipherText.data()), &len1,
          reinterpret_cast<const unsigned char *>(plainData.constData()),
          plainData.size()) != 1) {
    EVP_CIPHER_CTX_free(ciph);
    throw std::runtime_error("Encryption failed during EVP_EncryptUpdate");
  };

  int len2 = 0;
  if (EVP_EncryptFinal_ex(
          ciph, reinterpret_cast<unsigned char *>(cipherText.data()) + len1,
          &len2) != 1) {
    EVP_CIPHER_CTX_free(ciph);
    throw std::runtime_error("Encryption failed during EVP_EncryptFinal_ex");
  };

  EVP_CIPHER_CTX_free(ciph);

  cipherText.resize(len1 + len2);
  return cipherText;
}

QByteArray CryptoService::decrypt(const QByteArray &cipherData,
                                  const QByteArray &key, const QByteArray &iv) {

  if (key.size() != 32 || iv.size() != 16) {
    throw std::invalid_argument("Invalid key or IV size for AES-256-CBC");
  }

  // Создаем контекст OpenSSL
  EVP_CIPHER_CTX *ciph = EVP_CIPHER_CTX_new();
  if (ciph == nullptr) {
    throw std::runtime_error("Failed to create OpenSSL EVP cipher context");
  }

  const EVP_CIPHER *cipher = EVP_aes_256_cbc();

  if (EVP_DecryptInit_ex(
          ciph, cipher, nullptr,
          reinterpret_cast<const unsigned char *>(key.constData()),
          reinterpret_cast<const unsigned char *>(iv.constData())) != 1) {
    EVP_CIPHER_CTX_free(ciph);
    throw std::runtime_error("Failed to initialize AES-256-CBC decryption");
  };

  int len1 = 0;
  QByteArray buff(cipherData.size() + 16, Qt::Uninitialized);
  if (EVP_DecryptUpdate(
          ciph, reinterpret_cast<unsigned char *>(buff.data()), &len1,
          reinterpret_cast<const unsigned char *>(cipherData.constData()),
          cipherData.size()) != 1) {
    EVP_CIPHER_CTX_free(ciph);
    throw std::runtime_error("Decryption failed during EVP_DecryptUpdate");
  };

  int len2 = 0;
  if (EVP_DecryptFinal_ex(ciph,
                          reinterpret_cast<unsigned char *>(buff.data()) + len1,
                          &len2) != 1) {
    EVP_CIPHER_CTX_free(ciph);
    throw std::runtime_error(
        "Decryption failed: invalid key or corrupted data");
  }

  EVP_CIPHER_CTX_free(ciph);

  buff.resize(len1 + len2);
  return buff;
}

// Генерация криптографически стойких случайных байт (для соли и IV)
QByteArray CryptoService::generateRandomBytes(int length) {
  if (length <= 0) {
    return QByteArray();
  }

  QByteArray buffer(length, Qt::Uninitialized);

  if (RAND_bytes(reinterpret_cast<unsigned char *>(buffer.data()), length) !=
      1) {
    throw std::runtime_error(
        "Failed to generate random bytes: RAND_bytes error");
  }

  return buffer;
}