import 'package:flutter/widgets.dart';
import 'package:icecream_app/model/persistence/persistence_mgr.dart';
import 'package:path/path.dart';
import 'package:icecream_app/model/constants.dart';
import 'package:icecream_app/model/flavor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

/// Database manager (singleton) demoing sqflite
class DbMgr extends PersistenceMgr {
  static DbMgr? _mgr;

  // traditional method of creating a singleton
  static DbMgr get instance {
    return DbMgr();
  }

  // recommended method of creating a Flutter singleton
  factory DbMgr() {
    _mgr ??= DbMgr._internal();
    return _mgr!;
  }

  DbMgr._internal();

  static bool get doesNotSupportDB => !PersistenceMgr.supportsDB;

  @override
  String get storageType => databaseLabel;

  Future<Database> _setupDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), dbFile),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $dbFlavorTableName($dbFlavorId INTEGER PRIMARY KEY, $dbflavorName TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }


  Future<void> _addFlavorMapToLocalStorage(Map<String, dynamic> map) async {
    if (doesNotSupportDB) return;
    var database = await _setupDatabase();
    await database.insert(
      dbFlavorTableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<void> addFlavorToLocalStorage(Flavor flavor) async {
    if (doesNotSupportDB) return;
    _addFlavorMapToLocalStorage(flavor.toMap);
  }


  @override
  Future<List<Flavor>> getAllFlavors() async {
    if (doesNotSupportDB) return [];

    var database = await _setupDatabase();
    final List<Map<String, Object?>> flavorMaps =
        await database.query(dbFlavorTableName);

    return [
      for (final {
            dbFlavorId: id as int,
            dbflavorName: name as String,
          } in flavorMaps)
        Flavor(id: id, name: name),
    ];
  }

  @override
  Future<Flavor?> getFlavor(int id) async {
    if (doesNotSupportDB) return null;

    var database = await _setupDatabase();
    final List<Map<String, Object?>> flavorMaps = await database
        .query(dbFlavorTableName, where: "$dbFlavorId = ?", whereArgs: [id]);

    if (flavorMaps.isNotEmpty) {
      return Flavor(
          id: flavorMaps.first[dbFlavorId] as int,
          name: flavorMaps.first[dbflavorName] as String);
    } else {
      return null;
    }
  }

  @override
  Future<void> updateFlavor(Flavor flavor) async {
    if (doesNotSupportDB) return;

    var database = await _setupDatabase();
    await database.update(
      dbFlavorTableName,
      flavor.toMap,
      where: '$dbFlavorId = ?',
      whereArgs: [flavor.id],
    );
  }

  @override
  Future<void> deleteFlavor(int id) async {
    if (doesNotSupportDB) return;

    var database = await _setupDatabase();

    await database.delete(
      dbFlavorTableName,
      where: '$dbFlavorId = ?',
      whereArgs: [id],
    );
  }
}
