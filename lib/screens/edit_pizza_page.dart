import 'package:flutter/material.dart';
import '../models/pizza_item.dart';
import '../database/cart_database.dart';
import 'menu_page.dart';

class EditPizzaPage extends StatefulWidget {
  final PizzaItem pizza;

  EditPizzaPage({required this.pizza});

  @override
  _EditPizzaPageState createState() => _EditPizzaPageState();
}

class _EditPizzaPageState extends State<EditPizzaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pizza.name);
    _priceController = TextEditingController(text: widget.pizza.price);

    final fullPath = widget.pizza.imagePath;
    final filename = fullPath.split('/').last;
    selectedImage = filename;
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedPizza = PizzaItem(
        id: widget.pizza.id,
        name: _nameController.text,
        price: _priceController.text,
        imagePath: 'assets/images/$selectedImage',
      );

      final db = await CartDatabase.instance.database;
      await db.update(
        'pizzas',
        updatedPizza.toMap(),
        where: 'id = ?',
        whereArgs: [updatedPizza.id],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pizza atualizada com sucesso!')),
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
      appBar: AppBar(title: Text('Editar Pizza')),
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
                decoration: InputDecoration(labelText: 'Preço'),
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
                onPressed: _saveChanges,
                child: Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
