import 'package:flutter/material.dart';
import '../models/pizza_item.dart';
import '../database/cart_database.dart';
import 'menu_page.dart';

class AddPizzaPage extends StatefulWidget {
  @override
  _AddPizzaPageState createState() => _AddPizzaPageState();
}

class _AddPizzaPageState extends State<AddPizzaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final List<String> imageOptions = [
    'margherita.png',
    'pepperoni.png',
    'calabresa.png',
    'quatro_queijos.png',
    'brigadeiro.png',
    'strogonoff.png',
    'bacon_supreme.png',
  ];

  String? selectedImage;

  void _savePizza() async {
    if (_formKey.currentState!.validate()) {
      final newPizza = PizzaItem(
        name: _nameController.text,
        price: _priceController.text,
        imagePath: 'assets/images/$selectedImage',
      );

      await CartDatabase.instance.insertPizza(newPizza);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pizza adicionada com sucesso!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MenuPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Pizza')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome da Pizza'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Preço (ex: R\$ 35,00)'),
                validator: (value) => value!.isEmpty ? 'Informe o preço' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Imagem da Pizza'),
                value: selectedImage,
                items: imageOptions.map((img) {
                  return DropdownMenuItem<String>(
                    value: img,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/$img',
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image),
                        ),
                        SizedBox(width: 10),
                        Text(img),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedImage = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Escolha uma imagem' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePizza,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
