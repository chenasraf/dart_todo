import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:todo_cli/todo.dart';

class GUI {
  final Project project;
  final Console console;

  bool frozen = false;
  int activeIndex = 0;

  GUI({this.project}) : console = Console() {
    stdin.echoMode = false;
    stdin.lineMode = false;
    stdin.listen(_stdinListener);
    _paint();
  }

  int get lines => stdout.terminalLines;
  int get width => stdout.terminalColumns;
  int get maxLines => project.todos.length;
  String get verticalBorder => '-' * (width - 3);

  Todo get currentTodo => project.todos.elementAt(activeIndex);

  void _paint() {
    if (frozen) {
      return;
    }
    console.clearScreen();
    _print(verticalBorder);
    _print('');

    for (var i = 0; i < project.todos.length; i++) {
      final todo = project.todos.elementAt(i);
      final selected = i == activeIndex;
      final indent = 4;
      final line = [
        ' ' * (selected ? indent - 1 : indent),
        selected ? '> ' : ' ',
        (todo.done ? '√' : '×').padRight(3),
        todo.title,
      ].where((s) => s.isNotEmpty).join(' ');
      _print(line);
    }
    final spareLines = lines - project.todos.length - 6;
    if (spareLines > 0) {
      for (var i = 0; i < spareLines; i++) {
        _print('');
      }
    }
    _print(
      (' ' * 10) +
          '[enter/space] - toggle | '
              '[c/a] - add todo | '
              '[d/backspace] - remove todo | '
              '[esc/q] - quit',
    );
    _print(verticalBorder);
  }

  String _ensureLength(String message) =>
      '|' + message.padRight(width - '||\n'.length, ' ') + '|\n';

  void _print(String message) => console.write(_ensureLength(message));

  void _stdinListener(List<int> charCodes) {
    if (!frozen) {
      _handleGUIInput(keyMap[charCodes.last]);
    } else {
      final title = String.fromCharCodes(charCodes).trim();
      project.addTodo(Todo(title: title));
      _exitTextInputMode();
    }
    _paint();
  }

  void _handleGUIInput(Key key) {
    switch (key) {
      case Key.down:
        activeIndex++;
        if (activeIndex >= maxLines) {
          activeIndex = 0;
        }
        break;
      case Key.up:
        activeIndex--;
        if (activeIndex < 0) {
          activeIndex = maxLines - 1;
        }
        break;
      case Key.enter:
      case Key.space:
        currentTodo.toggle();
        break;
      case Key.c:
      case Key.a:
        _enterTextInputMode();
        console.write('Enter title: ');
        break;
      case Key.e:
        //TODO: edit current todo
        break;
      case Key.d:
      case Key.backspace:
        project.removeTodo(currentTodo);
        if (activeIndex > project.todos.length - 1) {
          activeIndex = project.todos.length - 1;
        }
        break;
      case Key.q:
      case Key.esc:
        exit(0);
        break;
      case Key.left:
      case Key.right:
        break;
    }
  }

  void _enterTextInputMode() {
    frozen = true;
    stdin.echoMode = true;
    stdin.lineMode = true;
  }

  void _exitTextInputMode() {
    frozen = false;
    stdin.echoMode = false;
    stdin.lineMode = false;
  }

  final keyMap = <int, Key>{
    32: Key.space,
    65: Key.up,
    66: Key.down,
    67: Key.right,
    68: Key.left,
    10: Key.enter,
    27: Key.esc,
    113: Key.q,
    123: Key.backspace,
    97: Key.a,
    99: Key.c,
    100: Key.d,
    101: Key.e,
  };
}

enum Key {
  up,
  right,
  down,
  left,
  enter,
  esc,
  space,
  backspace,
  q,
  a,
  c,
  d,
  e,
}
