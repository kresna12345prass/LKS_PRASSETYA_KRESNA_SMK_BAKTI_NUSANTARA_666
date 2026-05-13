import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('warung_go.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        alamat TEXT,
        username TEXT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        total REAL NOT NULL,
        payment_method TEXT NOT NULL,
        created_at TEXT NOT NULL,
        items TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    await _insertDefaultProducts(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN nama TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN alamat TEXT');
    }
    if (oldVersion < 3) {
      // Add user_id column to transactions table
      await db.execute('ALTER TABLE transactions ADD COLUMN user_id INTEGER DEFAULT 1');
    }
    if (oldVersion < 4) {
      // Check if columns exist before adding
      final columns = await db.rawQuery('PRAGMA table_info(users)');
      final columnNames = columns.map((col) => col['name'] as String).toList();
      
      if (!columnNames.contains('email')) {
        await db.execute('ALTER TABLE users ADD COLUMN email TEXT');
      }
      if (!columnNames.contains('username')) {
        await db.execute('ALTER TABLE users ADD COLUMN username TEXT');
      }
    }
  }

  Future _insertDefaultProducts(Database db) async {
    final products = [
      {'name': 'Nasi Goreng', 'price': 15000.0, 'image': 'assets/images/nasi_goreng.jpg', 'category': 'Makanan'},
      {'name': 'Ayam Goreng', 'price': 18000.0, 'image': 'assets/images/ayam_goreng.jpg', 'category': 'Makanan'},
      {'name': 'Mie Goreng', 'price': 12000.0, 'image': 'assets/images/mie_goreng.jpg', 'category': 'Makanan'},
      {'name': 'Sate Ayam', 'price': 20000.0, 'image': 'assets/images/sate_ayam.jpg', 'category': 'Makanan'},
      {'name': 'Es Teh', 'price': 5000.0, 'image': 'assets/images/es_teh.jpg', 'category': 'Minuman'},
      {'name': 'Jus Jeruk', 'price': 8000.0, 'image': 'assets/images/jus_jeruk.jpg', 'category': 'Minuman'},
      {'name': 'Kopi Hitam', 'price': 7000.0, 'image': 'assets/images/kopi_hitam.jpg', 'category': 'Minuman'},
      {'name': 'Keripik', 'price': 10000.0, 'image': 'assets/images/keripik.jpg', 'category': 'Snack'},
      {'name': 'Coklat', 'price': 12000.0, 'image': 'assets/images/coklat.jpg', 'category': 'Snack'},
      {'name': 'Biskuit', 'price': 8000.0, 'image': 'assets/images/biskuit.jpg', 'category': 'Snack'},
    ];

    for (var product in products) {
      await db.insert('products', product);
    }
  }

  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }

  Future<int> createTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction);
  }

  Future<List<Map<String, dynamic>>> getTransactions({int? userId}) async {
    final db = await database;
    if (userId != null) {
      return await db.query(
        'transactions',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
    }
    return await db.query('transactions', orderBy: 'created_at DESC');
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
