import 'item.dart';

class Agendamento {
  String? descricao;
  String? clienteNome;
  String? clienteEndereco;
  String? clienteTelefone;
  String? veiculoModelo;
  String? veiculoPlaca;
  DateTime? dataHora;
  double? valorTotal;
  bool? recebido;
  bool? cancelado;

  List<Item>? servicos;

  Agendamento(this.descricao, this.clienteNome, this.clienteEndereco, this.clienteTelefone,
              this.veiculoModelo, this.veiculoPlaca, this.dataHora, this.valorTotal,
              this.recebido, this.cancelado, this.servicos);
}