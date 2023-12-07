// Importando bibliotecas necessárias para testes e mocktail
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todotdd/src/cubits/board_cubit.dart';
import 'package:todotdd/src/pages/board_page.dart';
import 'package:todotdd/src/repositories/board_repository.dart';

// Classe mock para simular o comportamento do repositório
class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  // Inicializando variáveis necessárias
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;

  // Configuração antes de cada teste
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  // Teste para verificar se a página exibe corretamente as tarefas quando o repositório retorna uma lista vazia
  testWidgets('board page with all tasks', (tester) async {
    // Configurando o comportamento simulado do repositório para retornar uma lista vazia
    when(() => repository.fetch()).thenAnswer((_) async => []);

    // Construindo a árvore de widgets e iniciando o bombeamento do widget
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const MaterialApp(home: BoardPage()),
      ),
    );

    // Verificando se o widget com a chave 'EmptyState' está presente
    expect(find.byKey(const Key('EmptyState')), findsOneWidget);

    // Aguardando 2 segundos para permitir a execução do fetchTasks
    await tester.pump(const Duration(seconds: 2));

    // Verificando se o widget com a chave 'GettedState' está presente após a execução do fetchTasks
    expect(find.byKey(const Key('GettedState')), findsOneWidget);
  });

  // Teste para verificar se a página exibe corretamente o estado de falha quando o repositório lança uma exceção
  testWidgets('board page with failure state', (tester) async {
    // Configurando o comportamento simulado do repositório para lançar uma exceção
    when(() => repository.fetch()).thenThrow((_) async => Exception("Error"));

    // Construindo a árvore de widgets e iniciando o bombeamento do widget
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const MaterialApp(home: BoardPage()),
      ),
    );

    // Verificando se o widget com a chave 'EmptyState' está presente
    expect(find.byKey(const Key('EmptyState')), findsOneWidget);

    // Aguardando 2 segundos para permitir a execução do fetchTasks
    await tester.pump(const Duration(seconds: 2));

    // Verificando se o widget com a chave 'FailureState' está presente após a execução do fetchTasks
    expect(find.byKey(const Key('FailureState')), findsOneWidget);
  });
}
