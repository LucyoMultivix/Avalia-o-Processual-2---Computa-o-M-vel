import 'package:hive/hive.dart';
import '../models/aluno.dart';

class AlunoRepository {
  static const String boxName = 'alunos';

  // Abre (ou recupera) a box do Hive
  Future<Box<Aluno>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<Aluno>(boxName);
    }
    return Hive.box<Aluno>(boxName);
  }

  //CREATE — adiciona um novo aluno
  Future<void> addAluno(Aluno aluno) async {
    final box = await _getBox();
    await box.put(aluno.id, aluno);
  }

  //READ — lista todos os alunos
  Future<List<Aluno>> getAllAlunos() async {
    final box = await _getBox();
    return box.values.toList();
  }

  //READ — busca um aluno pelo ID
  Future<Aluno?> getAlunoById(int id) async {
    final box = await _getBox();
    return box.get(id);
  }
}
