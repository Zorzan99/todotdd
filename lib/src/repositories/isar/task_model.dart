import 'package:isar/isar.dart';

part 'task_model.g.dart';

@collection
class TaskModel {
  // Atributo id é uma chave primária autoincrementada
  Id id = Isar.autoIncrement;

  // Atributo description para armazenar a descrição da tarefa
  String description = '';

  // Atributo check para indicar se a tarefa está marcada como concluída
  bool check = false;
}
