import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icecream_app/model/flavor.dart';
import 'package:icecream_app/model/orders.dart';
import 'package:icecream_app/model/persistence/remote_data_mgr.dart';

void main() {
  group('Order', (() {
    WidgetsFlutterBinding.ensureInitialized();
    var order = Order(id: 20, customerName: "Mindy McLaughlin");
    order.newScoop = Flavor(id: 1, name: "French Vanilla");
    order.newScoop = Flavor(id: 2, name: "Pineapple");
    order.newScoop = Flavor(id: 3, name: "Peanut Butter Chip");
    var map = order.toMap;

    test('check id', () {
      expect(map['id'], order.id);
    });


    test('check customerName', () {
      expect(map['customer_name'], order.customerName);
    });
    test('check completed', () {
      expect(map['is_completed'], order.isCompleted);
    });
    test('check scoops', () {
      for (int i = 0; i < order.scoops.length; ++i) {
        expect(map["scoops"][i]['id'], order.scoops[i].id);
        expect(map["scoops"][i]['name'], order.scoops[i].name);
      }
    });
    test('convert to order, same ID', () {
      var converted = Order.fromMap(map);
      expect(converted.id, order.id);
    });
    test('convert to order, same name', () {
      var converted = Order.fromMap(map);
      expect(converted.customerName, order.customerName);
    });
    test('convert to order, same completed', () {
      var converted = Order.fromMap(map);
      expect(converted.isCompleted, order.isCompleted);
    });
    test('convert to order, check scoops', () {
      var converted = Order.fromMap(map);
      for (int i = 0; i < order.scoops.length; ++i) {
        expect(converted.scoops[i].id, map["scoops"][i]['id']);
        expect(converted.scoops[i].name, map["scoops"][i]['name']);
      }
    });
    test('scoop string', () {
      const actual = "French Vanilla, Pineapple, Peanut Butter Chip";
      expect(order.scoopString, actual);
    });
    test('get order list', () async {
      var list = await getOrderList();
      expect(list.length, 10);
    });
  }));
}
