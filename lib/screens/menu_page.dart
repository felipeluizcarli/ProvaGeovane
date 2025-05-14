import 'package:flutter/material.dart';
import '../models/pizza_item.dart'; // Certifique-se de importar a classe PizzaItem corretamente
import 'cart_page.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<PizzaItem> menuItems = [
    PizzaItem(name: 'Margherita', price: 'R\$ 30,00', imagePath: 'assets/images/margherita.png'),
    PizzaItem(name: 'Pepperoni', price: 'R\$ 35,00', imagePath: 'assets/images/pepperoni.png'),
    PizzaItem(name: 'Quatro Queijos', price: 'R\$ 40,00', imagePath: 'assets/images/quatro_queijos.png'),
    PizzaItem(name: 'Brigadeiro', price: 'R\$ 39,00', imagePath: 'assets/images/brigadeiro.png'),
    PizzaItem(name: 'Strogonoff', price: 'R\$ 44,00', imagePath: 'assets/images/strogonoff.png'),
    PizzaItem(name: 'Calabresa', price: 'R\$ 32,00', imagePath: 'assets/images/calabresa.png'),
    PizzaItem(name: 'Bacon Supreme', price: 'R\$ 42,00', imagePath: 'assets/images/bacon_supreme.png'),
  ];

  final List<PizzaItem> cartItems = [];

  void _addToCart(PizzaItem pizza) {
    setState(() {
      cartItems.add(pizza);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return pizzaItem(menuItems[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrinho'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Checkout'),
          BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: 'Rastreio'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MenuPage()));
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(cartItems: cartItems),
                ),
              );
              break;
            case 2:
              // Lógica de Checkout
              break;
            case 3:
              // Lógica de Rastreio
              break;
          }
        },
      ),
    );
  }

  Widget pizzaItem(PizzaItem pizza) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Image.asset(
          pizza.imagePath,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
        ),
        title: Text(pizza.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(pizza.price),
        trailing: ElevatedButton(
          onPressed: () {
            _addToCart(pizza);
          },
          child: Text('Adicionar'),
        ),
      ),
    );
  }
}
