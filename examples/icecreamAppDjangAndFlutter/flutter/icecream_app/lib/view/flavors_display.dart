import 'package:flutter/material.dart';
import 'package:icecream_app/model/constants.dart';
import 'package:icecream_app/model/flavor.dart';
import 'package:icecream_app/view/flavor_rename_form.dart';
import 'package:icecream_app/model/persistence/persistence_mgr.dart';

/// Display of flavors from local persistent data, harvested from orders.
///   Demos used of singleton, future builder, navigator, 
///   and defining a void callback.

class FlavorsListWidget extends StatefulWidget {
  const FlavorsListWidget({super.key});

  @override
  FlavorsListWidgetState createState() => FlavorsListWidgetState();
}

class FlavorsListWidgetState extends State<FlavorsListWidget> {
  late Future<List<Flavor>> flavors;

  @override
  void initState() {
    super.initState();
    flavors = PersistenceMgr.instance.getAllFlavors();
  }

  void refreshFlavors() {
    flavors = PersistenceMgr.instance.getAllFlavors();
    setState(() {}); // Good approach?
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$flavorsDisplayTitle ${PersistenceMgr.instance.storageType}"),
      ),
      body: getBodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshFlavors,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget getBodyWidget() {
    return Center(
      child: FutureBuilder<List<Flavor>>(
        future: flavors,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return displayFlavors(snapshot);
          }
        },
      ),
    );
  }

  ListView displayFlavors(AsyncSnapshot<dynamic> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        Flavor flavor = snapshot.data[index];
        return GestureDetector(
            onTap: () => goto(
                FlavorRenameWidget(flavorId: flavor.id, onReturn: onReturn)),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.icecream),
                title: Text(
                  flavor.name,
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Text("ID #${flavor.id.toString()}"),
              ),
            ));
      },
    );
  }

  void onReturn() {
    Navigator.of(context).pop();
    refreshFlavors();
  }

  void goto(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
