import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// AlertDialog Widget
void main() => runApp(const AlertDialogDemo());

class AlertDialogDemo extends StatelessWidget {
  const AlertDialogDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAlertDialog(),
    );
  }
}

class MyAlertDialog extends StatefulWidget {
  const MyAlertDialog({super.key});

  @override
  MyAlertDialogState createState() => MyAlertDialogState();
}

class MyAlertDialogState extends State<MyAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AlertDialog"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              child: const Text("Material"),
              onPressed: () {
                _showMaterialDialog(context);
              },
            ),
            ElevatedButton(
              child: const Text("Cupertino"),
              onPressed: () {
                _showCupertinoDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMaterialDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Material"),
            content: const Text("I'm Material AlertDialog Widget."),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _showCupertinoDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Cupertino"),
            content: const Text("I'm Cupertino (iOS) AlertDialog Widget."),
            actions: <Widget>[
              const CupertinoButton(
                onPressed: null,
                child: Text('Cancel'),
              ),
              CupertinoButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }
}
