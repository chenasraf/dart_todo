import 'dart:io';

import 'package:dart_todo/gui.dart';
import 'package:dart_todo/todo.dart';

Future<Project> _loadProject([File file]) async {
  final project = file != null ? Project.fromFile(file) : Project.defaultFile();
  await project.loadTodos();
  return project;
}

void main(List<String> arguments) async {
  final args = List.from(arguments, growable: true);
  Project loadedProject;
  while (args.length > 1) {
    final cur = args.elementAt(0);
    switch (cur) {
      case 'a':
      case '-a':
      case 'add':
      case '--add':
        final project = loadedProject ?? await _loadProject();
        await project.addTodo(Todo(title: args.sublist(1).join(' ')));
        exit(0);
        break;
      case '-f':
      case '--file':
        loadedProject = await _loadProject(File(args.removeAt(1)));
        break;
      default:
        final project = loadedProject ?? await _loadProject(File(cur));
        await project.loadTodos();
        GUI(project: project);
        break;
    }
    args.removeAt(0);
  }
}
