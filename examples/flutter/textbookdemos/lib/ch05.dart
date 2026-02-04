import 'package:flutter/material.dart';

//Entry point to the app
void main() {
  runApp(const HelloBooksApp());
}

class HelloBooksApp extends StatelessWidget {
  const HelloBooksApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Hello Books'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  //Spanish (Hola Libros), Italian (Ciao Libri), and Hindi (हैलो किताबें)
  final List<String> greetings = [
    'Hello Books',
    'Hola Libros',
    'Ciao Libri',
    'हैलो किताबें',
  ];

  int index = 0;
  late String current;

  void _updateGreeting() {
    setState(() {
      current = greetings[index];
      index = (index + 1) % greetings.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // we are in the state class for
        // the MyHomePage Stateful widget which has
        //   a title instance variable.
        //   accessible by widget.title 
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          greetings[index],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateGreeting,
        tooltip: 'Greeting',
        child: const Icon(Icons.textsms_rounded),
      ),
    );
  }
}
