import 'package:flutter/material.dart';
import 'package:icecream_app/view/flavors_display.dart';
import 'package:icecream_app/model/persistence/remote_data_mgr.dart';
import 'package:icecream_app/model/orders.dart';
import 'package:icecream_app/model/constants.dart';


/// Displays orders from a rest API
///   Demos navigation and future builder.
class IcecreamApp extends StatelessWidget {
  const IcecreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: ordersDisplayTitle,
      debugShowCheckedModeBanner: false,
      home: OrdersWidget(),
    );
  }
}

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  OrdersWidgetState createState() => OrdersWidgetState();
}

class OrdersWidgetState extends State<OrdersWidget> {
  late Future<List<Order>> orders;
  static const Icon completedIcon = Icon(Icons.storefront_outlined);
  static const Icon notCompleteIcon = Icon(Icons.storefront_rounded);

  @override
  void initState() {
    super.initState();
    orders = getOrderList();
  }

  void refreshOrders() {
    orders = getOrderList();
    setState(() {}); // Good approach?
  }

  void goto(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ordersDisplayTitle),
        actions: <Widget>[
          IconButton(
              onPressed: () => goto(const FlavorsListWidget()),
              icon: const Icon(Icons.icecream)),
        ],
      ),
      body: getBodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshOrders,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget getBodyWidget() {
    return Center(
      child: FutureBuilder<List<Order>>(
        future: orders,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return displayOrders(snapshot);
          }
        },
      ),
    );
  }

  ListView displayOrders(AsyncSnapshot<dynamic> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        var data = snapshot.data[index];
        return Card(
          child: ListTile(
            leading: data.isCompleted? completedIcon : notCompleteIcon,
            title: Text(
              data.customerName,
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: Text(data.scoopString),
          ),
        );
      },
    );
  }
}
