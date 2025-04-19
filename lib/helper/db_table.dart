class DbTable {
  static const userTable = 'users';
  static const String createUser = '''
    CREATE TABLE $userTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT,
      photo TEXT,
      token TEXT,
      role TEXT
    )
  ''';

  static const permissionsTable = 'permissions';
  static const String createPermissions = '''
    CREATE TABLE $permissionsTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT
    )
  ''';

  // You can optionally define drop statements
  static const String dropUserTable = '''
    DROP TABLE IF EXISTS $userTable
  ''';

  static const String dropPermissionsTable = '''
    DROP TABLE IF EXISTS $permissionsTable
  ''';
}
