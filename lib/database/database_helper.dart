import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vendor.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'vendor_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vendors(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vendor_id TEXT UNIQUE NOT NULL,
        upi_id TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('big', 'small', 'medium'))
      )
    ''');
  }

  Future<int> insertVendor(Vendor vendor) async {
    final Database db = await database;
    return await db.insert(
      'vendors',
      vendor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Vendor?> getVendorByUpiId(String upiId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vendors',
      where: 'upi_id = ?',
      whereArgs: [upiId],
    );

    if (maps.isEmpty) return null;
    return Vendor.fromMap(maps.first);
  }

  Future<List<Vendor>> getAllVendors() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vendors');
    return List.generate(maps.length, (i) => Vendor.fromMap(maps[i]));
  }

  Future<int> updateVendor(Vendor vendor) async {
    final Database db = await database;
    return await db.update(
      'vendors',
      vendor.toMap(),
      where: 'vendor_id = ?',
      whereArgs: [vendor.vendorId],
    );
  }

  Future<int> deleteVendor(String vendorId) async {
    final Database db = await database;
    return await db.delete(
      'vendors',
      where: 'vendor_id = ?',
      whereArgs: [vendorId],
    );
  }
}