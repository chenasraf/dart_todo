import 'dart:io';

class Todo {
  String _title;
  bool _done;
  final void Function() onUpdate;

  Todo({
    String title,
    bool done,
    this.onUpdate,
  })  : _title = title,
        _done = done ?? false;

  Todo.parseLine(String line, {this.onUpdate}) {
    final genericException = FormatException('Todo is malformed', line, 0);
    final checkedException = FormatException(
        'Todo does not contain "checked" token (v/x)',
        line,
        line.indexOf(RegExp(r'\[')) + 1);
    final pattern = RegExp(r'^- \[[ x]\]');
    try {
      final match = pattern.matchAsPrefix(line);

      if (match == null) {
        throw genericException;
      }

      final split = [
        line.substring(0, match.end),
        line.substring(match.end + 1),
      ];

      if (split.any((i) => i?.isNotEmpty != true)) {
        throw genericException;
      }

      switch (split[0].replaceAll(' ', '')) {
        case '-[]':
          _done = false;
          break;
        case '-[x]':
          _done = true;
          break;
        default:
          throw checkedException;
      }

      _title = split[1];
    } on RangeError catch (_) {
      throw genericException;
    }
  }

  String get title => _title;
  set title(String value) => _update(_title = value);

  bool get done => _done;
  set done(bool value) => _update(_done = value);

  void _update([dynamic _expr]) {
    if (_expr is void Function()) {
      _expr.call();
    }
    onUpdate?.call();
  }

  void toggle() {
    done = !done;
  }

  Todo copyWith({
    String title,
    bool done,
    final void Function() onUpdate,
  }) =>
      Todo(
        title: title ?? this.title,
        done: done ?? this.done ?? false,
        onUpdate: onUpdate ?? this.onUpdate,
      );

  String toMarkdown() => '- [${done ? "x" : " "}] $title';

  @override
  String toString() => '$runtimeType($title, done: $done)';
}

class Project {
  List<Todo> todos = [];
  File file;

  Project.fromFile(this.file);

  Project.defaultFile() : file = File('.todo');

  void _dumpToFile() async {
    await file.writeAsString(toMarkdown());
  }

  void loadTodos() async {
    todos.clear();
    final content = await file.readAsLinesSync();
    for (final line in content) {
      if (line.trim().isEmpty) {
        continue;
      }
      todos.add(Todo.parseLine(line, onUpdate: _dumpToFile));
    }
  }

  String toMarkdown() =>
      todos.where((i) => i != null).map((t) => t.toMarkdown()).join('\r\n');

  Future<void> addTodo(Todo todo) async {
    todos.add(todo.copyWith(onUpdate: _dumpToFile));
    await _dumpToFile();
  }

  Future<void> removeTodo(Todo todo) async {
    todos.removeWhere((t) => t.title == todo.title);
    await _dumpToFile();
  }
}
