import 'dart:io';

import 'package:dart_todo/gui.dart';
import 'package:dart_todo/todo.dart';

void main(List<String> arguments) async {
  final project = Project(File(arguments.elementAt(0)));
  await project.loadTodos();
  GUI(project: project);
}
