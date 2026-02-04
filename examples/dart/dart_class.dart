//import 'package:example/example.dart' as example;

int add(var x, [var y = 0]) {
  return x + y;
}

int plus({var x = 0, var y = 0}) {
  return x + y;
}

void main(List<String> arguments) {
  List<int> nums = List.empty();
  plus(x: 5, y: 12);
  print('Result: ${plus()}');
  print('Result: ${add(5, 7)}!');
}

class Fraction {
  int n;
  int _d;
  Fraction(this.n, this._d);
  int get d => _d;
  set d(int x) {
    if (x != 0) {
      _d = x;
    }
  }

  @override
  String toString() {
    return "$n/$_d";
  }
}
