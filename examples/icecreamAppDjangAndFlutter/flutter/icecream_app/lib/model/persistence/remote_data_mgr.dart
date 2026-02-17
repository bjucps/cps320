import 'package:icecream_app/model/orders.dart';
import 'package:icecream_app/model/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for JSON


/// Remote data is from a REST API
Future<List<Order>> getOrderList() async {
  final response = await http.get(Uri.parse('$urlPrefix$restPath'),
      headers: {authorizationKey: apiKey});

  final items = json.decode(response.body).cast<Map<String, dynamic>>();
  return items.map<Order>((json) => Order.fromMap(json)).toList();
}
