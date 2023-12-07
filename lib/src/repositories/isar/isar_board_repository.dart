// Importando bibliotecas necessárias
import 'package:todotdd/src/models/task.dart';
import 'package:todotdd/src/repositories/board_repository.dart';
import 'package:todotdd/src/repositories/isar/isar_datasource.dart';
import 'package:todotdd/src/repositories/isar/task_model.dart';

// Classe que implementa a interface BoardRepository usando o banco de dados Isar
class IsarBoardRepository implements BoardRepository {
  // Fonte de dados Isar para interação com o banco de dados local
  final IsarDataSource datasource;

  // Construtor que recebe uma instância de IsarDataSource
  IsarBoardRepository(this.datasource);

  // Método assíncrono para buscar todas as tarefas no banco de dados
  @override
  Future<List<Task>> fetch() async {
    // Obtendo modelos de tarefas do banco de dados através da IsarDataSource
    final models = await datasource.getTasks();

    // Mapeando os modelos de tarefas para instâncias da classe Task
    return models
        .map((e) => Task(
              id: e.id,
              description: e.description,
              check: e.check,
            ))
        .toList();
  }

  // Método assíncrono para atualizar as tarefas no banco de dados
  @override
  Future<List<Task>> update(List<Task> tasks) async {
    // Convertendo instâncias da classe Task para modelos de tarefas
    final models = tasks.map((e) {
      final model = TaskModel()
        ..check = e.check
        ..description = e.description;

      // Se o ID da tarefa for diferente de -1, atribui o ID ao modelo
      if (e.id != -1) {
        model.id = e.id;
      }
      return model;
    }).toList();

    // Deletando todas as tarefas existentes no banco de dados
    await datasource.deleteAllTasks();
    
    // Armazenando os modelos atualizados no banco de dados
    await datasource.putAllTasks(models);

    // Retornando as tarefas originais (não modificado)
    return tasks;
  }
}
