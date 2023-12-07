// Importando a classe Task do arquivo 'task.dart'
import 'package:todotdd/src/models/task.dart';

// Classe selada (sealed class) que representa os estados possíveis do quadro
sealed class BoardState {}

// Classe que representa o estado de carregamento
class LoadingBoardState implements BoardState {}

// Classe que representa o estado após obter as tarefas
class GettedTasksBoardState implements BoardState {
  // Lista de tarefas obtidas
  final List<Task> tasks;

  // Construtor que exige a lista de tarefas ao criar o estado
  GettedTasksBoardState({required this.tasks});
}

// Classe que representa o estado vazio do quadro (sem tarefas)
class EmptyBoardState extends GettedTasksBoardState {
  // Construtor que inicializa o estado como vazio
  EmptyBoardState() : super(tasks: []);
}

// Classe que representa o estado de falha no quadro
class FailureBoardState implements BoardState {
  // Mensagem de erro associada à falha
  final String message;

  // Construtor que exige a mensagem ao criar o estado de falha
  FailureBoardState({required this.message});
}
