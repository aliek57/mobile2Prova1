import 'item.dart';

class Agendamento {
  String? clienteNome;
  String? clienteTelefone;
  String? clienteEndereco;
  String? veiculoModelo;
  String? veiculoPlaca;
  DateTime? dataHora;
  double? valorTotal;
  bool? recebido;
  bool? cancelado;

  List<Item>? servicos;

  Agendamento(this.clienteNome, this.clienteTelefone, this.clienteEndereco,
              this.veiculoModelo, this.veiculoPlaca, this.dataHora, this.valorTotal,
              this.recebido, this.cancelado, this.servicos);
}