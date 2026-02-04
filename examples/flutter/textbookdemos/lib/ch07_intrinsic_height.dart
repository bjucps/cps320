import 'package:flutter/material.dart';

/// Single-child layout widget
/// Expands all the child widgets of Row to the same height of the tallest child widget.
void main() => runApp(const IntrinsicHeightDemo());

class IntrinsicHeightDemo extends StatelessWidget {
  const IntrinsicHeightDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyIntrinsicHeight(),
    );
  }
}

class MyIntrinsicHeight extends StatelessWidget {
  const MyIntrinsicHeight({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IntrinsicHeight Widget"),
      ),
      //IntrinsicHeight Widget Usage
      body: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            childWidget(0),
            childWidget(1),
            childWidget(2),
          ],
        ),
      ),
    );
  }

  Widget childWidget(int index) {
    return Container(
      color: getColor(index),
      width: 100.0 + index * 20,
      height: 100.0 + index * 30,
      child: Center(
        child: Text(
          "$index",
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  Color getColor(int index) {
    Color color = Colors.grey;
    switch (index) {
      case 0:
        color = Colors.red;
        break;

      case 1:
        color = Colors.green;
        break;

      case 2:
        color = Colors.deepPurple;
        break;
    }

    return color;
  }
}
