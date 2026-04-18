import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shoestore.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id TEXT,
        tracking_number TEXT,
        order_date TEXT,
        estimated_delivery TEXT,
        name TEXT,
        address TEXT,
        city TEXT,
        zip TEXT,
        total REAL,
        payment_method TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id TEXT,
        product_name TEXT,
        price REAL,
        size INTEGER,
        quantity INTEGER,
        image TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE orders ADD COLUMN total REAL');
      await db.execute('ALTER TABLE orders ADD COLUMN payment_method TEXT');
    }
  }

  Future<void> insertOrder(
    Map<String, dynamic> order,
    List<Map<String, dynamic>> items,
  ) async {
    final db = await database;

    await db.insert('orders', order);

    for (final item in items) {
      await db.insert('order_items', item);
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return db.query('orders', orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> getOrderItems(String orderId) async {
    final db = await database;
    return db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
  }
}
