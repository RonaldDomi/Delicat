import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'delicat.db'),
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE category(id TEXT PRIMARY KEY, name TEXT, photo TEXT, color_code TEXT, color_code_light TEXT)');
      return db.execute(
          'CREATE TABLE recipe(id TEXT PRIMARY KEY, name TEXT, photo TEXT, is_favorite BIT, description TEXT, category_id INTEGER, FOREIGN KEY(category_id) REFERENCES category(id))');
    }, version: 1);
  }

  // static Future<Database> databaseRecipe() async {
  //   final dbPath = await sql.getDatabasesPath();
  //   return sql.openDatabase(path.join(dbPath, 'delicat.db'),
  //       onCreate: (db, version) {
  //     return db.execute(
  //   }, version: 1);
  // }

  static Future<void> insert(String table, Map<String, Object> data) async {
    var db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    var db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    var db = await DBHelper.database();
    // Get a reference to the database.

    db.delete(table,
        // Use a `where` clause to delete a specific
        where: "id = ?",
        // Pass the Meals's id as a whereArg to prevent SQL injection.
        whereArgs: [id]);
  }

  static Future<void> edit(
      String table, String id, Map<String, Object> data) async {
    var db = await DBHelper.database();
    // Get a reference to the database.

    db.update(table, data, where: "id=?", whereArgs: [id]);
  }

  static Future<void> truncateTable(String table) async {
    var db = await DBHelper.database();
    db.execute("DELETE FROM $table"); //leaves the table, deletes the data
    //equivalent of truncate for sqlite
  }
}
