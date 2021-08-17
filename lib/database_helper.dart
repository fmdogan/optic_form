import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final List<String> dbTables = ['users', 'forms', 'lessons'];
  static final Map<String, List<String>> dbColumns = {
    'users': [
      'userID',
      'userName',
      'mail',
      'password',
      'userType',
    ],
    'forms': [
      'formID',
      'adminID',
      'qrCode',
      'formName',
      'formWidth',
      'formHeight',
    ],
    'lessons': [
      'lessonID',
      'formID',
      'lessonName',
      'questionAmount',
      'optionAmount',
      'lessonX',
      'lessonY',
      'lessonWidth',
      'lessonHeight',
      'firstOptionX',
      'firstOptionY',
      'optionWidth',
      'optionsDistance',
      'correctAnswers',
    ],
  };

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${dbTables[0]} (
            ${dbColumns[dbTables[0]][0]} INTEGER PRIMARY KEY,
            ${dbColumns[dbTables[0]][1]} TEXT NOT NULL,
            ${dbColumns[dbTables[0]][2]} TEXT NOT NULL,
            ${dbColumns[dbTables[0]][3]} TEXT NOT NULL,
            ${dbColumns[dbTables[0]][4]} TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE ${dbTables[1]} (
            ${dbColumns[dbTables[1]][0]} INTEGER PRIMARY KEY,
            ${dbColumns[dbTables[1]][1]} INTEGER NOT NULL,
            ${dbColumns[dbTables[1]][2]} TEXT NOT NULL,
            ${dbColumns[dbTables[1]][3]} TEXT NOT NULL,
            ${dbColumns[dbTables[1]][4]} TEXT NOT NULL,
            ${dbColumns[dbTables[1]][5]} TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE ${dbTables[2]} (
            ${dbColumns[dbTables[2]][0]} INTEGER PRIMARY KEY,
            ${dbColumns[dbTables[2]][1]} INTEGER NOT NULL,
            ${dbColumns[dbTables[2]][2]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][3]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][4]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][5]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][6]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][7]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][8]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][9]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][10]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][11]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][12]} TEXT NOT NULL,
            ${dbColumns[dbTables[2]][13]} TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of dbColumns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>> fetchRow(
      String table, String column, dynamic value) async {
    Database db = await instance.database;
    var _result = await db.query(
      table,
      where: '$column = ?',
      whereArgs: [value],
    );
    return _result.isNotEmpty ? _result[0] : null;
  }

  Future<List<Map<String, dynamic>>> doesExist(
      String table, String column, dynamic value) async {
    Database db = await instance.database;
    return await db.query(
      table,
      columns: [column],
      where: '$column = ?',
      whereArgs: [value],
    );
  }

  // All of the methods can also be done using raw SQL commands.
  Future<List<Map<String, dynamic>>> rawQuery(String _query) async {
    //String _query = 'SELECT COUNT(*) FROM ${dbTables[0]}';
    Database db = await instance.database;
    return await db.rawQuery(_query);
  }
  
  // Fatch form data
  Future<List<Map<String, dynamic>>> fetchForm(int formID) async {
    String _query = 'SELECT * FROM forms WHERE formID = ?';
    Database db = await instance.database;
    return await db.rawQuery(_query, [formID]);
  }
  
  // Fatch lessons data
  Future<List<Map<String, dynamic>>> fetchLessons(int formID) async {
    String _query = 'SELECT * FROM lessons WHERE formID = ?';
    Database db = await instance.database;
    return await db.rawQuery(_query, [formID]);
  }

  // This finds how many forms the admin has
  Future formCounter(int _foreignID) async {
    Database db = await instance.database;
    int _counter = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM forms WHERE ${dbColumns['forms'][1]} = $_foreignID'));
    //print("sayı: $_counter");
    return _counter;
  }

  // This finds how many forms the admin has
  Future lessonCounter(int _foreignID) async {
    Database db = await instance.database;
    int _counter = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM forms WHERE ${dbColumns['lessons'][1]} = $_foreignID'));
    //print("sayı: $_counter");
    return _counter;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[dbColumns[table][0]];
    return await db.update(table, row,
        where: '${dbColumns[table][0]} = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table,
        where: '${dbColumns[table][0]} = ?', whereArgs: [id]);
  }
}
