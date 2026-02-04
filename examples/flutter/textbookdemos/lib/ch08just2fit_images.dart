import 'package:flutter/material.dart';

/// Single child layout widget
/// FittedBox fits it child with in the given space during layout to avoid overflows.
void main() => runApp(const LetterGrid());

class LetterGrid extends StatelessWidget {
  const LetterGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyFittedBox(),
    );
  }
}

class MyFittedBox extends StatefulWidget {
  const MyFittedBox({super.key});
  @override
  MyFittedBoxState createState() => MyFittedBoxState();
}

class MyFittedBoxState extends State<MyFittedBox> {
  @override
  void didUpdateWidget(MyFittedBox oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //FittedBox Widget Usage
        body: FittedBox(
      child: rowOfImages(),
    ));
  }

  Widget rowOfImages() {
    return Row(
      children: [
        Image.asset('assets/flutter_icon.png'),
        Image.asset('assets/flutter_icon.png'),
      ],
    );
  }
}
