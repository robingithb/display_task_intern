import 'package:sqflite/sqflite.dart' as sql;

class Queryhelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""
    CREATE TABLE display(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT,
    colour TEXT,
    time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("display_database.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  static Future<int> createDetail(String name, String? color) async {
    final db = await Queryhelper.db();
    final dataNote = {"name": name, "colour": color};
    final id = await db.insert('display', dataNote,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllDetails() async {
    final db = await Queryhelper.db();
    return db.query('display', orderBy: 'id');
  }

  static Future<void> deleteAllNotes() async {
    final db = await Queryhelper.db();
    try {
      await db.delete('display');
    } catch (e) {
      print(e.toString());
    }
  }
}
