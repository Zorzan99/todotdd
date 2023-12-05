import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:todotdd/src/models/task.dart';
import 'package:todotdd/src/repositories/board_repository.dart';
import 'package:todotdd/src/states/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;

  BoardCubit(this.repository) : super(EmptyBoardState());

  Future<void> fetchTasks() async {
    emit(LoadingBoardState());
    try {
      final tasks = await repository.fetch();
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> addTask(Task newTask) async {
    final state = this.state;
    if (state is! GettedTasksBoardState) {
      return;
    }
    final tasks = state.tasks.toList();
    tasks.add(newTask);
    try {
      await repository.update(tasks);
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> removeTask(Task newTask) async {
    final state = this.state;
    if (state is! GettedTasksBoardState) {
      return;
    }
    final tasks = state.tasks.toList();
    tasks.remove(newTask);
    try {
      await repository.update(tasks);
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> checkTask(Task newTask) async {
    final state = this.state;
    if (state is! GettedTasksBoardState) {
      return;
    }
    final tasks = state.tasks.toList();
    final index = tasks.indexOf(newTask);
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTasksBoardState(tasks: tasks));
  }
}
