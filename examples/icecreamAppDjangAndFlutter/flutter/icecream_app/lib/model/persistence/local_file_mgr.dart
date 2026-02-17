import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:icecream_app/model/constants.dart';
import 'package:icecream_app/model/flavor.dart';
import 'package:icecream_app/model/persistence/persistence_mgr.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// File manager (singleton) demoing local file IO
class FileMgr extends PersistenceMgr {
  bool _dirtyBit;

  static FileMgr? _mgr;

  List<Flavor> cachedFlavors;

  // traditional method of creating a singleton
  static FileMgr get instance {
    return FileMgr();
  }

  // recommended method of creating a Flutter singleton
  factory FileMgr() {
    _mgr ??= FileMgr._internal();
    return _mgr!;
  }

  FileMgr._internal()
      : _dirtyBit = false,
        cachedFlavors = [];

    
  @override
  String get storageType => localFileLabel;

  @override
  Future<List<Flavor>> getAllFlavors() async {
    if (cachedFlavors.isEmpty) {
      await _readFlavorsFromFile(localFile);
      _dirtyBit = false;
    }
    return cachedFlavors;
  }

  Future<String?> get _localFolder async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      return null;
    }
  }

  Future<void> _readFlavorsFromFile(var filename) async {
    try {
      String? folder = await _localFolder;
      if (folder != null) {
        File file = File(path.join(folder, filename));
        if (await file.exists()) {
          final contents = await file.readAsString();
          cachedFlavors = getFlavorsFromString(contents);
        }
      }
    } catch (e) {
      cachedFlavors = [];
    }
  }

  static List<Flavor> getFlavorsFromString(String contents) {
    List<Flavor> output = [];
    LineSplitter ls = const LineSplitter();
    List<String> lines = ls.convert(contents);

    output = List.generate(lines.length, (i) {
      final decoded = json.decode(lines[i]);
      return Flavor.fromMap(decoded.cast<String, dynamic>());
    });
    return output;
  }

  void _writeFlavorsToLocalFile() {
    if (_dirtyBit) {
      StringBuffer buffer = StringBuffer();
      cachedFlavors.sort((a, b) => a.compareTo(b));
      for (final flavor in cachedFlavors) {
        buffer.write(json.encode(flavor.toMap));
        buffer.write(Platform.lineTerminator);
      }
      _writeToLocalFile(buffer.toString(), localFile);
    }
  }

  void _writeToLocalFile(String str, var filename) async {
    if (_dirtyBit) {
      String? folder = await _localFolder;
      if (folder != null) {
        var filepath = path.join(folder, filename);
        File file = File(filepath);

        // must await so that dirty bit is not set until after write.
        await file.writeAsString(str);
        _dirtyBit = !matchesFlavorsList(str);
      }
    }
  }

  bool matchesFlavorsList(String str) {
    var writtenFlavors = getFlavorsFromString(str);
    if (writtenFlavors.length != cachedFlavors.length) return false;

    for (var i = 0; i < writtenFlavors.length; i++) {
      if (cachedFlavors[i].compareTo(writtenFlavors[i]) != 0) return false;
    }
    return true;
  }

  // Unlikely to fail, so using a try-catch
  @override
  Future<Flavor?> getFlavor(int id) async {
    await getAllFlavors();
    try {
      return cachedFlavors.firstWhere((flavor) => flavor.id == id);
    } catch (e) {
      return null;
    }
  }

  // Unlikely to fail, so using a try-catch
  @override
  Future<void> updateFlavor(Flavor flavor) async {
    await getAllFlavors();
    try {
      var target = cachedFlavors.firstWhere((f) => f.id == flavor.id);
      target.clone(flavor);
      _dirtyBit = true;
    } catch (e) {
      return;
    }
    _writeFlavorsToLocalFile();
  }

  @override
  Future<void> deleteFlavor(int id) async {
    await getAllFlavors();
    final oldSize = cachedFlavors.length;
    cachedFlavors.removeWhere((f) => f.id == id);
    if (oldSize != cachedFlavors.length) {
      _dirtyBit = true;
      _writeFlavorsToLocalFile();
    }
  }

  @override
  Future<void> addFlavorToLocalStorage(Flavor flavor) async {
    await getAllFlavors();

    var target = cachedFlavors.firstWhere((f) => f.id == flavor.id,
        orElse: () => Flavor(id: -1, name: noMatch));
    if (target.name == noMatch) {
      cachedFlavors.add(flavor);
      _dirtyBit = true;
      _writeFlavorsToLocalFile();
    }
  }
}
