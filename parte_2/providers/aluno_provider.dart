import 'package:flutter/material.dart';
import '../models/aluno.dart';
import '../models/treino.dart';
import '../repositories/aluno_repository.dart';

class AlunoProvider extends ChangeNotifier {
  final AlunoRepository _repository = AlunoRepository();

  List<Aluno> _alunos = [];
  List<Aluno> get alunos => _alunos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> carregarAlunos() async {
    _isLoading = true;
    notifyListeners();

    _alunos = await _repository.getAllAlunos();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> adicionarAluno(Aluno aluno) async {
    await _repository.addAlunoAuto(aluno);
    await carregarAlunos();
  }

  Future<void> atualizarAluno(Aluno aluno) async {
    await _repository.updateAluno(aluno);
    await carregarAlunos();
  }

  Future<void> deletarAluno(Aluno aluno) async {
    await _repository.deleteAluno(aluno);
    await carregarAlunos();
  }

  /// Atualiza apenas os treinos de um aluno, substituindo a lista inteira
  Future<void> atualizarTreinos(Aluno aluno, List<Treino> novosTreinos) async {
    aluno.treinos = List<Treino>.from(novosTreinos); // cria nova instância
    await _repository.updateAluno(aluno);
    await carregarAlunos();
  }
}
