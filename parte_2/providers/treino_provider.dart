import 'package:flutter/material.dart';
import '../models/treino.dart';
import '../repositories/treino_repository.dart';

class TreinoProvider extends ChangeNotifier {
  final TreinoRepository _repository = TreinoRepository();

  List<Treino> _treinos = [];
  List<Treino> get treinos => _treinos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> carregarTreinos() async {
    _isLoading = true;
    notifyListeners();

    _treinos = await _repository.getAllTreinos();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> adicionarTreino(Treino treino) async {
    await _repository.addTreinoAuto(treino);
    await carregarTreinos();
  }

  Future<void> atualizarTreino(Treino treino) async {
    await _repository.updateTreino(treino);
    await carregarTreinos();
  }

  Future<void> deletarTreino(Treino treino) async {
    await _repository.deleteTreino(treino);
    await carregarTreinos();
  }
}
