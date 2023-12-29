

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'RegisterDetailsDB.db';
  static const _databaseVersion = 2;

  static const registerTable = 'RegisterTable';

  static const colId = '_id';

  static const colUserName = '_userName';
  static const colPassword = '_password';
  static const colEmail = '_email';
  static const colMobileNo = '_mobileNo';
  static const colDOB = '_dob';

  late Database _db;

  Future<void> initialization() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
          CREATE TABLE $registerTable(
            $colId INTEGER PRIMARY KEY,
            $colUserName TEXT,
            $colPassword TEXT,   
            $colEmail TEXT,     
            $colMobileNo TEXT,
            $colDOB TEXT       
          )
          ''');
  }

  _onUpgrade(Database database, int oldVersion, int newVersion) async {
    await database.execute('drop table $registerTable');
  }

  Future<int> insertDirectorDetails(
      Map<String, dynamic> row, String tableName) async {
    return await _db.insert(tableName, row);
  }
  // retreive all rows

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    return await _db.query(tableName);
  }

  Future<int> updateDirectorDetails(
      Map<String, dynamic> row, String tableName) async {
    int id = row[colId];
    return await _db.update(
      tableName,
      row,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteDirectorDetails(int id, String tableName) async {
    return await _db.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> checkLoginCredentials(String username, String password) async {
    final List<Map<String, dynamic>> result = await _db.query(
      registerTable,
      where: '$colUserName = ? AND $colPassword = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }
}