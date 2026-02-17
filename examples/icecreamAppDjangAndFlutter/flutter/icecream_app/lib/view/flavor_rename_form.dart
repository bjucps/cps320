import 'package:flutter/material.dart';
import 'package:icecream_app/model/persistence/persistence_mgr.dart';
import 'package:icecream_app/model/flavor.dart';
import 'package:icecream_app/model/constants.dart';

/// Widget for renaming the flavor in local storage.
/// Demos void callback, text controller, snack bar, and checking context 
///    is mounted after asynchronous gap.
class FlavorRenameWidget extends StatefulWidget {
  const FlavorRenameWidget(
      {super.key, required this.flavorId, required this.onReturn});

  final int flavorId;

  // method to call when screen is closed
  final VoidCallback onReturn;

  @override
  FlavorNameState createState() => FlavorNameState();
}

class FlavorNameState extends State<FlavorRenameWidget> {
  late Future<Flavor?> flavor;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController flavorNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    flavorNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // flavor is retrieved from local storage
    flavor = PersistenceMgr.instance.getFlavor(super.widget.flavorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(flavorDisplayTitle),
      ),
      body: getBodyWidget(),
      floatingActionButton: FloatingActionButton(
        // FlavorRenameWidget is FlavorNameState's "widget" variable.
        onPressed: widget.onReturn,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Widget getBodyWidget() {
    return Center(
      child: FutureBuilder<Flavor?>(
        // flavor is a Future<Flavor?> because is comes from local storage.
        future: flavor,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return displayFlavor(snapshot.data);
          }
        },
      ),
    );
  }

  Form displayFlavor(Flavor flavor) {
    flavorNameController.text = flavor.name;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              controller: flavorNameController,
              decoration: const InputDecoration(hintText: renameFlavor),
              validator: (String? value) =>
                  value == null || value.isEmpty ? missingTextError : null),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updateFlavor(flavorNameController, context, flavor);
                }
              },
              child: const Text(submitUpdate),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Flavor> updateFlavor(TextEditingController controller,
    BuildContext context, Flavor flavor) async {
  await flavor.updateName(controller.text);

  // When a BuildContext is used from a StatefulWidget, the mounted property
  // must be checked after an asynchronous gap.
  if (!context.mounted) return flavor;

  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$renamedTo ${flavor.name}.')));
  return flavor;
}
