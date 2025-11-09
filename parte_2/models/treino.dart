import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'treino.g.dart';

@HiveType(typeId: 0)
class Treino extends HiveObject {
  @HiveField(0)
  String nome;

  @HiveField(1)
  String descricao;

  @HiveField(2)
  int repeticoes;

  @HiveField(3)
  double carga;

  @HiveField(4)
  String codigo;

  Treino({
    required this.nome,
    required this.descricao,
    required this.repeticoes,
    required this.carga,
    required this.codigo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Treino &&
          runtimeType == other.runtimeType &&
          codigo == other.codigo;

  @override
  int get hashCode => codigo.hashCode;
}

