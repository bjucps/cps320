import 'dart:io';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:api_key_handler/constants.dart';
import 'package:flutter/material.dart';
import 'package:api_key_handler/secure_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class EncryptionUtilities {
  static String? _plainText;
  static bool _acquiringOnAnotherThread = false;

  static Future<String> encryptAsset(String filename) async {
    AesCrypt crypt = AesCrypt();
    crypt.setOverwriteMode(AesCryptOwMode.on);
    crypt.setPassword(password);
    try {
      File tempFile = await copyAssetToTemp(filename);
      return crypt.encryptFileSync(tempFile.path);
    } catch (e) {
      return emptyString;
    }
  }

  // There is a possibility of multiple threads vying for the the API key.
  //    set a boolean to duplicate work.
  static Future<String?> decryptEnv(String location) async {
    if (_plainText == null) {
      if (_acquiringOnAnotherThread) {
        // let the other thread finish the job but break out eventually.
        var i = 0;
        while (_plainText == null && i < 100) {
          await Future.delayed(Durations.medium1);
        }
      } else {
        // mark that this thread is attempting to retrieve
        _acquiringOnAnotherThread = true;

        // if stil null, Check secure storage.
        //     remove the "(from storage)" note when you use this.
        _plainText ??= "${await SecureStorage.instance.get} (from storage)";

        // if stil null, decrypt from file and store
        //     remove the "(from file)" note when you use this.
        _plainText ??= "${await decryptFileAndStore(location)}(from file)";
      }
      _acquiringOnAnotherThread = false;
    } else if (_plainText != null) {
      // remove the "(local var)" note when you use this.
      _plainText = "${_plainText!} (local var)";
    }

    return _plainText;
  }

  // base file reading. Could be done anywhere
  static Future<String> readFile(String path) async {
    try {
      File file = File(path);
      if (await file.exists()) {
        return await file.readAsString();
      } else {
        return emptyString;
      }
    } catch (e) {
      return emptyString;
    }
  }

  // decrypts the file at the specified path. (temp\.env.aes)
  static Future<String?> decryptFileAndStore(String file) async {
    AesCrypt crypt = AesCrypt();
    crypt.setOverwriteMode(AesCryptOwMode.on);
    crypt.setPassword(password);

    try {
      // If the file path is to assets, you will need to copy to a temporary
      //    folder first.
      _plainText = await crypt.decryptTextFromFile(file);

      // Store securely
      SecureStorage.instance.store(_plainText!);
    } catch (e) {
      _acquiringOnAnotherThread = false;
    }
    return _plainText;
  }

  // At the end, your .env should be encrypted. Use this to copy the encrypted
  //    file to temp.
  static Future<File> copyAssetToTemp(String file) async {
    var content = await rootBundle.load("$assets/$file");
    final bytes = content.buffer.asUint8List();

    // write to temp file, since AesCrypt prefers file input.
    final tempDir = await getTemporaryDirectory();
    final encryptedTempFile = File(path.join(tempDir.path, file));
    await encryptedTempFile.writeAsBytes(bytes);
    return encryptedTempFile;
  }
}
