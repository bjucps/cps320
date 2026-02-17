import 'package:flutter_test/flutter_test.dart';
import 'package:icecream_app/model/persistence/local_file_mgr.dart';
import 'package:icecream_app/model/persistence/persistence_mgr.dart';

void main() {
  group('Persistence Manager', (() {
    test('instance', () async {
      var mgr = PersistenceMgr.instance;
      expect(mgr, FileMgr.instance);
    });
    test('supports DB', () async {
      expect(PersistenceMgr.supportsDB, false);
    });
  }));
}
