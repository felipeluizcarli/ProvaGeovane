import 'package:flutter/material.dart';
import 'package:pizza_order_app/screens/cart_page.dart';
import 'package:pizza_order_app/screens/home_page.dart';
import 'package:pizza_order_app/screens/menu_page.dart';
import 'package:pizza_order_app/screens/tracking_page.dart';
import 'package:pizza_order_app/models/pizza_item.dart'; // Certifique-se de importar a classe correta

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<PizzaItem> cartItems; // Corrigido o tipo da lista
  final Function(int)? onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.cartItems,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: 'Menu'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrinho'),
        BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: 'Rastreio'),
      ],
      onTap: onTap ??
          (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
                break;
              case 1:
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => MenuPage()));
                break;
              case 2:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CartPage(cartItems: cartItems))); 
                break;
              case 3:
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => TrackingPage()));
                break;
            }
          },
    );
  }
}
