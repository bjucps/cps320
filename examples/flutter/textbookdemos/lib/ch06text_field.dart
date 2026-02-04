import 'package:flutter/material.dart';

/// Flutter TextField Widget.
/// Let users enter text data.
void main() => runApp(const TextFieldDemo());

class TextFieldDemo extends StatelessWidget {
  const TextFieldDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyTextFieldWidget(),
    );
  }
}

class MyTextFieldWidget extends StatefulWidget {
  const MyTextFieldWidget({super.key});

  @override
  MyTextFieldWidgetState createState() => MyTextFieldWidgetState();
}

class MyTextFieldWidgetState extends State<MyTextFieldWidget> {
  late TextEditingController _controller;
  String userText = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // necessary to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TextField Widget"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: _controller,
              onSubmitted: (String value) async {
                setState(() {
                  userText = value;
                  _controller.clear();
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text("User entered: $userText"),
          ],
        ),
      ),
    );
  }
}
