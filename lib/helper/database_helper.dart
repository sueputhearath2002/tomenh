import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tomnenh/datas/models/user_model.dart';
import 'package:tomnenh/helper/db_table.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  static Database? _database;
  UserModel? currentUser;

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

  Future<UserModel?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    if (maps.isNotEmpty) {
      final map = maps.first;

      final roleValue = map['role'];
      final user = UserModel(
        token: map['token'] ?? "",
        role: roleValue is List
            ? List<String>.from(roleValue)
            : roleValue is String && roleValue.isNotEmpty
                ? [roleValue]
                : [],
        student: Student(
            name: map["name"],
            email: map["email"],
            photo: map["photo"],
            id: map["id"].toString()),
        permissions: map['permissions'] is List
            ? List<String>.from(map['permissions'])
            : [],
      );
      currentUser = user;
      return user;
    }
    return null;
  }

//====================Under maintenance=================

  Future<int> deleteUser(String token) async {
    final db = await database;
    return await db.delete('users', where: 'token = ?', whereArgs: [token]);
  }

  Future<void> closeDB() async {
    final db = await database;
    db.close();
  }
}
