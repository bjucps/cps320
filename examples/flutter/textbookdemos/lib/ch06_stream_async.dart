import 'dart:math';

import 'package:flutter/material.dart';

///
void main() => runApp(const StreamBuilderDemo());

class StreamBuilderDemo extends StatelessWidget {
  const StreamBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyStreamBuilderWidget(),
    );
  }
}

class MyStreamBuilderWidget extends StatefulWidget {
  const MyStreamBuilderWidget({super.key});

  @override
  MyStreamBuilderWidgetState createState() => MyStreamBuilderWidgetState();
}

class MyStreamBuilderWidgetState extends State<MyStreamBuilderWidget> {
  Stream<int> streamData = (() async* {
    if (Random().nextInt(4) > 0) {
      await Future<void>.delayed(const Duration(seconds: 3));
      for (int i = 1; i < 8; ++i) {
        yield i;
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      yield 8;
    } else {
      await Future<void>.delayed(const Duration(seconds: 3));
      yield throw ("Error in calculating number");
    }
  })();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("StreamBuilder Widget"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<int>(
          stream: streamData,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Center(
              child: getStreamFeedback(snapshot),
            );
          },
        ),
      ),
    );
  }

  Widget getStreamFeedback(AsyncSnapshot<int> snapshot) {
    Widget futureChild;
    if (snapshot.hasError) {
      //show error message
      futureChild = Text("Error occurred fetching data [${snapshot.error}]");
    } else if (snapshot.connectionState == ConnectionState.done) {
      //success
      futureChild = Text("Number received is ${snapshot.data}");
    } else if (snapshot.connectionState == ConnectionState.active) {
      //stream is connected but not finished yet.
      futureChild = Text("Loading....${snapshot.data}");
    } else if (snapshot.connectionState == ConnectionState.waiting || true) {
      futureChild = const CircularProgressIndicator();
    }
    return futureChild;
  }
}
