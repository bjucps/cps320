import 'package:flutter/material.dart';

void main() => runApp(const ContainerDemo());

class ContainerDemo extends StatelessWidget {
  const ContainerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyContainer(),
    );
  }
}

class MyContainer extends StatefulWidget {
  const MyContainer({super.key});

  @override
  MyContainerState createState() => MyContainerState();
}

Map<int, String> dropdown = {
  0: 'Color',
  1: 'Padding',
  2: 'Margin',
  3: 'Center',
  4: 'BoxConstraints',
  5: 'Transform',
  6: 'Decoration',
  7: 'RESET'
};

class MyContainerState extends State<MyContainer> {
  @override
  void didUpdateWidget(MyContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  int _currentOption = 0;
  List<bool> flags = [false, false, false, false, false, false, false];
  int showColor = 0;
  int addPadding = 1;
  int addMargin = 2;
  int alignCenter = 3;
  int boxConstraints = 4;
  int transform = 5;
  int decoration = 6;
  String? dropDownValue;

  //Box constraints to create a box for the given width and/or height.
  final BoxConstraints _boxConstraints =
      const BoxConstraints.tightFor(width: 100.0, height: 100.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton(
            hint: Text(dropDownValue ?? 'Select'),
            items: dropdown.keys
                .map((e) => DropdownMenuItem(
                      onTap: () {
                        setState(() {
                          _currentOption = e;

                          updateContainer(_currentOption);
                        });
                      },
                      value: e,
                      child: Text(dropdown[e]!),
                    ))
                .toList(),
            onChanged: (newValue) {
              print(newValue);
              dropDownValue = dropdown[newValue];
            },
          )
        ],
      ),
      body: Container(
        color: flags[showColor] && !flags[decoration] ? Colors.red : null,
        padding: flags[addPadding] ? const EdgeInsets.all(16.0) : null,
        margin: flags[addMargin] ? const EdgeInsets.all(20.0) : null,
        alignment: flags[alignCenter] ? Alignment.center : null,
        constraints: flags[boxConstraints] ? _boxConstraints : null,
        transform: flags[transform] ? Matrix4.rotationZ(0.3) : null,
        decoration: flags[decoration] && !flags[showColor]
            ? BoxDecoration(
                border: Border.all(
                  color: Colors.amber,
                  width: 5.0,
                  style: BorderStyle.solid,
                ),
              )
            : null,
        child: const Text(
          "Howdy Container",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  void updateContainer(int option) {
    if (option < 7 && option > -1) {
      flags[option] = !flags[option];
    } else {
      for (int i = 0; i < flags.length; ++i) {
        flags[i] = false;
      }
    }
  }
}
