import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'treino.dart';

part 'aluno.g.dart';

@HiveType(typeId: 1)
class Aluno extends HiveObject {
  @HiveField(0)
  String nome;

  @HiveField(1)
  int idade;

  @HiveField(2)
  double peso;

  @HiveField(3)
  List<Treino> treinos;

  @HiveField(4)
  String registro; // substitui o id

  Aluno({
    required this.nome,
    required this.idade,
    required this.peso,
    required this.treinos,
    required this.registro,
  });
}

