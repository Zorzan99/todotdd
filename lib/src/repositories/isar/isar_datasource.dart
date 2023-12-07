// Importando bibliotecas necessárias
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todotdd/src/repositories/isar/task_model.dart';

// Classe responsável por interagir com o banco de dados Isar
class IsarDataSource {
  // Instância do banco de dados Isar
  Isar? _isar;

  // Método privado para obter uma instância única do banco de dados Isar
  Future<Isar> _getInstance() async {
    // Verificando se já existe uma instância, e se existir, retornando-a
    if (_isar != null) {
      return _isar!;
    }

    // Obtendo o diretório de documentos da aplicação
    final dir = await getApplicationDocumentsDirectory();

    // Inicializando e abrindo o banco de dados Isar com o esquema TaskModelSchema
    _isar = await Isar.open(
      [TaskModelSchema],
      directory: dir.path,
    );

    // Retornando a instância do banco de dados Isar
    return _isar!;
  }

  // Método assíncrono para obter todas as tarefas do banco de dados
  Future<List<TaskModel>> getTasks() async {
    // Obtendo a instância do banco de dados Isar
    final isar = await _getInstance();

    // Consultando e retornando todas as tarefas armazenadas no banco de dados
    return await isar.taskModels.where().findAll();
  }

  // Método assíncrono para excluir todas as tarefas do banco de dados
  Future<void> deleteAllTasks() async {
    // Obtendo a instância do banco de dados Isar
    final isar = await _getInstance();

    // Realizando uma transação de escrita para excluir todas as tarefas
    await isar.writeTxn(() async {
      return isar.taskModels.where().deleteAll();
    });
  }

  // Método assíncrono para armazenar todas as tarefas no banco de dados
  Future<void> putAllTasks(List<TaskModel> models) async {
    // Obtendo a instância do banco de dados Isar
    final isar = await _getInstance();

    // Realizando uma transação de escrita para armazenar todas as tarefas
    await isar.writeTxn(() async {
      return isar.taskModels.putAll(models);
    });
  }
}
