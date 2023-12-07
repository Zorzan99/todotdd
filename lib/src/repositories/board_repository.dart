// Importando a classe Task do arquivo 'task.dart'
import 'package:todotdd/src/models/task.dart';

// Definindo uma interface (classe abstrata) para o repositório do quadro
abstract class BoardRepository {
  // Método assíncrono para buscar tarefas
  Future<List<Task>> fetch();

  // Método assíncrono para atualizar a lista de tarefas no repositório
  Future<List<Task>> update(List<Task> tasks);
}
