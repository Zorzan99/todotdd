// Importando a biblioteca Equatable para facilitar a comparação de objetos
import 'package:equatable/equatable.dart';

// Definindo a classe Task que estende Equatable para facilitar a comparação
class Task extends Equatable {
  // Atributos da classe
  final int id; // Identificador único da tarefa
  final String description; // Descrição da tarefa
  final bool check; // Indica se a tarefa está marcada como concluída

  // Construtor da classe Task, com valores padrão para 'check'
  const Task({
    required this.id, // Parâmetro obrigatório para o identificador
    required this.description, // Parâmetro obrigatório para a descrição
    this.check =
        false, // Parâmetro opcional para o estado de conclusão, com valor padrão 'false'
  });

  // Sobrescrevendo o método 'props' para indicar quais propriedades devem ser consideradas na comparação de igualdade
  @override
  List<Object?> get props => [
        id,
        description,
        check,
      ];

  // Método para criar uma cópia da tarefa com possibilidade de alterar atributos específicos
  Task copyWith({
    int? id,
    String? description,
    bool? check,
  }) {
    return Task(
      id: id ?? this.id, // Se 'id' não for fornecido, mantém o valor atual
      description: description ??
          this.description, // Se 'description' não for fornecido, mantém o valor atual
      check: check ??
          this.check, // Se 'check' não for fornecido, mantém o valor atual
    );
  }
}
