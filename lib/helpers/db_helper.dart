import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'delicat.db'),
        onCreate: (db, version) {
      db.execute('CREATE TABLE user_categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, photo TEXT, colorCode TEXT)');
      db.execute('INSERT INTO user_categories(name , photo , colorCode) values (\'Italian\', \'-\', \'0xff00f3ff\')');
      db.execute('INSERT INTO user_categories(name , photo , colorCode) values (\'Quick & Easy\', \'-\', \'0x888aefc3\')');
      db.execute('INSERT INTO user_categories(name , photo , colorCode) values (\'Hamburgers\', \'-\', \'0x88990000\')');
      db.execute('INSERT INTO user_categories(name , photo , colorCode) values (\'German\', \'-\', \'0x88ff0000\')');


      db.execute('CREATE TABLE user_recipes(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, photo TEXT, instructions TEXT, categoryId Text)');
      db.execute('INSERT INTO user_recipes(name , photo , instructions, categoryId) values (\'test\', \'testphoto\', \'testinst\', \'1\')');
      return;
    }, onUpgrade: (db, oldVersion, newVersion) async {
      //migrationVersion1(db);
    }, version: 2);
  }

  void migrationVersion1(db) async {
    db.execute('ALTER TABLE user_recipes ADD migration2 TEXT DEFAULT \'test2\'');
    List<Map<String, dynamic>> result = await db.query("user_recipes");
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

  static Future<void> truncateTable(String table) async {
    final db = await DBHelper.database();
    db.execute("DELETE FROM $table"); //leaves the table, deletes the data
    //equivalent of truncate for sqlite
  }
}   
