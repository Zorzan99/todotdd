import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todotdd/src/models/task.dart';
import 'package:todotdd/src/repositories/board_repository.dart';
import 'package:todotdd/src/repositories/isar/isar_board_repository.dart';
import 'package:todotdd/src/repositories/isar/isar_datasource.dart';
import 'package:todotdd/src/repositories/isar/task_model.dart';

class IsarDataSourceMock extends Mock implements IsarDataSource {}

void main() {
  late IsarDataSource datasource;
  late BoardRepository repository;

  setUp(() {
    datasource = IsarDataSourceMock();
    repository = IsarBoardRepository(datasource);
  });

  test('Fetch ', () async {
    when(() => datasource.getTasks()).thenAnswer((_) async => [
          TaskModel()..id = 1,
        ]);

    final tasks = await repository.fetch();
    expect(tasks.length, 1);
  });
  test('Update ', () async {
    when(() => datasource.deleteAllTasks()).thenAnswer((_) async => []);
    when(() => datasource.putAllTasks(any())).thenAnswer((_) async => []);

    final tasks = await repository.update([
      const Task(id: -1, description: ''),
      const Task(id: 2, description: ''),
    ]);
    expect(tasks.length, 2);
  });
}
