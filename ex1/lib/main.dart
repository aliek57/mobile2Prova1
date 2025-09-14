import 'package:flutter/material.dart';
import 'package:ex1/parcela.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador Financiamento',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Simulador Financiamento'),
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
  TextEditingController totalController = TextEditingController();
  TextEditingController entradaController = TextEditingController();
  TextEditingController jurosController = TextEditingController();
  TextEditingController parcelasController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  DateTime? dataPrimeiraParcela;
  List<Parcela> parcelas = [];

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
      totalController.text = "";
      entradaController.text = "";
      jurosController.text = "";
      parcelasController.text = "";
      dataController.text = "";
      dataPrimeiraParcela = null;
      parcelas = [];
    });
  }

  Future<void> _selecionarData() async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now().add(const Duration(days: 30)),
      lastDate: DateTime(2101),
      helpText: "Selecione a data da 1ª parcela",
    );
    if (dataEscolhida != null) {
      setState(() {
        dataPrimeiraParcela = dataEscolhida;
        dataController.text = "${dataPrimeiraParcela!.day.toString().padLeft(2, '0')}/${dataPrimeiraParcela!.month.toString().padLeft(2, '0')}/${dataPrimeiraParcela!.year}";
      });
    }
  }

  void _calcularFinanciamento() {
    try {
      if (totalController.text.isEmpty || entradaController.text.isEmpty ||
          jurosController.text.isEmpty || parcelasController.text.isEmpty ||
          dataController.text.isEmpty) {
        _mostrarMensagem("Por favor, preencha todos os campos.", 3);
        return;
      }

      double total = double.parse(totalController.text);
      double entrada = double.parse(entradaController.text);
      double jurosMensal = double.parse(jurosController.text) / 100;
      int numParcelas = int.parse(parcelasController.text);

      if (total <= 0 || entrada < 0 || numParcelas <= 0) {
        _mostrarMensagem("Valores numéricos inválidos.", 4);
        return;
      }

      double saldoDevedor = total - entrada;
      if (saldoDevedor <= 0) {
        _mostrarMensagem("O saldo a financiar deve ser positivo.", 4);
        return;
      }

      final double valorPrincipalParcela = saldoDevedor / numParcelas;
      final List<Parcela> tempParcelas = [];
      DateTime dataAtual = dataPrimeiraParcela!;

      for (int i = 1; i <= numParcelas; i++) {
        final double jurosDaParcela = saldoDevedor * jurosMensal;
        final double valorTotalParcela = valorPrincipalParcela + jurosDaParcela;

        tempParcelas.add(
          Parcela(
            numeroParcela: i,
            valorParcela: valorPrincipalParcela,
            juros: jurosDaParcela,
            totalParcela: valorTotalParcela,
            dataVencimento: dataAtual,
          ),
        );

        saldoDevedor -= valorPrincipalParcela;
        dataAtual = DateTime(dataAtual.year, dataAtual.month + 1, dataAtual.day);
      }

      setState(() {
        parcelas = tempParcelas;
      });

    } catch (e) {
      _mostrarMensagem("Por favor, insira valores numéricos válidos.", 3);
    }
  }

  Widget _criarItem(int idx) {
    Parcela p = parcelas[idx];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Parcela nº ${p.numeroParcela} vence em ${p.dataVencimento!.day.toString().padLeft(2, '0')}/${p.dataVencimento!.month.toString().padLeft(2, '0')}/${p.dataVencimento!.year}",
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Parcela: R\$ ${p.valorParcela!.toStringAsFixed(2)}"),
              Text("Juros: R\$ ${p.juros!.toStringAsFixed(2)}"),
              Text("Total: R\$ ${p.totalParcela!.toStringAsFixed(2)}"),
            ],
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: totalController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Valor Total (R\$)"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: entradaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Entrada (R\$)"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: jurosController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Juros (%)"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: parcelasController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Parcelas"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: dataController,
                                decoration: const InputDecoration(
                                  labelText: "1ª Parcela",
                                ),
                                readOnly: true,
                              ),
                            ),
                            IconButton(
                              onPressed: _selecionarData,
                              icon: const Icon(Icons.calendar_month),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _calcularFinanciamento,
                  icon: const Icon(Icons.check),
                  label: const Text("Calcular"),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _limparCampos,
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text("Limpar"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: parcelas.length,
                  itemBuilder: (ctx, idx) => _criarItem(idx),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}