import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pizza_item.dart';
import '../models/pedido.dart';
import '../database/cart_database.dart';
import 'orders_page.dart';

class CartPage extends StatelessWidget {
  final List<PizzaItem> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  double _calcularTotal() {
    return cartItems.fold(0.0, (total, item) {
      final precoLimpo = item.price.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');
      final valor = double.tryParse(precoLimpo) ?? 0.0;
      return total + valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _calcularTotal();

    return Scaffold(
      appBar: AppBar(title: Text('Carrinho')),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? Center(child: Text('Carrinho vazio.'))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final pizza = cartItems[index];
                      return ListTile(
                        title: Text(pizza.name),
                        subtitle: Text(pizza.price),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: R\$ ${total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton.icon(
              onPressed: cartItems.isEmpty
                  ? null
                  : () => _finalizarPedido(context, cartItems),
              icon: Icon(Icons.check),
              label: Text('Finalizar Pedido'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _finalizarPedido(BuildContext context, List<PizzaItem> items) async {
    final dataHora = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    final pedido = Pedido(
      dataHora: dataHora,
      pizzas: items,
    );

    await CartDatabase.instance.insertPedido(pedido);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pedido realizado com sucesso!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OrdersPage()),
    );
  }
}
