import 'dart:io';

void main(List<String> arguments) {
  var x = 5 / 2;
  print(x);
  Future<List<String>> comingLines = readLines("assets/file.txt");
  print("Starting on main thread");
  comingLines.then((lines) {
    print("On a different thread");
    print("line[0]: ${lines[0]}");
  });
  print("Back on main thread. Cannot access file data.");
}

Future<List<String>> readLines(var name) {
  File file = File(name);
  return file.readAsLines();
}
