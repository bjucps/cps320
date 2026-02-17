import 'package:flutter_test/flutter_test.dart';
import 'package:icecream_app/model/persistence/local_db_mgr.dart';
import 'package:icecream_app/model/flavor.dart';

void main() {
  group('DB Manager', (() {
    test('get all flavors', () async {
      List<Flavor> list = await DbMgr.instance.getAllFlavors();
      expect(list, []);
    });
    test('get flavor', () async {
      var result = await DbMgr.instance.getFlavor(0);
      expect(result, null);
    });
    test('update flavor', () async {
      await DbMgr.instance.updateFlavor(Flavor(id:5, name:"candy"));
      var result = await DbMgr.instance.getFlavor(5);
      expect(result, null);
    });
    test('delete flavor', () async {
      await DbMgr.instance.deleteFlavor(5);
      var result = await DbMgr.instance.getFlavor(5);
      expect(result, null);
    });
  }));
}
