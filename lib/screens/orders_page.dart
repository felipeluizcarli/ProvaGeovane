import 'package:flutter/material.dart';
import '../database/cart_database.dart';
import '../models/pedido.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Pedido>> _pedidosFuture;

  @override
  void initState() {
    super.initState();
    _pedidosFuture = CartDatabase.instance.getAllPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pedidos Realizados')),
      body: FutureBuilder<List<Pedido>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum pedido encontrado.'));
          }

          final pedidos = snapshot.data!;
          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ExpansionTile(
                  title: Text('Pedido #${pedido.id} - ${pedido.dataHora}'),
                  children: pedido.pizzas.map((pizza) {
                    return ListTile(
                      leading: Image.asset(
                        pizza.imagePath,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported),
                      ),
                      title: Text(pizza.name),
                      subtitle: Text(pizza.price),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
