import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pizza_item.dart';
import '../models/pedido.dart';

class CartDatabase {
  static final CartDatabase instance = CartDatabase._init();
  static Database? _database;

  CartDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pizza.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 2, // atualizado para recriar banco com nova tabela
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pizzas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price TEXT NOT NULL,
        imagePath TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pedidos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dataHora TEXT NOT NULL,
        pizzasJson TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertPizza(PizzaItem pizza) async {
    final db = await instance.database;
    return await db.insert('pizzas', pizza.toMap());
  }

  Future<List<PizzaItem>> getAllPizzas() async {
    final db = await instance.database;
    final result = await db.query('pizzas');
    return result.map((json) => PizzaItem.fromMap(json)).toList();
  }

  Future<int> deletePizza(int id) async {
    final db = await instance.database;
    return await db.delete('pizzas', where: 'id = ?', whereArgs: [id]);
  }

  // --- NOVO: PEDIDOS ---

  Future<int> insertPedido(Pedido pedido) async {
    final db = await instance.database;
    return await db.insert('pedidos', {
      'dataHora': pedido.dataHora,
      'pizzasJson': jsonEncode(pedido.pizzas.map((p) => p.toMap()).toList()),
    });
  }

  Future<List<Pedido>> getAllPedidos() async {
    final db = await instance.database;
    final result = await db.query('pedidos', orderBy: 'id DESC');

    return result.map((map) {
      final List<dynamic> decodedList = jsonDecode(map['pizzasJson'] as String);
      final List<PizzaItem> pizzas = decodedList.map((e) => PizzaItem.fromMap(e)).toList();

      return Pedido(
        id: map['id'] as int,
        dataHora: map['dataHora'] as String,
        pizzas: pizzas,
      );
    }).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
