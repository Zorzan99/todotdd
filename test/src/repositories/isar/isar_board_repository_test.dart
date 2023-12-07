// Importando bibliotecas necessárias para testes e mocktail
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todotdd/src/models/task.dart';
import 'package:todotdd/src/repositories/board_repository.dart';
import 'package:todotdd/src/repositories/isar/isar_board_repository.dart';
import 'package:todotdd/src/repositories/isar/isar_datasource.dart';
import 'package:todotdd/src/repositories/isar/task_model.dart';

// Classe mock para simular o comportamento do IsarDataSource
class IsarDataSourceMock extends Mock implements IsarDataSource {}

void main() {
  // Inicializando variáveis necessárias
  late IsarDataSource datasource;
  late BoardRepository repository;

  // Configuração antes de cada teste
  setUp(() {
    datasource = IsarDataSourceMock();
    repository = IsarBoardRepository(datasource);
  });

  // Teste para verificar se o método fetch() retorna corretamente as tarefas
  test('Fetch ', () async {
    // Configurando o comportamento simulado do IsarDataSource para retornar uma lista com uma tarefa
    when(() => datasource.getTasks()).thenAnswer((_) async => [
          TaskModel()..id = 1,
        ]);

    // Chamando o método fetch() e verificando o resultado
    final tasks = await repository.fetch();
    expect(tasks.length, 1);
  });

  // Teste para verificar se o método update() executa corretamente as operações de deleteAllTasks() e putAllTasks()
  test('Update ', () async {
    // Configurando o comportamento simulado do IsarDataSource para retornar respostas vazias nas operações deleteAllTasks() e putAllTasks()
    when(() => datasource.deleteAllTasks()).thenAnswer((_) async => []);
    when(() => datasource.putAllTasks(any())).thenAnswer((_) async => []);

    // Chamando o método update() com uma lista de tarefas e verificando o resultado
    final tasks = await repository.update([
      const Task(id: -1, description: ''),
      const Task(id: 2, description: ''),
    ]);
    expect(tasks.length, 2);
  });
}
