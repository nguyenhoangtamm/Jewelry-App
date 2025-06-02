import 'dart:io';
import 'package:flutter/services.dart';
import 'package:jewelryapp/models/base_model.dart';
import 'package:jewelryapp/models/base_model.dart';
import 'package:jewelryapp/models/base_model.dart';
import 'package:jewelryapp/models/base_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "banhang.db");

    if (!await databaseExists(path)) {
      ByteData data = await rootBundle.load("assets/db/banhang.db");
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  // Lấy danh sách bản ghi
  static Future<List<T>> getAll<T extends BaseModel>(
      T Function(Map<String, dynamic>) fromJson,
      String tableName,
      ) async {
    final db = await database;
    final result = await db.query(tableName);
    return result.map((e) => fromJson(e)).toList();
  }

  // Lấy 1 bản ghi theo ID
  static Future<T?> getById<T extends BaseModel>(
      int id,
      T Function(Map<String, dynamic>) fromJson,
      String tableName,
      ) async {
    final db = await database;
    final result =
    await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return fromJson(result.first);
    return null;
  }

  // Thêm
  static Future<int> insert<T extends BaseModel>(T model) async {
    final db = await database;
    return await db.insert(model.tableName, model.toJson());
  }

  // Cập nhật
  static Future<int> update<T extends BaseModel>(T model) async {
    final db = await database;
    return await db.update(
      model.tableName,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  // Xoá
  static Future<int> delete(String tableName, int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
