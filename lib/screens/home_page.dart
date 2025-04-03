import 'package:flutter/material.dart';
import 'menu_page.dart';
import '../widgets/custom_nav_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Variável para controlar o índice selecionado

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Atualiza o índice selecionado
    });
    // Navegação conforme o item clicado
    switch (index) {
      case 0:
        // Início
        break;
      case 1:
        // Menu
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuPage()),
        );
        break;
      case 2:
        // Carrinho
        break;
      case 3:
        // Rastreio
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pizza Delivery')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Imagem destaque
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('pizza_banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            // 🔹 Texto chamativo
            Text(
              'Peça sua pizza favorita!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // 🔹 Botão estilizado para pedir pizza
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                );
              },
              icon: Icon(Icons.local_pizza),
              label: Text('Ver Menu'),
            ),
            SizedBox(height: 30),
            // 🔹 Seção de promoções
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    '🔥 Promoções do Dia!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Ganhe um refrigerante grátis na compra de qualquer pizza grande! 🥤',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      // 🔹 Barra de navegação inferior
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped, // Função que lida com a navegação
      ),
    );
  }
}
