import 'package:icecream_app/model/constants.dart';
import 'package:icecream_app/model/flavor.dart';


/// Demos converting from REST API
class Order {
  late final int id;
  late final String customerName;
  late bool isCompleted;
  late List<Flavor> scoops;

  Order(
      {required this.id,
      required this.customerName,
      this.isCompleted = false,
      this.scoops = const []});

  String get scoopString =>
      scoops.map((item) => item.name).toList().join(flavorSeparator);

  set newScoop(Flavor f) {
    if (scoops.isEmpty) {
      scoops = [f];
    } else {
      scoops.add(f);
    }
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
        id: map[dbOrderId],
        customerName: map[dbCustName],
        isCompleted: map[dbIsCompleted],
        scoops: List.generate(map[dbScoopsList].length,
            (index) => Flavor.fromMap(map[dbScoopsList][index])));
  }

  Map<String, dynamic> get toMap {
    return {
      dbOrderId: id,
      dbCustName: customerName,
      dbIsCompleted: isCompleted,
      dbScoopsList: List.generate(
          scoops.length,
          (index) =>
              {dbFlavorId: scoops[index].id, dbflavorName: scoops[index].name})
    };
  }
}
