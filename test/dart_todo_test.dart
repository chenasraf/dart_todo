import 'package:dart_todo/todo.dart';
import 'package:test/test.dart';

void main() {
  test('create todo done', () {
    final correctDone = '- [x] I did this';
    final todoDone = Todo.parseLine(correctDone);

    expect(todoDone.done, equals(true));
    expect(todoDone.title, equals('I did this'));
  });
  test('create todo not done', () {
    final correctNotDone = '- [ ] I did not do this';
    final todoNotDone = Todo.parseLine(correctNotDone);

    expect(todoNotDone.done, equals(false));
    expect(todoNotDone.title, equals('I did not do this'));
  });
  test('create todo with bad format - throws', () {
    final incorrect1 = "I don't know if I did this";
    final incorrect2 = '- [ ]';
    final incorrect3 = "[] I don't know if I did this";
    expect(() => Todo.parseLine(incorrect1), throwsFormatException);
    expect(() => Todo.parseLine(incorrect2), throwsFormatException);
    expect(() => Todo.parseLine(incorrect3), throwsFormatException);
  });
}
