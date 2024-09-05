import 'package:flutter/material.dart';

class EdicaoView extends StatefulWidget {
  final Map<String, dynamic>? tarefa;
  final int? index;
  final Function(Map<String, dynamic>, int?) onSave;

  const EdicaoView({Key? key, this.tarefa, this.index, required this.onSave}) : super(key: key);

  @override
  _EdicaoViewState createState() => _EdicaoViewState();
}

class _EdicaoViewState extends State<EdicaoView> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime? _prazo;
  TimeOfDay? _hora;

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _tituloController.text = widget.tarefa!['titulo'];
      _descricaoController.text = widget.tarefa!['descricao'];
      _prazo = widget.tarefa!['prazo'];
      _hora = TimeOfDay(hour: _prazo!.hour, minute: _prazo!.minute);
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarefa == null ? 'Adicionar Tarefa' : 'Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _prazo == null
                        ? 'Nenhum prazo definido'
                        : 'Prazo: ${_prazo!.day}/${_prazo!.month}/${_prazo!.year} às ${_hora?.format(context)}',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final dataSelecionada = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (dataSelecionada != null) {
                      final horaSelecionada = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (horaSelecionada != null) {
                        setState(() {
                          _prazo = DateTime(
                            dataSelecionada.year,
                            dataSelecionada.month,
                            dataSelecionada.day,
                            horaSelecionada.hour,
                            horaSelecionada.minute,
                          );
                          _hora = horaSelecionada;
                        });
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final novaTarefa = {
                  'titulo': _tituloController.text,
                  'descricao': _descricaoController.text,
                  'status': 'pendente',
                  'prazo': _prazo,
                };
                widget.onSave(novaTarefa, widget.index);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
