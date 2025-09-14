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
  DateTime? dataAgendamento;
  TimeOfDay? horaAgendamento;
  List<Agendamento> agendamentos = [];
  List<Item> itensAgendamento = [];
  Agendamento? agendamentoEditando;
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
    });
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
    Agendamento a = agendamentos[idx];

    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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

                      },
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                  },
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
                        onPressed: () {

                        },
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
                        onPressed: _limparCampos,
                        icon: const Icon(Icons.check),
                        label: const Text("Confirmar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: _limparCampos,
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text("Cancelar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Clientes agendados:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: agendamentos.length,
                      itemBuilder: (ctx, idx) => _criarItem(idx),
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
}
