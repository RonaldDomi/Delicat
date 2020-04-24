import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'delicat.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE user_categories(id TEXT PRIMARY KEY, name TEXT, photo TEXT, colorCode TEXT)');

      db.execute(
          'CREATE TABLE user_meals(id TEXT PRIMARY KEY, name TEXT, photo TEXT, instructions TEXT)');
      db.execute(
          'INSERT INTO user_meals(name , photo , instructions) values (\'test\', \'testphoto\', \'testinst\')');
      return;
    }, onUpgrade: (db, oldVersion, newVersion) async {
      //migrationVersion1(db);
    }, version: 2);
  }

  void migrationVersion1(db) async {
    db.execute('ALTER TABLE user_meals ADD migration2 TEXT DEFAULT \'test2\'');
    List<Map<String, dynamic>> result = await db.query("user_meals");
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    print("The data being inserted in table $table is ${data.toString()}");
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String table, String id) async {
    // Get a reference to the database.
    final db = await DBHelper.database();

    db.delete(table,
        // Use a `where` clause to delete a specific
        where: "id = ?",
        // Pass the Meals's id as a whereArg to prevent SQL injection.
        whereArgs: [id]);
  }

  static Future<void> edit(
      String table, String id, Map<String, Object> data) async {
    // Get a reference to the database.
    final db = await DBHelper.database();

    db.update(table, data, where: "id=?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
