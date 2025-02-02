import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vendor.dart';
import '../models/phone.dart';

class DatabaseHelper extends ChangeNotifier {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'vendor_database.db');
    return await openDatabase(
      path,
      version: 2, // Increment the version number
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Add onUpgrade callback for schema migration
    );
  }

  //
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vendors(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vendor_id TEXT UNIQUE NOT NULL,
        upi_id TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('big', 'small', 'medium')),
        phone_number TEXT NOT NULL,
        location TEXT NOT NULL  -- Add this line for location
      )
    ''');

    await db.execute('''
      CREATE TABLE phones(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone_number TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the new `phone_number` column to the `vendors` table
      await db.execute('ALTER TABLE vendors ADD COLUMN phone_number TEXT NOT NULL DEFAULT ""');

      // Remove the `upi_id` column from the `phones` table
      await db.execute('CREATE TABLE phones_new(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, phone_number TEXT NOT NULL)');
      await db.execute('INSERT INTO phones_new (id, name, phone_number) SELECT id, name, phone_number FROM phones');
      await db.execute('DROP TABLE phones');
      await db.execute('ALTER TABLE phones_new RENAME TO phones');
    }
  }


  //


  Future<int> insertVendor(Vendor vendor) async {
    final Database db = await database;

    // Check if vendor with the same vendor_id already exists
    final List<Map<String, dynamic>> existing = await db.query(
      'vendors',
      where: 'vendor_id = ?',
      whereArgs: [vendor.vendorId],
    );

    if (existing.isNotEmpty) {
      return 0; // Return 0 if vendor already exists to prevent duplication
    }

    final result = await db.insert(
      'vendors',
      vendor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore, // Ensures no duplicate key errors
    );

    notifyListeners();
    return result;
  }

  Future<int> insertPhone(Phone phone) async {
    final Database db = await database;

    // Check if phone with the same phone_number already exists
    final List<Map<String, dynamic>> existing = await db.query(
      'phones',
      where: 'phone_number = ?',
      whereArgs: [phone.phoneNumber],
    );

    if (existing.isNotEmpty) {
      return 0; // Return 0 if phone number already exists
    }

    return await db.insert(
      'phones',
      phone.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
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

  Future<List<Phone>> getPhonesByUpiId(String upiId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'phones',
    );

    return List.generate(maps.length, (i) => Phone.fromMap(maps[i]));
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