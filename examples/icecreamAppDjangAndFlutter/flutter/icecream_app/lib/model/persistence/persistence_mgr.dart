import 'package:icecream_app/model/persistence/local_db_mgr.dart';
import 'package:icecream_app/model/persistence/local_file_mgr.dart';
import 'package:icecream_app/model/flavor.dart';
import 'dart:async';
import 'dart:io' show Platform;


/// Persistent data manager (singleton)
///   returns an instance of the Database Manager or File Manager, depending 
///   on the platform.
abstract class PersistenceMgr {
    static PersistenceMgr? _mgr;

  // traditional method of creating a singleton
  static PersistenceMgr get instance {
    _mgr ??= supportsDB ?  DbMgr() : FileMgr();
    return _mgr!;
  }

  String get storageType;

  static bool get supportsDB =>
      Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

  Future<void> addFlavorToLocalStorage(Flavor flavor);

  Future<List<Flavor>> getAllFlavors();
  Future<Flavor?> getFlavor(int id);
  Future<void> updateFlavor(Flavor flavor);
  Future<void> deleteFlavor(int id);
}
