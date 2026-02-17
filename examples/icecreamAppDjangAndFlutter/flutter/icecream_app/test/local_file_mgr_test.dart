import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icecream_app/model/constants.dart';
import 'package:icecream_app/model/flavor.dart';
import 'package:icecream_app/model/persistence/local_db_mgr.dart';
import 'package:icecream_app/model/persistence/local_file_mgr.dart';
import 'package:icecream_app/model/persistence/persistence_mgr.dart';

void main() {
  group('Local File Manager', (() {
    WidgetsFlutterBinding.ensureInitialized();

    test('get instance', () {
      PersistenceMgr mgr = PersistenceMgr.instance;
      expect(mgr.storageType, localFileLabel);
    });

    test('storage type', () {
      var mgr = PersistenceMgr.instance;
      expect(mgr.storageType, localFileLabel);
    });

    test('File Manager instance', () {
      var mgr1 = FileMgr.instance;
      var mgr2 = FileMgr.instance;
      expect(mgr1, mgr2);
    });

    test('DB Manager instance', () {
      var mgr1 = DbMgr.instance;
      var mgr2 = DbMgr.instance;
      expect(mgr1, mgr2);
    });

    test('DB Manager local storage', () async {
      var mgr = DbMgr.instance;
      await mgr.addFlavorToLocalStorage(Flavor(id: 3, name: "Bubble gum"));
      expect(await mgr.getAllFlavors(), []);
    });

    test('DB Manager supported', () {
      expect(DbMgr.doesNotSupportDB, true);
    });


    test ("get flavor", () async{
      FileMgr.instance.cachedFlavors = [Flavor(id:5, name:"banana"), Flavor(id:15, name:"berry")];
      var flavor = await FileMgr.instance.getFlavor(15);
      expect(flavor, FileMgr.instance.cachedFlavors[1]);

    });

    test ("delete flavor", () async{
      FileMgr.instance.cachedFlavors = [Flavor(id:5, name:"banana"), Flavor(id:15, name:"berry")];
      await FileMgr.instance.deleteFlavor(15);
      expect(FileMgr.instance.cachedFlavors.length, 1);

    });

    test('write to local file', () async {
      Flavor f = Flavor(id: 42, name: "Huckleberry");

      PersistenceMgr mgr = PersistenceMgr.instance;
      await mgr.addFlavorToLocalStorage(f);
      List<Flavor> flavors = await mgr.getAllFlavors();
      bool inFlavors = false;
      for (var flavor in flavors) {
        if (f.id == flavor.id) {
          inFlavors = true;
          break;
        }
      }
      expect(inFlavors, true);
    });

    test('get list of maps', () {
      var contents = """{"id":1,"name":"Chocolate Chip"}
{"id":2,"name":"Coconut Chippy"}
{"id":3,"name":"Toffee Chip"}
{"id":4,"name":"Strawberry"}
{"id":5,"name":"Rocky Road"}
{"id":6,"name":"Cookie Dough"}
{"id":7,"name":"Elana's Blueberry Pie"}
""";
      var list = FileMgr.getFlavorsFromString(contents);
      expect(list.length, 7);
      expect(list[0].id, 1);
      expect(list[6].name, "Elana's Blueberry Pie");
    });

    test('matches flavors list', () {
      var contents = """{"id":1,"name":"Chocolate Chip"}
{"id":2,"name":"Coconut Chippy"}
{"id":3,"name":"Toffee Chip"}
{"id":4,"name":"Strawberry"}
{"id":5,"name":"Rocky Road"}
{"id":6,"name":"Cookie Dough"}
{"id":7,"name":"Elana's Blueberry Pie"}
""";
      List<Flavor> list = FileMgr.getFlavorsFromString(contents);
      FileMgr.instance.cachedFlavors = list;
      expect(FileMgr.instance.matchesFlavorsList(contents), true);
    });
  }));
}
