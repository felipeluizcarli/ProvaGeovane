import 'package:flutter/material.dart';
import 'package:pizza_order_app/models/pizza_item.dart'; // Importando a classe PizzaItem

class CartPage extends StatelessWidget {
  final List<PizzaItem> cartItems; // Recebendo o cartItems

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carrinho')),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index].name), // Exibindo o nome da pizza
            subtitle: Text('R\$ ${cartItems[index].price}'), // Exibindo o preço
          );
        },
      ),
    );
  }
}
