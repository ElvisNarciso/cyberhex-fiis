import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cyberhex.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE assets (
  ticker TEXT PRIMARY KEY,
  quantity INTEGER NOT NULL,
  averagePrice REAL NOT NULL,
  currentPrice REAL,
  pvp REAL,
  lastDividend REAL,
  hasNewDocument INTEGER NOT NULL DEFAULT 0
)
''');

    await db.execute('''
CREATE TABLE transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ticker TEXT NOT NULL,
  type TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  price REAL NOT NULL,
  date TEXT NOT NULL
)
''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
