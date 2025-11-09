import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/treino.dart';
import '../providers/treino_provider.dart';

class CadastroTreinoScreen extends StatefulWidget {
  final Treino? treino; // argumento opcional

  const CadastroTreinoScreen({super.key, this.treino});

  @override
  State<CadastroTreinoScreen> createState() => _CadastroTreinoScreenState();
}

class _CadastroTreinoScreenState extends State<CadastroTreinoScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final repeticoesController = TextEditingController();
  final cargaController = TextEditingController();
  final codigoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final treino = widget.treino;
    if (treino != null) {
      nomeController.text = treino.nome;
      descricaoController.text = treino.descricao;
      repeticoesController.text = treino.repeticoes.toString();
      cargaController.text = treino.carga.toString();
      codigoController.text = treino.codigo;
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    repeticoesController.dispose();
    cargaController.dispose();
    codigoController.dispose();
    super.dispose();
  }

  Future<void> salvarTreino(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final treinoProvider = context.read<TreinoProvider>();

    if (widget.treino != null) {
      // Atualizar treino existente
      final treino = widget.treino!;
      treino.nome = nomeController.text;
      treino.descricao = descricaoController.text;
      treino.repeticoes = int.tryParse(repeticoesController.text) ?? 0;
      treino.carga = double.tryParse(cargaController.text) ?? 0.0;
      treino.codigo = codigoController.text;

      await treinoProvider.atualizarTreino(treino);
    } else {
      // Criar novo treino
      final novoTreino = Treino(
        nome: nomeController.text,
        descricao: descricaoController.text,
        repeticoes: int.tryParse(repeticoesController.text) ?? 0,
        carga: double.tryParse(cargaController.text) ?? 0.0,
        codigo: codigoController.text,
      );
      await treinoProvider.adicionarTreino(novoTreino);
    }

    if (context.mounted) Navigator.pop(context);
  }

  Future<bool?> confirmarExclusaoTreino(BuildContext context, Treino treino) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: Text('Deseja realmente excluir o treino "${treino.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final treinoProvider = context.watch<TreinoProvider>();
    final treinos = treinoProvider.treinos;
    final isEdicao = widget.treino != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdicao ? 'Editar Treino' : 'Cadastrar Treino')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Formulário de Treino',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome do Treino'),
                    validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: descricaoController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: repeticoesController,
                    decoration: const InputDecoration(labelText: 'Repetições'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: cargaController,
                    decoration: const InputDecoration(labelText: 'Carga (kg)'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: codigoController,
                    decoration: const InputDecoration(labelText: 'Código'),
                    validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => salvarTreino(context),
                    child: Text(isEdicao ? 'Salvar Alterações' : 'Cadastrar Treino'),
                  ),
                ],
              ),
            ),
            const Divider(height: 40),
            const Text(
              'Treinos Existentes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            treinos.isEmpty
                ? const Text('Nenhum treino cadastrado.')
                : Column(
                    children: treinos.map((t) {
                      return ListTile(
                        title: Text(t.nome),
                        subtitle: Text('${t.descricao} - ${t.repeticoes} reps, ${t.carga}kg'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/cadastro_treino',
                                  arguments: t,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirmar =
                                    await confirmarExclusaoTreino(context, t);
                                if (confirmar == true) {
                                  await treinoProvider.deletarTreino(t);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
