import 'package:flutter/material.dart';
import '../services/cep_service.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();

  Future<void> buscarEndereco() async {
    final cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final endereco = await CepService.buscarEndereco(cep);

    if (endereco != null) {
      setState(() {
        ruaController.text = endereco['logradouro']?.isNotEmpty == true
            ? endereco['logradouro']
            : 'Rua não informada';
        bairroController.text = endereco['bairro'] ?? '';
        cidadeController.text = endereco['localidade'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CEP não encontrado ou inválido')),
      );
    }
  }

  void preencherCepDeTeste() {
    cepController.text = '01001000'; // CEP válido de SP
    buscarEndereco();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: cepController,
              decoration: InputDecoration(
                labelText: 'CEP',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: buscarEndereco,
                ),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => buscarEndereco(),
            ),
            SizedBox(height: 8),
            TextButton.icon(
              icon: Icon(Icons.bug_report),
              label: Text('Testar com CEP exemplo'),
              onPressed: preencherCepDeTeste,
            ),
            Divider(height: 24),
            TextField(
              controller: ruaController,
              decoration: InputDecoration(labelText: 'Rua'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: bairroController,
              decoration: InputDecoration(labelText: 'Bairro'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: cidadeController,
              decoration: InputDecoration(labelText: 'Cidade'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pedido finalizado!')),
                );
              },
              child: Text('Finalizar Pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
