import 'package:api_key_handler/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// basic secure storage example
class SecureStorage {
  static SecureStorage? _instance;
  final FlutterSecureStorage _storage;

  static SecureStorage get instance {
    _instance ??= SecureStorage._internal();
    return _instance!;
  }

  SecureStorage._internal() : _storage = FlutterSecureStorage();

  Future<void> store(String value) async {
    await _storage.write(key: storageKey, value: value);
  }

  Future<String?> get get async {
    if (await _storage.containsKey(key: storageKey)) {
      return await _storage.read(key: storageKey);
    } else {
      return null;
    }
  }
}
