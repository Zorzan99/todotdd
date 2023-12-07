// Importando bibliotecas necessárias para testes
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todotdd/src/cubits/board_cubit.dart';
import 'package:todotdd/src/models/task.dart';
import 'package:todotdd/src/repositories/board_repository.dart';
import 'package:todotdd/src/states/board_state.dart';

// Classe mock para simular o comportamento do repositório
class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  // Inicializando variáveis necessárias
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;

  setUp(() {
    // Configurando as instâncias necessárias antes de cada teste
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  // Testes agrupados para o método fetchTasks
  group("fetchTasks | ", () {
    test('Deve pegar todas as tasks', () async {
      // Configurando o comportamento simulado do repositório para retornar uma lista de tarefas
      when(() => repository.fetch()).thenAnswer(
        (_) async => [
          const Task(id: 1, description: 'description', check: false),
        ],
      );

      // Expectativa de estados que serão emitidos durante a execução do método fetchTasks
      expect(
        cubit.stream,
        emitsInOrder([
          isA<LoadingBoardState>(),
          isA<GettedTasksBoardState>(),
        ]),
      );

      // Chamando o método fetchTasks
      await cubit.fetchTasks();
    });

    // Teste para verificar se um estado de erro é retornado corretamente
    test("Deve retornar um estado de erro ao falhar", () async {
      // Configurando o comportamento simulado do repositório para lançar uma exceção
      when(() => repository.fetch()).thenThrow(Exception("Error"));

      // Expectativa de estados que serão emitidos durante a execução do método fetchTasks
      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<LoadingBoardState>(),
            isA<FailureBoardState>(),
          ],
        ),
      );

      // Chamando o método fetchTasks
      await cubit.fetchTasks();
    });
  });

  // Testes agrupados para o método addTask
  group("addTask | ", () {
    test('Deve adicionar todas as tasks', () async {
      // Configurando o comportamento simulado do repositório para retornar uma lista vazia
      when(() => repository.update(any())).thenAnswer((_) async => []);

      // Expectativa de estados que serão emitidos durante a execução do método addTask
      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTasksBoardState>(),
        ]),
      );

      // Criando uma tarefa para adicionar
      const task = Task(id: 1, description: 'task add');

      // Chamando o método addTask
      await cubit.addTask(task);

      // Verificando se a tarefa foi corretamente adicionada ao estado
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks, [task]);
    });

    // Teste para verificar se um estado de erro é retornado corretamente
    test("Deve retornar um estado de erro ao falhar", () async {
      // Configurando o comportamento simulado do repositório para lançar uma exceção
      when(() => repository.update(any())).thenThrow(Exception("Error"));

      // Expectativa de estados que serão emitidos durante a execução do método addTask
      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailureBoardState>(),
          ],
        ),
      );

      // Criando uma tarefa para adicionar
      const task = Task(id: 1, description: 'task add');

      // Chamando o método addTask
      await cubit.addTask(task);
    });
  });

  // Testes agrupados para o método removeTask
  group("removeTask | ", () {
    test('Deve remover uma task', () async {
      // Configurando o comportamento simulado do repositório para retornar uma lista vazia
      when(() => repository.update(any())).thenAnswer((_) async => []);

      // Criando uma tarefa para adicionar
      const task = Task(id: 1, description: 'task add');
      cubit.addTasks([task]);

      // Verificando se a tarefa foi corretamente adicionada ao estado
      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);

      // Expectativa de estados que serão emitidos durante a execução do método removeTask
      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTasksBoardState>(),
        ]),
      );

      // Chamando o método removeTask
      await cubit.removeTask(task);

      // Verificando se a tarefa foi corretamente removida do estado
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 0);
    });

    // Teste para verificar se um estado de erro é retornado corretamente
    test("Deve retornar um estado de erro ao falhar", () async {
      // Configurando o comportamento simulado do repositório para lançar uma exceção
      when(() => repository.update(any())).thenThrow(Exception("Error"));

      // Criando uma tarefa para adicionar
      const task = Task(id: 1, description: 'task add');
      cubit.addTasks([task]);

      // Expectativa de estados que serão emitidos durante a execução do método removeTask
      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailureBoardState>(),
          ],
        ),
      );

      // Chamando o método removeTask
      await cubit.removeTask(task);
    });
  });

  // Testes agrupados para o método checkTask
  group("checkTask | ", () {
    test('Deve checar uma task', () async {
      // Configurando o comportamento simulado do repositório para retornar uma lista vazia
      when(() => repository.update(any())).thenAnswer((_) async => []);

      // Criando uma tarefa para adicionar
      const task = Task(id: 1, description: 'task add');
      cubit.addTasks([task]);

      // Verificando o estado inicial da tarefa no estado
      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);
      expect((cubit.state as GettedTasksBoardState).tasks.first.check, false);

      // Expectativa de estados que serão emitidos durante a execução do método checkTask
      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTasksBoardState>(),
        ]),
      );

      // Chamando o método checkTask
      await cubit.checkTask(task);

      // Verificando se a tarefa foi corretamente marcada como concluída no estado
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks.first.check, true);
    });

    // Teste para verificar se um estado de erro é retornado corretamente
    test("Deve retornar um estado de erro ao falhar", () async {
      // Configurando o comportamento simulado do repositório para lançar uma exceção
      when(() => repository.update(any())).thenThrow(Exception("Error"));

      // Criando uma tarefa para adicionar
      const task = Task(id: 1, description: 'task add');
      cubit.addTasks([task]);

      // Expectativa de estados que serão emitidos durante a execução do método checkTask
      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailureBoardState>(),
          ],
        ),
      );

      // Chamando o método removeTask
      await cubit.removeTask(task);
    });
  });
}
