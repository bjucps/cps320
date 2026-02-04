import 'dart:math';

import 'package:flutter/material.dart';

///FutureBuilderDemo
void main() => runApp(const FutureBuilderDemo());

class FutureBuilderDemo extends StatelessWidget {
  const FutureBuilderDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyFutureBuilderWidget(),
    );
  }
}

class MyFutureBuilderWidget extends StatefulWidget {
  const MyFutureBuilderWidget({super.key});

  @override
  MyFutureBuilderWidgetState createState() => MyFutureBuilderWidgetState();
}

int getData() {
  final data = Random().nextInt(10);
  if (data > 4) {
    return data;
  } else {
    throw "too small: $data";
  }
}

class MyFutureBuilderWidgetState extends State<MyFutureBuilderWidget> {
  final Future<int> _future1 =
      Future<int>.delayed(const Duration(seconds: 10), () => getData());
  final Future<int> _future2 =
      Future<int>.delayed(const Duration(seconds: 11), () => getData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FutureBuilder Widget"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              FutureBuilder<int>(
                future: _future1,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  Widget futureChild;
                  if (snapshot.hasData) {
                    //success
                    futureChild = Text("Number received is ${snapshot.data}");
                  } else if (snapshot.hasError) {
                    //show error message
                    futureChild = Text(
                        "Error occurred fetching data [${snapshot.error}]");
                  } else {
                    //waiting for data to arrive
                    futureChild = const CircularProgressIndicator();
                  }
                  return futureChild;
                },
              ),
              const SizedBox(height: 30),
              FutureBuilder<int>(
                future: _future2,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  Widget futureChild;
                  if (snapshot.hasData) {
                    //success
                    futureChild = Text("Number received is ${snapshot.data}");
                  } else if (snapshot.hasError) {
                    //show error message
                    futureChild = Text(
                        "Error occurred fetching data [${snapshot.error}]");
                  } else {
                    //waiting for data to arrive
                    futureChild = const CircularProgressIndicator();
                  }
                  return futureChild;
                },
              ),
            ],
          )),
    );
  }
}
