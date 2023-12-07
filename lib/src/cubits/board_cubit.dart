// Importando bibliotecas necessárias
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:todotdd/src/models/task.dart';
import 'package:todotdd/src/repositories/board_repository.dart';
import 'package:todotdd/src/states/board_state.dart';

// Definindo a classe BoardCubit, que estende Cubit<BoardState>
class BoardCubit extends Cubit<BoardState> {
  // Instância do repositório para acessar os dados
  final BoardRepository repository;

  // Construtor da classe inicializando o repositório e configurando o estado inicial
  BoardCubit(this.repository) : super(EmptyBoardState());

  // Método assíncrono para buscar tarefas
  Future<void> fetchTasks() async {
    // Emitindo o estado de carregamento
    emit(LoadingBoardState());
    try {
      // Obtendo as tarefas do repositório
      final tasks = await repository.fetch();
      // Emitindo o estado com as tarefas obtidas
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      // Emitindo o estado de falha em caso de erro
      emit(FailureBoardState(message: 'Error'));
    }
  }

  // Método assíncrono para adicionar uma nova tarefa
  Future<void> addTask(Task newTask) async {
    // Obtendo a lista atual de tarefas
    final tasks = _getTasks();
    if (tasks == null) return;
    // Adicionando a nova tarefa à lista
    tasks.add(newTask);
    // Emitindo a lista atualizada de tarefas
    await emitTasks(tasks);
  }

  // Método assíncrono para remover uma tarefa
  Future<void> removeTask(Task newTask) async {
    // Obtendo a lista atual de tarefas
    final tasks = _getTasks();
    if (tasks == null) return;
    // Removendo a tarefa da lista
    tasks.remove(newTask);
    // Emitindo a lista atualizada de tarefas
    await emitTasks(tasks);
  }

  // Método assíncrono para marcar/desmarcar uma tarefa como concluída
  Future<void> checkTask(Task newTask) async {
    // Obtendo a lista atual de tarefas
    final tasks = _getTasks();
    if (tasks == null) return;
    // Encontrando o índice da tarefa e atualizando o estado de conclusão
    final index = tasks.indexOf(newTask);
    tasks[index] = newTask.copyWith(check: !newTask.check);
    // Emitindo a lista atualizada de tarefas
    await emitTasks(tasks);
  }

  // Método utilizado apenas para testes, adiciona uma lista de tarefas diretamente ao estado
  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTasksBoardState(tasks: tasks));
  }

  // Método privado para obter a lista de tarefas do estado atual
  List<Task>? _getTasks() {
    final state = this.state;
    // Verificando se o estado atual é do tipo GettedTasksBoardState
    if (state is! GettedTasksBoardState) {
      return null;
    }
    // Retornando uma cópia da lista de tarefas
    return state.tasks.toList();
  }

  // Método assíncrono para emitir as tarefas atualizadas e atualizar o repositório
  Future<void> emitTasks(List<Task> tasks) async {
    try {
      // Atualizando o repositório com a nova lista de tarefas
      await repository.update(tasks);
      // Emitindo o estado com as tarefas atualizadas
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      // Emitindo o estado de falha em caso de erro
      emit(FailureBoardState(message: 'Error'));
    }
  }
}
