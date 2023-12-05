import 'package:todotdd/src/models/task.dart';
import 'package:todotdd/src/repositories/board_repository.dart';
import 'package:todotdd/src/repositories/isar/isar_datasource.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDatasource datasource;
  IsarBoardRepository(this.datasource);

  @override
  Future<List<Task>> fetch() {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
