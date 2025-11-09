import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/aluno.dart';

class AlunoRepository {
  static const String boxName = 'alunos';

  // Pega a box já aberta no main.dart
  Box<Aluno> get _box => Hive.box<Aluno>(boxName);

  Future<void> addAlunoAuto(Aluno aluno) async {
    await _box.add(aluno);
  }

  Future<List<Aluno>> getAllAlunos() async {
    return _box.values.toList();
  }

  Future<void> updateAluno(Aluno aluno) async {
    await aluno.save();
  }

  Future<void> deleteAluno(Aluno aluno) async {
    await aluno.delete();
  }
}
