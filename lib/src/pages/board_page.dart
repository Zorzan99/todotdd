// Importando bibliotecas necessárias do Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todotdd/src/cubits/board_cubit.dart';
import 'package:todotdd/src/models/task.dart';
import 'package:todotdd/src/states/board_state.dart';

// Página principal que exibe as tarefas do quadro
class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    super.initState();

    // Callback após a construção do widget para buscar tarefas
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BoardCubit>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtendo a instância do cubit do contexto
    final cubit = context.watch<BoardCubit>();

    // Obtendo o estado atual do cubit
    final state = cubit.state;

    // Widget do corpo da tela
    Widget body = Container();

    // Verificando o tipo de estado atual e construindo o corpo da tela correspondente
    if (state is EmptyBoardState) {
      body = const Center(
        key: Key("EmptyState"),
        child: Text('Adicione uma nova tarefa'),
      );
    } else if (state is GettedTasksBoardState) {
      final tasks = state.tasks;
      body = ListView.builder(
        key: const Key("GettedState"),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onLongPress: () => cubit.removeTask(task),
            child: CheckboxListTile(
              value: task.check,
              title: Text(task.description),
              onChanged: (value) {
                cubit.checkTask(task);
              },
            ),
          );
        },
      );
    } else if (state is FailureBoardState) {
      body = const Center(
        key: Key('FailureState'),
        child: Text('Falha ao buscar tarefas'),
      );
    }

    // Retornando a estrutura da tela com Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTaskDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  // Método para exibir o diálogo de adição de tarefa
  void addTaskDialog() {
    var description = '';

    // Exibindo o diálogo de alerta adaptativo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Sair'),
            ),
            TextButton(
              onPressed: () {
                final task = Task(id: -1, description: description);
                context.read<BoardCubit>().addTask(task);
                Navigator.pop(context);
              },
              child: const Text('Criar'),
            ),
          ],
          title: const Text('Adicionar uma task'),
          content: TextField(
            onChanged: (value) => description = value,
          ),
        );
      },
    );
  }
}
