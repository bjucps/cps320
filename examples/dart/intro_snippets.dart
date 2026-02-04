// At terminal, type dart hello.dart

void main() {
  // var data = 1;
  // print("A number: ");
  // print(data);

  // dynamic dynamicData = 1;
  // print("A dynamic-type number: ");
  // print(data.runtimeType);

  // dynamicData = "Hello, World!";
  // print("A dynamic-type string: " + dynamicData);

  // List theList = ['Dart', 'Kotlin'];
  // var result = theList.map((e) => "$e Language").toList();
  // print(theList);
  // print(result);

  // List list = ['Dart', 'Kotlin']; //Like Python
  // print(list.length);

  // // result is an iterable, not a List
  // var result = theList.where((element) => element.toString().contains('t'));

  // // print first or last
  // print (result.first + " and " + result.last);

  // // iterate
  // for (var element in result) {
  //     print(element);
  // }

  var intToStringMap = Map<int, String>();
  intToStringMap[1] = '1';
  var techMap = {
    'Flutter': 'Dart',
    'Android': 'Kotlin',
    'iOS': 'Swift',
  };
  techMap['Web'] = 'Django';
  techMap.containsKey('Flutter');
  techMap.containsValue('Dart');

  // Prints all values

  techMap.entries.forEach((element) {
    print(
        "${element.value} is used for developing ${element.key} applications.");
  });

//     //Passing function 'subtract' as parameter
//     var value = calculate(15, 24, add);

//     print(value);

//     Person p1 = Person ("Chad", 18);
//     print(p1);
//     p1.age = 25;
//     p1.eats = "Pizza";

//     Person p2 = Person ("Job", 30);
//     p2..name = "Fred"..age = 15..eats = "sushi"..birthday();
//     p2.name = "Bill";
//     p2.birthday();
//     print(p2.age); // toString called on int age.
//     String str = p2.name;
//     var index = 0;
//     String ch = str[index];
//     var count = "a".allMatches(str).length;

//     Student s = Student("Sue", 19, "hot dogs");
//     print(s);
//     var colors = ["Red","Orange","Yellow","Green", "Blue", "Indigo", "Violet"];
//     colors.forEach((item) {
// 	  print('${colors.indexOf(item)} : $item');
// });

//     List theList = ['Dart', 'Kotlin'];
//     var result = theList.map((e) => "$e Language").toList();
//     print(theList);
//     print(result);

// }
}

class Person {
  String name; // Underscore prefix means private.
  int _age;
  String _food;
  Person(this.name, this._age, [this._food = "Apple"]);
  String get getName => name;
  set setName(String value) => name = value;
  set eats(String value) => _food = value;
  int get age => _age;
  set age(int value) {
    if (value >= 0) _age = value;
  }

  void birthday() => _age++;

  String toString() => "My name is $name($_age), and I like to eat $_food";
}

// class Student extends Person implements Comparable<Student> {
//   // syntax is a fusion of Java and C++.
//   Student(super._name, super._age, super._food);
//   int compareTo(Student s) {
//     return _age - s._age;
//   }
