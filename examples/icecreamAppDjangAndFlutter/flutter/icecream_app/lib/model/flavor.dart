import 'package:icecream_app/model/constants.dart';
import 'dart:async';
import 'package:icecream_app/model/persistence/persistence_mgr.dart';

/// Demos converting to and from a map.
class Flavor {
  int id;
  String name;

  Flavor({required this.id, required this.name}) {
    PersistenceMgr.instance.addFlavorToLocalStorage(this);
  }
  factory Flavor.fromMap(Map<String, dynamic> map) {
    return Flavor(id: map[dbFlavorId], name: map[dbflavorName]);
  }
  Map<String, dynamic> get toMap => {dbFlavorId: id, dbflavorName: name};

  Future<void> updateName(String newName) async {
    name = newName;
    PersistenceMgr.instance.updateFlavor(this);
  }

  int compareTo(Flavor other) {
    if (id != other.id) {
      return id - other.id;
    } else {
      return name.compareTo(other.name);
    }
  }

  void clone(Flavor flavor) {
    id = flavor.id;
    name = flavor.name;
  }
}
