import 'package:encrypt/encrypt.dart';

const encryptKey = 'abcdefghijklmnopqrstuvwxyz196161';

extension EncryptExtension on String {
  String get encryptString {
    final key = Key.fromUtf8(encryptKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(this, iv: iv);
    return encrypted.base64;
  }

  String get decryptString {
    final key = Key.fromUtf8(encryptKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt64(this, iv: iv);
    return decrypted;
  }
}
