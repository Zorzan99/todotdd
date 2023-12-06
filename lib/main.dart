import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todotdd/src/cubits/board_cubit.dart';
import 'package:todotdd/src/pages/board_page.dart';
import 'package:todotdd/src/repositories/board_repository.dart';
import 'package:todotdd/src/repositories/isar/isar_board_repository.dart';
import 'package:todotdd/src/repositories/isar/isar_datasource.dart';

void main() {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(create: (ctx) => IsarDataSource()),
        RepositoryProvider<BoardRepository>(
            create: (ctx) => IsarBoardRepository(ctx.read())),
        BlocProvider(create: (ctx) => BoardCubit(ctx.read()))
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.purple,
        ),
        home: const BoardPage(),
      ),
    );
  }
}
