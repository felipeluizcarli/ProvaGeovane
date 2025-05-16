import 'dart:convert';
import 'pizza_item.dart';

class Pedido {
  final int? id;
  final String dataHora;
  final List<PizzaItem> pizzas;

  Pedido({
    this.id,
    required this.dataHora,
    required this.pizzas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataHora': dataHora,
      'pizzasJson': jsonEncode(pizzas.map((p) => p.toMap()).toList()),
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    final decoded = jsonDecode(map['pizzasJson'] as String) as List<dynamic>;
    final pizzas = decoded.map((e) => PizzaItem.fromMap(Map<String, dynamic>.from(e))).toList();

    return Pedido(
      id: map['id'] as int?,
      dataHora: map['dataHora'] as String,
      pizzas: pizzas,
    );
  }
}
