import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'edicao_view.dart';

class InicioView extends StatefulWidget {
  const InicioView({Key? key}) : super(key: key);

  @override
  _InicioViewState createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  List<Map<String, dynamic>> tarefas = [
    {'titulo': 'Consulta Médica', 'descricao': 'Ir ao médico.', 'status': 'pendente', 'prazo': DateTime.now()},
    {'titulo': 'Fazer almoço', 'descricao': 'Lasanha e arroz com cenoura.', 'status': 'completa', 'prazo': DateTime.now()},
    {'titulo': 'Ir à escola', 'descricao': 'Força pra ir.', 'status': 'pendente', 'prazo': DateTime.now()},
  ];

  void _adicionarOuEditarTarefa(Map<String, dynamic> novaTarefa, int? index) {
    setState(() {
      if (index == null) {
        tarefas.add(novaTarefa);
      } else {
        tarefas[index] = novaTarefa;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          return GestureDetector(
            onDoubleTap: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: 'Excluir Tarefa',
                text: 'Deseja realmente excluir esta tarefa?',
                confirmBtnText: 'Sim',
                cancelBtnText: 'Não',
                onConfirmBtnTap: () {
                  setState(() {
                    tarefas.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              );
            },
            child: Card(
              child: ListTile(
                title: Text(tarefa['titulo']),
                subtitle: Text(tarefa['descricao']),
                trailing: Icon(
                  tarefa['status'] == 'completa' ? Icons.check_circle : Icons.circle,
                  color: tarefa['status'] == 'completa' ? Colors.green : Colors.red,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EdicaoView(
                        tarefa: tarefa,
                        index: index,
                        onSave: _adicionarOuEditarTarefa,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EdicaoView(
                onSave: _adicionarOuEditarTarefa,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
