import 'package:file_examples/file_examples.dart';
import 'package:test/test.dart';

void main() {
  group('file reading', () {
    test('invalid file', () {
      expect(getWordList(filename: ''), []);
    });
    test('valid file', () {
      expect(getWordList(filename: 'assets/wordlist.txt').length, 35);
    });
  });
}
