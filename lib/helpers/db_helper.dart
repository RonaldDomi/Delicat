import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> databaseCategory() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'delicat.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE category(id TEXT PRIMARY KEY, name TEXT, photo TEXT, color_code TEXT, color_code_light TEXT)');
    }, version: 2);
  }

  static Future<Database> databaseRecipe() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'delicat.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE recipe(id TEXT PRIMARY KEY, name TEXT, photo TEXT, description TEXT, category_id INTEGER, FOREIGN KEY(category_id) REFERENCES category(id))');
    }, version: 2);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    var db;
    if (table == "category") {
      db = await DBHelper.databaseCategory();
    } else if (table == "recipe") {
      db = await DBHelper.databaseRecipe();
    }
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    var db;
    if (table == "category") {
      db = await DBHelper.databaseCategory();
    } else {
      db = await DBHelper.databaseRecipe();
    }
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    var db;
    if (table == "category") {
      db = await DBHelper.databaseCategory();
    } else {
      db = await DBHelper.databaseRecipe();
    }
    // Get a reference to the database.

    db.delete(table,
        // Use a `where` clause to delete a specific
        where: "id = ?",
        // Pass the Meals's id as a whereArg to prevent SQL injection.
        whereArgs: [id]);
  }

  static Future<void> edit(
      String table, String id, Map<String, Object> data) async {
    var db;
    if (table == "category") {
      db = await DBHelper.databaseCategory();
    } else {
      db = await DBHelper.databaseRecipe();
    }
    // Get a reference to the database.

    db.update(table, data, where: "id=?", whereArgs: [id]);
  }

  static Future<void> truncateTable(String table) async {
    var db;
    if (table == "category") {
      db = await DBHelper.databaseCategory();
    } else {
      db = await DBHelper.databaseRecipe();
    }
    db.execute("DELETE FROM $table"); //leaves the table, deletes the data
    //equivalent of truncate for sqlite
  }
}
