#pragma once
#include <QByteArray>
#include <QString>

class CryptoService {
public:
  static QByteArray deriveKey(const QString &masterPassword,
                              const QByteArray &salt, int iterations = 100000);
  static QByteArray encrypt(const QByteArray &plainData, const QByteArray &key,
                            const QByteArray &iv);
  static QByteArray decrypt(const QByteArray &cipherData, const QByteArray &key,
                            const QByteArray &iv);
  static QByteArray generateRandomBytes(int length);
};