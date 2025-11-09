import 'package:hive/hive.dart';
import '../models/treino.dart';

class TreinoRepository {
  static const String boxName = 'treinos';

  // Abre (ou recupera) a box do Hive
  Future<Box<Treino>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<Treino>(boxName);
    }
    return Hive.box<Treino>(boxName);
  }

  // CREATE — adiciona um novo treino
  Future<void> addTreino(Treino treino) async {
    final box = await _getBox();
    await box.put(treino.id, treino);
  }

  // READ — lista todos os treinos
  Future<List<Treino>> getAllTreinos() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // READ — busca um treino pelo ID
  Future<Treino?> getTreinoById(int id) async {
    final box = await _getBox();
    return box.get(id);
  }
}
