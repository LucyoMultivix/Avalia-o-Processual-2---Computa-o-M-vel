import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/aluno_provider.dart';
import '../models/aluno.dart';
import '../models/treino.dart';

class ListagemScreen extends StatelessWidget {
  const ListagemScreen({super.key});

  Future<bool?> confirmarExclusao(BuildContext context, Aluno aluno) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: Text('Deseja realmente excluir o aluno "${aluno.nome}"?'),
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
    final provider = context.watch<AlunoProvider>();
    final alunos = provider.alunos;

    return Scaffold(
      appBar: AppBar(title: const Text('Alunos e Treinos')),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'novo_aluno',
            icon: const Icon(Icons.person_add),
            label: const Text('Novo Aluno'),
            onPressed: () async {
              await Navigator.pushNamed(context, '/cadastro');
            },
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'novo_treino',
            icon: const Icon(Icons.fitness_center),
            label: const Text('Novo Treino'),
            onPressed: () async {
              await Navigator.pushNamed(context, '/cadastro_treino');
            },
          ),
        ],
      ),
      body: alunos.isEmpty
          ? const Center(child: Text('Nenhum aluno cadastrado.'))
          : ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                final aluno = alunos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nome do aluno
                        Expanded(
                          child: Text(aluno.nome),
                        ),
                        // Botões de editar e excluir
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/cadastro',
                                  arguments: aluno,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirmar =
                                    await confirmarExclusao(context, aluno);
                                if (confirmar == true) {
                                  await context
                                      .read<AlunoProvider>()
                                      .deletarAluno(aluno);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Text('Idade: ${aluno.idade}, Peso: ${aluno.peso}kg'),
                    children: [
                      // Lista os treinos do aluno
                      if (aluno.treinos.isEmpty)
                        const ListTile(
                          title: Text('Nenhum treino cadastrado'),
                        )
                      else
                        ...aluno.treinos.map((Treino treino) => ListTile(
                              title: Text(treino.nome),
                              subtitle: Text(
                                  '${treino.descricao} - ${treino.repeticoes} rep. - ${treino.carga} kg'),
                            )),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
