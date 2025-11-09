import 'package:hive/hive.dart';

part 'treino.g.dart';

@HiveType(typeId: 0)
class Treino {
  @HiveField(0)
  int id;

  @HiveField(1)
  String nome;

  @HiveField(2)
  String descricao;

  @HiveField(3)
  int repeticoes;

  @HiveField(4)
  double carga;

  Treino({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.repeticoes,
    required this.carga,
  });
}
