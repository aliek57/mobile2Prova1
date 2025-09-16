import 'package:ex2/agendamento.dart';
import 'package:ex2/item.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercicio 2 da Prova 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Agenda'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController descricaoController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController modeloController = TextEditingController();
  TextEditingController placaController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController horaController = TextEditingController();
  TextEditingController itemNomeController = TextEditingController();
  TextEditingController itemValorController = TextEditingController();
  DateTime? dataAgendamento;
  TimeOfDay? horaAgendamento;
  List<Agendamento> agendamentos = [];
  List<Agendamento> agendamentosExibidos = [];
  Agendamento? agendamentoSelecionado;
  Agendamento? agendamentoEditando;
  Item? itemEditando;
  bool recebido = false;

  void _mostrarMensagem(String msg, int tempo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: tempo),
      ),
    );
  }

  void _limparCampos() {
    setState(() {
      descricaoController.text = "";
      nomeController.text = "";
      enderecoController.text = "";
      telefoneController.text = "";
      modeloController.text = "";
      placaController.text = "";
      dataController.text = "";
      horaController.text = "";
      dataAgendamento = null;
      horaAgendamento = null;
      recebido = false;
      agendamentoEditando = null;
    });
  }

  void _confirmar() {
    if (agendamentoEditando != null) {
      _confirmarEdicao();
    } else {
      _confirmarAgendamento();
    }
  }

  void _confirmarAgendamento() {
    if (descricaoController.text.isEmpty || nomeController.text.isEmpty ||
        enderecoController.text.isEmpty || telefoneController.text.isEmpty ||
        modeloController.text.isEmpty || placaController.text.isEmpty ||
        dataAgendamento == null || horaAgendamento == null) {
      _mostrarMensagem("Por favor, preencha todos os campos.", 3);
      return;
    }

    DateTime dataEHora = DateTime(dataAgendamento!.year, dataAgendamento!.month,
                                  dataAgendamento!.day, horaAgendamento!.hour, horaAgendamento!.minute);

    Agendamento novoAgendamento = Agendamento(
      descricaoController.text, nomeController.text, enderecoController.text,
      telefoneController.text, modeloController.text,
      placaController.text, dataEHora,
      0.0, recebido,
      false, [],
    );

    setState(() {
      agendamentos.add(novoAgendamento);
      agendamentosExibidos.add(novoAgendamento);
    });

    _limparCampos();
    _mostrarMensagem("Agendamento adicionado com sucesso!", 3);
  }

  void _confirmarEdicao() {
    if (agendamentoEditando != null) {
      agendamentoEditando!.clienteNome = nomeController.text;
      agendamentoEditando!.clienteEndereco = enderecoController.text;
      agendamentoEditando!.clienteTelefone = telefoneController.text;
      agendamentoEditando!.veiculoModelo = modeloController.text;
      agendamentoEditando!.veiculoPlaca = placaController.text;
      if (dataAgendamento != null && horaAgendamento != null) {
        agendamentoEditando!.dataHora = DateTime(
          dataAgendamento!.year, dataAgendamento!.month,
          dataAgendamento!.day, horaAgendamento!.hour, horaAgendamento!.minute,
        );
      }
      setState(() {
        agendamentoEditando = null;
        _limparCampos();
      });
      _mostrarMensagem("Agendamento atualizado com sucesso!", 3);
    }
  }

  void _cancelar() {
    if (agendamentoEditando != null) {
      _cancelarEdicao();
    } else {
      _limparCampos();
    }
  }

  void _cancelarEdicao() {
    setState(() {
      agendamentoEditando = null;
      _limparCampos();
    });
    _mostrarMensagem("Edição cancelada.", 3);
  }

  void _selecionarAgendamento(Agendamento agendamento) {
    setState(() {
      agendamentoSelecionado = agendamento;
    });
  }

  void _editarAgendamento(Agendamento agendamento) {
    setState(() {
      agendamentoEditando = agendamento;
      descricaoController.text = agendamento.descricao ?? "";
      nomeController.text = agendamento.clienteNome ?? "";
      enderecoController.text = agendamento.clienteEndereco ?? "";
      telefoneController.text = agendamento.clienteTelefone ?? "";
      modeloController.text = agendamento.veiculoModelo ?? "";
      placaController.text = agendamento.veiculoPlaca ?? "";
      dataAgendamento = agendamento.dataHora;
      horaAgendamento = TimeOfDay.fromDateTime(agendamento.dataHora!);
      dataController.text = "${dataAgendamento!.day.toString().padLeft(2, '0')}/${dataAgendamento!.month.toString().padLeft(2, '0')}/${dataAgendamento!.year}";
      horaController.text = "${horaAgendamento!.hour.toString().padLeft(2, '0')}:${horaAgendamento!.minute.toString().padLeft(2, '0')}";
      recebido = agendamento.recebido ?? false;
    });
  }

  void _adicionarItem() {
    if (agendamentoSelecionado == null) {
      _mostrarMensagem("Selecione um agendamento para adicionar itens.", 3);
      return;
    }
    if (itemNomeController.text.isEmpty || itemValorController.text.isEmpty) {
      _mostrarMensagem("Preencha o nome e o valor do item.", 3);
      return;
    }
    double? valor = double.tryParse(itemValorController.text);
    if (valor == null) {
      _mostrarMensagem("Valor inválido.", 3);
      return;
    }

    Item novoItem = Item(itemNomeController.text, valor, false);
    setState(() {
      agendamentoSelecionado!.servicos!.add(novoItem);
      _atualizarValorTotal(agendamentoSelecionado!);
      itemNomeController.text = "";
      itemValorController.text = "";
    });
  }

  Future<void> _modalConfirmacao( String titulo, String conteudo, Function acao ) async {
    bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(conteudo),
          actions: <Widget>[
            TextButton( child: const Text("Sim"), onPressed: () { Navigator.of(context).pop(true); },),
            TextButton( child: const Text("Não"), onPressed: () { Navigator.of(context).pop(false); },),
          ],
        );
      },
    );

    if (confirmar == true) {
      acao();
    }
  }

  void _removerAgendamento(Agendamento agendamento) {
    _modalConfirmacao(
      "Confirmar Cancelamento",
      "Tem certeza que deseja cancelar este agendamento?",
          () {
        setState(() {
          agendamentos.remove(agendamento);
          agendamentosExibidos.remove(agendamento);
        });
        _mostrarMensagem("Agendamento cancelado com sucesso!", 3);
      },
    );
  }

  void _removerItem(Agendamento agendamento, Item item) {
    _modalConfirmacao(
      "Confirmar Remoção",
      "Tem certeza que deseja remover o item '${item.nome}'?",
          () {
            setState(() {
              agendamentoSelecionado!.servicos!.remove(item);
              _atualizarValorTotal(agendamentoSelecionado!);
            });
            _mostrarMensagem("Item removido com sucesso!", 3);
          },
    );
  }

  void _atualizarValorTotal(Agendamento agendamento) {
    double total = 0.0;
    for (var item in agendamento.servicos!) {
      total += item.valor!;
    }
    setState(() {
      agendamento.valorTotal = total;
    });
  }

  void _buscarAgendamentos() {
    if (dataAgendamento == null) {
      _mostrarMensagem("Selecione uma data para pesquisar.", 3);
      return;
    }

    List<Agendamento> resultados = agendamentos.where((agendamento) {
      return agendamento.dataHora!.year == dataAgendamento!.year &&
              agendamento.dataHora!.month == dataAgendamento!.month &&
              agendamento.dataHora!.day == dataAgendamento!.day;
    }).toList();

    setState(() {
      agendamentosExibidos = resultados;
    });

    if (resultados.isEmpty) {
      _mostrarMensagem("Nenhum agendamento encontrado para esta data.", 3);
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (dataEscolhida != null) {
      setState(() {
        dataAgendamento = dataEscolhida;
        dataController.text = "${dataAgendamento!.day.toString().padLeft(2, '0')}/${dataAgendamento!.month.toString().padLeft(2, '0')}/${dataAgendamento!.year}";
      });
    }
  }

  Future<void> _selecionarHora(BuildContext context) async {
    final TimeOfDay? horaEscolhida = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horaEscolhida != null) {
      setState(() {
        horaAgendamento = horaEscolhida;
        horaController.text = "${horaAgendamento!.hour.toString().padLeft(2, '0')}:${horaAgendamento!.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Widget _criarItem(int idx) {
    Agendamento a = agendamentosExibidos[idx];

    return GestureDetector(
      onTap: () => _selecionarAgendamento(a),
      onLongPress: () => _editarAgendamento(a),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: a == agendamentoSelecionado ? Colors.deepPurple[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${a.dataHora!.day.toString().padLeft(2, '0')}/${a.dataHora!.month.toString().padLeft(2, '0')}/${a.dataHora!.year} - ${a.dataHora!.hour.toString().padLeft(2, '0')}:${a.dataHora!.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Veículo: ${a.veiculoModelo}"),
                  Text("Placa: ${a.veiculoPlaca}"),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cliente: ${a.clienteNome}"),
                  Text("Telefone: ${a.clienteTelefone}"),
                  Text("Valor: R\$ ${a.valorTotal!.toStringAsFixed(2)}"),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Recebido"),
                      Switch(
                        value: a.recebido!,
                        onChanged: (bool value) {
                          setState(() {
                            a.recebido = value;
                          });
                        },
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _removerAgendamento(a),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text("Cancelar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _criarItemServico(int idx) {
    if (agendamentoSelecionado == null || agendamentoSelecionado!.servicos == null) {
      return Container();
    }
    Item item = agendamentoSelecionado!.servicos![idx];

    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child:
                  Text(item.nome ?? "")),
                  const SizedBox(width: 10),
                  const Text("Executado"),
                  Switch(
                    value: item.executado ?? false,
                    onChanged: (bool value) {
                      setState(() {
                        item.executado = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(width: 20),
          Text("R\$ ${item.valor!.toStringAsFixed(2)}"),
          IconButton(
            onPressed: () => _removerItem(agendamentoSelecionado!, item),
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: descricaoController,
                    decoration: const InputDecoration(labelText: "Descrição"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: "Cliente"),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: enderecoController,
                          decoration: const InputDecoration(labelText: "Endereço"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: telefoneController,
                          decoration: const InputDecoration(labelText: "Telefone"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: modeloController,
                          decoration: const InputDecoration(labelText: "Veículo"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: placaController,
                          decoration: const InputDecoration(labelText: "Placa"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: dataController,
                          decoration: const InputDecoration(labelText: "Data"),
                          readOnly: true,
                          onTap: () => _selecionarData(context),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _selecionarData(context),
                        icon: const Icon(Icons.calendar_month),
                      ),
                      IconButton(
                        onPressed: _buscarAgendamentos,
                        icon: const Icon(Icons.search),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: horaController,
                          decoration: const InputDecoration(labelText: "Hora"),
                          readOnly: true,
                          onTap: () => _selecionarHora(context),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _selecionarHora(context),
                        icon: const Icon(Icons.access_time),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("Recebido"),
                      Switch(
                        value: recebido,
                        onChanged: (bool value) {
                          setState(() {
                            recebido = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _confirmar,
                        icon: const Icon(Icons.check),
                        label: const Text("Confirmar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: _cancelar,
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text("Cancelar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Clientes agendados:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: agendamentosExibidos.length,
                itemBuilder: (ctx, idx) => _criarItem(idx),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Produtos e serviços realizados:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: itemNomeController,
                    decoration: const InputDecoration(labelText: "Produto ou Serviço"),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: itemValorController,
                    decoration: const InputDecoration(labelText: "Valor"),
                  ),
                ),
                IconButton(
                  onPressed: _adicionarItem,
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: agendamentoSelecionado != null && agendamentoSelecionado!.servicos != null
                  ? ListView.builder(
                itemCount: agendamentoSelecionado!.servicos!.length,
                itemBuilder: (ctx, idx) => _criarItemServico(idx),
              )
                  : const Center(
                child: Text("Selecione um agendamento para ver os itens."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}