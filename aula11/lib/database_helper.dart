import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instancia = DatabaseHelper._();
  DatabaseHelper._();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _initFfiIfNeeded();
    _db = await _initDB();
    return _db!;
  }

  void _initFfiIfNeeded() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String caminho = join(dir.path, 'calculadora.db');
    return await openDatabase(caminho, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dados(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT,
        valor TEXT,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE operacoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expressao TEXT,
        resultado TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<int> salvarDado(String tipo, String valor) async {
    final banco = await db;
    return await banco.insert('dados', {
      'tipo': tipo,
      'valor': valor,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<int> inserirOperacao(String expressao, String resultado) async {
    final banco = await db;
    return await banco.insert('operacoes', {
      'expressao': expressao,
      'resultado': resultado,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> listarOperacoes() async {
    final banco = await db;
    return await banco.query('operacoes', orderBy: 'id DESC');
  }
}
