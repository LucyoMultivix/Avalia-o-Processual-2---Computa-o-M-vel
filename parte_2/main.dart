import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/aluno.dart';
import 'models/treino.dart';
import 'providers/aluno_provider.dart';
import 'providers/treino_provider.dart';
import 'screens/listagem_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/cadastro_treino_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive
  await Hive.initFlutter();

  // Registra adapters
  Hive.registerAdapter(TreinoAdapter());
  Hive.registerAdapter(AlunoAdapter());

  // Abre boxes
  final alunosBox = await Hive.openBox<Aluno>('alunos');
  final treinosBox = await Hive.openBox<Treino>('treinos');

  // Inicializa dados se estiver vazio
  await inicializarDados(treinosBox, alunosBox);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlunoProvider()..carregarAlunos()),
        ChangeNotifierProvider(create: (_) => TreinoProvider()..carregarTreinos()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> inicializarDados(Box<Treino> treinosBox, Box<Aluno> alunosBox) async {
  if (treinosBox.isEmpty) {
    final treino1 = Treino(nome: 'Supino', descricao: 'Peito', repeticoes: 10, carga: 50, codigo: 'T001');
    final treino2 = Treino(nome: 'Agachamento', descricao: 'Pernas', repeticoes: 12, carga: 70, codigo: 'T002');
    final treino3 = Treino(nome: 'Remada', descricao: 'Costas', repeticoes: 10, carga: 40, codigo: 'T003');
    final treino4 = Treino(nome: 'Rosca Bíceps', descricao: 'Braço', repeticoes: 15, carga: 20, codigo: 'T004');
    final treino5 = Treino(nome: 'Tríceps Corda', descricao: 'Braço', repeticoes: 12, carga: 15, codigo: 'T005');
    final treino6 = Treino(nome: 'Abdominal', descricao: 'Core', repeticoes: 20, carga: 0, codigo: 'T006');

    await treinosBox.addAll([treino1, treino2, treino3, treino4, treino5, treino6]);
  }

  if (alunosBox.isEmpty) {
    final todosTreinos = treinosBox.values.toList();

    final heitor = Aluno(nome: 'Heitor', idade: 25, peso: 75, registro: 'A001',
        treinos: [todosTreinos[0], todosTreinos[1], todosTreinos[2]]);

    final maria = Aluno(nome: 'Maria', idade: 22, peso: 60, registro: 'A002',
        treinos: [todosTreinos[2], todosTreinos[3], todosTreinos[4]]);

    final lucyo = Aluno(nome: 'Lucyo', idade: 30, peso: 80, registro: 'A003',
        treinos: [todosTreinos[1], todosTreinos[4], todosTreinos[5]]);

    await alunosBox.addAll([heitor, maria, lucyo]);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academia Hive',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const ListagemScreen());

          case '/cadastro':
            // Se estiver editando um aluno, ele vem como argumento
            final aluno = settings.arguments as Aluno?;
            return MaterialPageRoute(
              builder: (_) => CadastroScreen(aluno: aluno),
            );

          case '/cadastro_treino':
            final treino = settings.arguments as Treino?;
            return MaterialPageRoute(
              builder: (_) => CadastroTreinoScreen(treino: treino),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Rota não encontrada')),
              ),
            );
        }
      },
    );
  }
}
