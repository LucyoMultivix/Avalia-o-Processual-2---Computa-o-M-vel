import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/treino.dart';

class TreinoRepository {
  static const String boxName = 'treinos';

  Box<Treino> get _box => Hive.box<Treino>(boxName);

  Future<void> addTreinoAuto(Treino treino) async {
    await _box.add(treino);
  }

  Future<List<Treino>> getAllTreinos() async {
    return _box.values.toList();
  }

  Future<void> updateTreino(Treino treino) async {
    await treino.save();
  }

  Future<void> deleteTreino(Treino treino) async {
    await treino.delete();
  }
}
