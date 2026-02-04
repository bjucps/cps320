import 'dart:io';


class WordListProvider {
  var wordlist = [];
  String filename;
  Function functionToNotify;
  WordListProvider (this.filename, this.functionToNotify) {
    readFile();
  }

  void readFile() async {
    File f = File('assets/wordlist.txt');
    wordlist = await f.readAsLines();
    functionToNotify();
  }
}
