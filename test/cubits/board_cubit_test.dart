import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todotdd/src/cubits/board_cubit.dart';
import 'package:todotdd/src/models/task.dart';
import 'package:todotdd/src/repositories/board_repository.dart';
import 'package:todotdd/src/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });
  group("fetchTasks | ", () {
    test('Deve pegar todas as tasks', () async {
      when(() => repository.fetch()).thenAnswer(
        (_) async => [
          const Task(id: 1, description: 'description', check: false),
        ],
      );
      expect(
        cubit.stream,
        emitsInOrder([
          isA<LoadingBoardState>(),
          isA<GettedTasksBoardState>(),
        ]),
      );

      await cubit.fetchTasks();
    });

    test("Deve retornar um estado de erro ao falhar", () async {
      when(() => repository.fetch()).thenThrow(Exception("Error"));

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<LoadingBoardState>(),
            isA<FailureBoardState>(),
          ],
        ),
      );
      await cubit.fetchTasks();
    });
  });
  group("addTask | ", () {
    test('Deve adicionar todas as tasks', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTasksBoardState>(),
        ]),
      );
      const task = Task(id: 1, description: 'task add');
      await cubit.addTask(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks, [task]);
    });

    test("Deve retornar um estado de erro ao falhar", () async {
      when(() => repository.update(any())).thenThrow(Exception("Error"));

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailureBoardState>(),
          ],
        ),
      );
      const task = Task(id: 1, description: 'task add');

      await cubit.addTask(task);
    });
  });
  group("removeTask | ", () {
    test('Deve remover uma task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      const task = Task(id: 1, description: 'task add');
      cubit.addTasks([task]);

      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTasksBoardState>(),
        ]),
      );

      await cubit.removeTask(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 0);
    });

    test("Deve retornar um estado de erro ao falhar", () async {
      when(() => repository.update(any())).thenThrow(Exception("Error"));

      const task = Task(id: 1, description: 'task add');
      cubit.addTasks([task]);
      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailureBoardState>(),
          ],
        ),
      );

      await cubit.removeTask(task);
    });
  });
  group("checkTask | ", () {
    test('Deve checar uma task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      const task = Task(id: 1, description: 'task add');
      cubit.addTasks([task]);

      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);
      expect((cubit.state as GettedTasksBoardState).tasks.first.check, false);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTasksBoardState>(),
        ]),
      );

      await cubit.checkTask(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks.first.check, true);
    });

    test("Deve retornar um estado de erro ao falhar", () async {
      when(() => repository.update(any())).thenThrow(Exception("Error"));

      const task = Task(id: 1, description: 'task add');
      cubit.addTasks([task]);
      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailureBoardState>(),
          ],
        ),
      );

      await cubit.removeTask(task);
    });
  });
}
