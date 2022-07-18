import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'education.db'),
      onCreate: (db, version) {
        return createTables(db);
      },
      version: 1,
    );
  }

  static FutureOr<void> createTables(sql.Database db) async {
    await db.execute('''
     CREATE TABLE considered_videos (
       id INTEGER PRIMARY KEY AUTOINCREMENT, 
       video_id INTEGER NOT NULL UNIQUE, 
       like_state INTEGER DEFAULT 0 NOT NULL,
       seen INTEGER DEFAULT 0 NOT NULL,
       rating REAL DEFAULT 0.0 NOT NULL,
       title TEXT NOT NULL,
       description TEXT,
       url TEXT,
       cover TEXT NOT NULL,
       banner TEXT NOT NULL,
       wallpaper TEXT,
       visit INTEGER NOT NULL
     )
     ''');

    await db.execute('''
     CREATE TABLE bookmarked_videos (
       id INTEGER PRIMARY KEY AUTOINCREMENT, 
       video_id INTEGER NOT NULL UNIQUE, 
       title TEXT NOT NULL,
       description TEXT,
       url TEXT,
       cover TEXT NOT NULL,
       banner TEXT NOT NULL,
       wallpaper TEXT,
       visit INTEGER NOT NULL
     )
     ''');

    await db.execute('''
     CREATE TABLE downloaded_videos (
       id INTEGER PRIMARY KEY AUTOINCREMENT, 
       video_id INTEGER NOT NULL UNIQUE, 
       title TEXT NOT NULL,
       description TEXT,
       file_path TEXT NOT NULL,
       cover TEXT NOT NULL,
       banner TEXT NOT NULL
     )
     ''');
  }

  /// returns the id of the last inserted row.
  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    return await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<int> update(String table, Map<String, dynamic> row, var id) async {
    final db = await DBHelper.database();
    int updateCount = await db.update(table, row, where: 'id = $id');
    return updateCount;
  }

  /// Returns the number of rows affected.
  static Future<int> delete(String table, int id) async {
    final db = await DBHelper.database();
    int deleteResult = await db.delete(table, where: 'id = $id');
    return deleteResult;
  }

  static Future<List<Map<String, dynamic>>> rawQuery(String sql) async {
    final db = await DBHelper.database();
    return db.rawQuery(sql);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getBookmarkedVideoData(int videoId) async {
    final db = await DBHelper.database();
    return db.query('bookmarked_videos', where: 'video_id = $videoId');
  }

  /// Returns the number of rows affected.
  static Future<int> deleteBookmarkedVideo(int videoId) async {
    final db = await DBHelper.database();
    int result = await db.delete(
      'bookmarked_videos',
      where: 'video_id = $videoId',
    );
    return result;
  }

  static Future<List<Map<String, dynamic>>> getConsideredVideoData(int videoId) async {
    final db = await DBHelper.database();
    return db.query('considered_videos', where: 'video_id = $videoId');
  }

  static Future<int> updateConsideredVideo(Map<String, dynamic> row, var videoId) async {
    final db = await DBHelper.database();
    int updateCount = await db.update('considered_videos', row, where: 'video_id = $videoId');
    return updateCount;
  }

  /// Returns the number of rows affected.
  static Future<int> deleteConsideredVideo(int videoId) async {
    final db = await DBHelper.database();
    int result = await db.delete(
        'considered_videos',
        where: 'video_id = $videoId',
    );
    return result;
  }

  /*
    _query() async {

      // get a reference to the database
      Database db = await DatabaseHelper.instance.database;

      // get single row
      List<String> columnsToSelect = [
        DatabaseHelper.columnId,
        DatabaseHelper.columnName,
        DatabaseHelper.columnAge,
      ];
      String whereString = '${DatabaseHelper.columnId} = ?';
      int rowId = 1;
      List<dynamic> whereArguments = [rowId];
      List<Map> result = await db.query(
          DatabaseHelper.table,
          columns: columnsToSelect,
          where: whereString,
          whereArgs: whereArguments);

      // print the results
      result.forEach((row) => print(row));
      // {_id: 1, name: Bob, age: 23}
    }
  */

}
