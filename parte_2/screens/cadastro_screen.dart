import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/aluno.dart';
import '../models/treino.dart';
import '../providers/aluno_provider.dart';
import '../providers/treino_provider.dart';

class CadastroScreen extends StatefulWidget {
  final Aluno? aluno;

  const CadastroScreen({super.key, this.aluno});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeCtrl = TextEditingController();
  final _idadeCtrl = TextEditingController();
  final _pesoCtrl = TextEditingController();

  final Set<Treino> treinosSelecionados = {};

  @override
  void initState() {
    super.initState();
    final aluno = widget.aluno;
    if (aluno != null) {
      _nomeCtrl.text = aluno.nome;
      _idadeCtrl.text = aluno.idade.toString();
      _pesoCtrl.text = aluno.peso.toString();

      treinosSelecionados.clear();
      treinosSelecionados.addAll(aluno.treinos);
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _idadeCtrl.dispose();
    _pesoCtrl.dispose();
    super.dispose();
  }

  Future<void> salvarAluno(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final alunoProvider = context.read<AlunoProvider>();
    final listaTreinos = treinosSelecionados.toList();
    final isEdicao = widget.aluno != null;

    if (isEdicao && widget.aluno != null) {
      final aluno = widget.aluno!;
      aluno.nome = _nomeCtrl.text;
      aluno.idade = int.tryParse(_idadeCtrl.text) ?? 0;
      aluno.peso = double.tryParse(_pesoCtrl.text) ?? 0.0;
      await alunoProvider.atualizarTreinos(aluno, listaTreinos);
    } else {
      final novoAluno = Aluno(
        nome: _nomeCtrl.text,
        idade: int.tryParse(_idadeCtrl.text) ?? 0,
        peso: double.tryParse(_pesoCtrl.text) ?? 0.0,
        registro: DateTime.now().millisecondsSinceEpoch.toString(),
        treinos: listaTreinos,
      );
      await alunoProvider.adicionarAluno(novoAluno);
    }

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final treinos = context.watch<TreinoProvider>().treinos;
    final isEdicao = widget.aluno != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Aluno' : 'Cadastrar Aluno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeCtrl,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: _idadeCtrl,
                    decoration: const InputDecoration(labelText: 'Idade'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Campo obrigatório';
                      if (int.tryParse(v) == null) return 'Idade inválida';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _pesoCtrl,
                    decoration: const InputDecoration(labelText: 'Peso (kg)'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Campo obrigatório';
                      if (double.tryParse(v) == null) return 'Peso inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => salvarAluno(context),
                    child: Text(isEdicao ? 'Salvar Alterações' : 'Cadastrar Aluno'),
                  ),
                ],
              ),
            ),
            const Divider(height: 40),
            const Text(
              'Treinos Disponíveis',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...treinos.map(
              (t) => CheckboxListTile(
                title: Text(t.nome),
                subtitle: Text('${t.descricao} - ${t.repeticoes} reps, ${t.carga}kg'),
                value: treinosSelecionados.contains(t),
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      treinosSelecionados.add(t);
                    } else {
                      treinosSelecionados.remove(t);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
