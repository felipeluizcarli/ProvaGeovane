import 'dart:convert';
import 'package:http/http.dart' as http;

class CepService {
  static Future<Map<String, dynamic>?> buscarEndereco(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (!data.containsKey('erro')) {
        return data;
      }
    }
    return null;
  }
}
