class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<PizzaItem> cartItems;
  final Function(int)? onTap; // Adicionando o parâmetro onTap

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.cartItems,
    this.onTap, // Agora ele pode ser passado externamente
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
      onTap: onTap ?? (index) { // Se onTap não for passado, usa a navegação padrão
        switch (index) {
          case 0:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
            break;
          case 1:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MenuPage()));
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => CartPage(cartItems: cartItems)),
            );
            break;
          case 3:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TrackingPage()));
            break;
        }
      },
    );
  }
}
