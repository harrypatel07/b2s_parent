import 'dart:convert';

import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncrypteService {
  static final _iv = IV.fromLength(16);

  ///Khởi tạo khóa encrypt
  static Encrypter _encryptInit() {
    final key =
            Key.fromUtf8(md5.convert(utf8.encode(superKeyEncrypt)).toString()),
        //b64key = Key.fromUtf8(base64Url.encode(key.bytes)),
        //fernet = Fernet(b64key),
        encrypter = Encrypter(AES(key));
    return encrypter;
  }

  static Encrypted encrypt(String strText) {
    var encrypter = _encryptInit();
    return encrypter.encrypt(strText, iv: _iv);
  }

  static String decrypt(Encrypted encrtypted) {
    var encrypter = _encryptInit();
    return encrypter.decrypt(encrtypted, iv: _iv);
  }
}
