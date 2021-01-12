import 'dart:io';

import 'package:todo_cli/gui.dart';
import 'package:todo_cli/todo.dart';

Future<Project> _loadProject([File file]) async {
  final project = file != null ? Project.fromFile(file) : Project.defaultFile();
  await project.loadTodos();
  return project;
}

void main(List<String> arguments) async {
  final args = List.from(arguments, growable: true);
  var silent = false;
  Project loadedProject;
  if (args.isEmpty) {
    await GUI(project: await _loadProject());
  } else {
    while (args.isNotEmpty) {
      final cur = args.elementAt(0);
      switch (cur) {
        case 'a':
        case '-a':
        case 'add':
        case '--add':
          final todo = Todo(title: args.sublist(1).join(' '));
          final project = loadedProject ?? await _loadProject();
          await project.addTodo(todo);
          if (!silent) {
            print('Added "${todo.title}" to ${project.file.path}');
          }
          exit(0);
          break;
        case '-f':
        case '--file':
          loadedProject = await _loadProject(File(args.removeAt(1)));
          break;
        case '-q':
        case '--quiet':
          silent = true;
          break;
      }
      args.removeAt(0);
    }
    await GUI(project: loadedProject ?? await _loadProject());
  }
}
