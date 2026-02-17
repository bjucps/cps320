import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icecream_app/model/flavor.dart';

void main() {
  group('flavor', (() {
    WidgetsFlutterBinding.ensureInitialized();
    var flavor = Flavor(id: 10, name: "Cotton Candy");
    var map = flavor.toMap;
    test('check id', () {
      expect(map["id"], flavor.id);
    });
    test('check name', () {
      expect(map["name"], flavor.name);
    });
    test('convert to flavor, same ID', () {
      var converted = Flavor.fromMap(map);
      expect(converted.id, flavor.id);
    });
    test('convert to flavor, same name', () {
      var converted = Flavor.fromMap(map);
      expect(converted.name, flavor.name);
    });
    test('update name', () {
      const newName = "Candy Blast";
      flavor.updateName(newName);
      expect(newName, flavor.name);
    });
  }));
}
