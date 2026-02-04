import 'package:flutter/material.dart';

/// ConstrainedBox puts additional constrained on its child.

void main() => runApp(const ConstrainedBoxDemo());

class ConstrainedBoxDemo extends StatelessWidget {
  const ConstrainedBoxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyConstraintBox(),
    );
  }
}

class MyConstraintBox extends StatefulWidget {
  const MyConstraintBox({super.key});

  @override
  MyConstraintBoxState createState() => MyConstraintBoxState();
}

int minConstraint = 0;
int expandsConstraint = 1;
int looseConstraint = 2;

Map<int, String> dropdown = {
  minConstraint: "Min Width & Height",
  expandsConstraint: 'Expands',
  looseConstraint: 'Loose',
};

class MyConstraintBoxState extends State<MyConstraintBox> {
  @override
  void didUpdateWidget(MyConstraintBox oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  String? dropDownValue = dropdown[0];

  String message = "";

  /// Imposes minimum width and height on the child
  BoxConstraints minWidthHeight = const BoxConstraints(
    minWidth: 100,
    minHeight: 100,
  );

  /// Expands to the given width and height
  BoxConstraints expands = const BoxConstraints.expand(
    width: 200,
    height: 200,
  );

  /// Constraints box to the given size. Can't go beyond the provided size
  BoxConstraints loose = BoxConstraints.loose(
    const Size(100, 200),
  );

  BoxConstraints? currentConstraint;

  @override
  void initState() {
    super.initState();
    updateContainer(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BoxConstraints"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: DropdownButton(
              hint: Text(dropDownValue ?? 'Select'),
              items: dropdown.keys
                  .map((e) => DropdownMenuItem(
                        onTap: () =>
                            setState(() => updateContainer(getConstraint(e))),
                        value: e,
                        child: Text(dropdown[e] ?? ''),
                      ))
                  .toList(),
              onChanged: (newValue) {
                dropDownValue = dropdown[newValue];
              },
            ),
          )
        ],
      ),
      //ConstrainedBox Widget Usage
      body: Center(
        child: ConstrainedBox(
          constraints: currentConstraint!,
          child: Container(
            color: Colors.grey,
            child: Text(message),
          ),
        ),
      ),
    );
  }

  int getConstraint(int option) {
    switch (option) {
      case 1:
        return expandsConstraint;
      case 2:
        return looseConstraint;
      default:
        return minConstraint;
    }
  }

  void updateContainer(int option) {
    switch (option) {
      case 1:
        currentConstraint = expands;
        message =
            "Expands to the given width and height.\nWidth: 200\nHeight:200";
        break;

      case 2:
        currentConstraint = loose;
        message =
            "Constraints box to the given size. Can't go beyond the provided size.\n"
            "Width: 100\nHeight:200";
        break;
      default:
        currentConstraint = minWidthHeight;
        message =
            "Imposes minimum width and height on the child.\nWidth: 100\nHeight:100";
        break;
    }
  }
}
