import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tomnenh/helper/db_table.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(DbTable.createUser);
        await db.execute(DbTable.createPermissions);
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<void> insertPermissions(List<String> permissions) async {
    final db = await database;

    // Use a batch for better performance
    final batch = db.batch();
    for (var permission in permissions) {
      batch.insert('permissions', {'description': permission});
    }

    await batch.commit(noResult: true);
  }

//=============================================================================
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> closeDB() async {
    final db = await database;
    db.close();
  }
}
