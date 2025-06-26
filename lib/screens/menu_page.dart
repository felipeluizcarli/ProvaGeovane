import 'package:flutter/material.dart';
import '../models/pizza_item.dart';
import '../database/cart_database.dart';
import 'cart_page.dart';
import 'add_pizza_page.dart';
import 'edit_pizza_page.dart';
import 'orders_page.dart';
import 'tracking_page.dart';
import 'checkout_page.dart'; // ✅ Importação adicionada

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<PizzaItem> menuItems = [];
  final List<PizzaItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadMenuFromDatabase();
  }

  Future<void> _loadMenuFromDatabase() async {
    final pizzas = await CartDatabase.instance.getAllPizzas();
    setState(() {
      menuItems.clear();
      menuItems.addAll(pizzas);
    });
  }

  void _addToCart(PizzaItem pizza) {
    setState(() {
      cartItems.add(pizza);
    });
  }

  void _confirmDeletePizza(PizzaItem pizza) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Pizza'),
        content: Text('Tem certeza que deseja excluir "${pizza.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await CartDatabase.instance.deletePizza(pizza.id!);
              Navigator.pop(context);
              _loadMenuFromDatabase();
            },
            child: Text('Excluir'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.receipt_long),
            tooltip: 'Pedidos Realizados',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrdersPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Adicionar Pizza',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddPizzaPage()),
              );
            },
          )
        ],
      ),
      body: menuItems.isEmpty
          ? Center(child: Text('Nenhuma pizza cadastrada.'))
          : ListView.builder(
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(cartItems: List.from(cartItems)),
                ),
              ).then((pedidoFinalizado) {
                if (pedidoFinalizado == true) {
                  setState(() {
                    cartItems.clear(); // limpa carrinho após pedido
                  });
                }
              });
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CheckoutPage()), // ✅ Aqui chamamos a tela de checkout com CEP
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TrackingPage()),
              );
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
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Editar'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditPizzaPage(pizza: pizza)),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Excluir', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDeletePizza(pizza);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}