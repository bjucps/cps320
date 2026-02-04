import 'package:flutter/material.dart';

/// Placeholder widget draws a box that indicates that a new widget will be added at some point in future.
void main() => runApp(const PlaceholderDemo());

class PlaceholderDemo extends StatelessWidget {
  const PlaceholderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPlaceholderWidget(),
    );
  }
}

class MyPlaceholderWidget extends StatefulWidget {
  const MyPlaceholderWidget({super.key});

  @override
  MyPlaceholderWidgetState createState() => MyPlaceholderWidgetState();
}

class MyPlaceholderWidgetState extends State<MyPlaceholderWidget> {
  final Future<String> _futureData = Future<String>.delayed(
      const Duration(seconds: 3), () => 'assets/flutter_icon.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Placeholder Widget"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<String>(
          future: _futureData,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            Widget futureChild;
            if (snapshot.hasData) {
              //success
              futureChild = Image.asset(snapshot.data!);
            } else {
              //Placeholder widget while waiting for data to arrive
              futureChild = const SizedBox(
                height: 200,
                width: 200,
                child: Placeholder(
                  color: Colors.deepPurple,
                ),
              );
            }
            return Center(
              child: futureChild,
            );
          },
        ),
      ),
    );
  }
}
