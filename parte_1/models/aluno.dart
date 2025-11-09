import 'package:hive/hive.dart';
import 'treino.dart';

part 'aluno.g.dart';

@HiveType(typeId: 1)
class Aluno {
  @HiveField(0)
  int id;

  @HiveField(1)
  String nome;

  @HiveField(2)
  int idade;

  @HiveField(3)
  double peso;

  @HiveField(4)
  List<Treino> treinos;

  Aluno({
    required this.id,
    required this.nome,
    required this.idade,
    required this.peso,
    required this.treinos,
  });
}
