import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

import '../main.dart';
import '../models/expense.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._privateConstructor();

  Database? _database;

  get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final dbFactory = databaseFactoryIo;
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'expenses_prod.db');

    return await dbFactory.openDatabase(dbPath);
  }

  Future<List<Expense>> getEpenses() async {
    final db = await database as Database;
    final records = await store.find(db);
    final expenses =
        records.map((record) => Expense.fromMap(record.value)).toList();
    return expenses;
  }

  Future<void> close() async {
    await _database?.close(); // Закрытие базы данных
  }
}
