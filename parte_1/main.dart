import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/aluno.dart';
import 'models/treino.dart';
import 'repositories/aluno_repository.dart';
import 'repositories/treino_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive
  await Hive.initFlutter();

  // Registra os adapters
  Hive.registerAdapter(TreinoAdapter());
  Hive.registerAdapter(AlunoAdapter());

  // Abre as boxes
  await Hive.openBox<Aluno>('alunos');
  await Hive.openBox<Treino>('treinos');

  // Inicializa os repositórios
  final alunoRepo = AlunoRepository();
  final treinoRepo = TreinoRepository();

  // ===== CRIAÇÃO DOS TREINOS =====
  final treino1 = Treino(id: 1, nome: 'Supino Reto', descricao: '3x10', repeticoes: 10, carga: 40.0);
  final treino2 = Treino(id: 2, nome: 'Agachamento', descricao: '3x12', repeticoes: 12, carga: 60.0);
  final treino3 = Treino(id: 3, nome: 'Remada Curvada', descricao: '3x10', repeticoes: 10, carga: 35.0);
  final treino4 = Treino(id: 4, nome: 'Leg Press', descricao: '3x15', repeticoes: 15, carga: 80.0);
  final treino5 = Treino(id: 5, nome: 'Rosca Direta', descricao: '3x12', repeticoes: 12, carga: 20.0);
  final treino6 = Treino(id: 6, nome: 'Tríceps Testa', descricao: '3x10', repeticoes: 10, carga: 25.0);

  // ===== ADICIONA OS TREINOS NO HIVE =====
  await treinoRepo.addTreino(treino1);
  await treinoRepo.addTreino(treino2);
  await treinoRepo.addTreino(treino3);
  await treinoRepo.addTreino(treino4);
  await treinoRepo.addTreino(treino5);
  await treinoRepo.addTreino(treino6);

  // ===== CRIAÇÃO DOS ALUNOS =====
  final aluno1 = Aluno(
    id: 1,
    nome: 'João Silva',
    idade: 25,
    peso: 75.5,
    treinos: [treino1, treino2, treino3],
  );

  final aluno2 = Aluno(
    id: 2,
    nome: 'Maria Souza',
    idade: 28,
    peso: 62.0,
    treinos: [treino4, treino5, treino6],
  );

  // ===== ADICIONA OS ALUNOS NO HIVE =====
  await alunoRepo.addAluno(aluno1);
  await alunoRepo.addAluno(aluno2);

  // ===== LEITURA DO BANCO =====
  print('===== ALUNOS CADASTRADOS =====');
  final alunos = await alunoRepo.getAllAlunos();
  for (var aluno in alunos) {
    print('Aluno: ${aluno.nome}, Idade: ${aluno.idade}, Peso: ${aluno.peso}kg');
    print('Treinos:');
    for (var treino in aluno.treinos) {
      print(' - ${treino.nome}: ${treino.descricao}, ${treino.repeticoes} reps, ${treino.carga}kg');
    }
    print('---');
  }

  // ===== LISTAR TODOS OS TIPOS DE TREINOS =====
  print('===== TIPOS DE TREINOS DISPONÍVEIS =====');
  final treinos = await treinoRepo.getAllTreinos();
  for (var treino in treinos) {
    print('${treino.nome}: ${treino.descricao}, ${treino.repeticoes} reps, ${treino.carga}kg');
  }

  // ===== Roda o App (tela simples) =====
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academia Hive',
      home: Scaffold(
        appBar: AppBar(title: const Text('Academia Hive')),
        body: const Center(
          child: Text('Veja o console para os alunos e treinos cadastrados 💪'),
        ),
      ),
    );
  }
}
