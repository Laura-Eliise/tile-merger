import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../static/constants.dart';

class DB {
  static const _databaseName = "db.db";
  static const _databaseVersion = 1;
  static Database? _db;

  /* ------ GETTERS ------ */

  Future<DB> get self async {
    if (_db != null) return this;
    _db = await _init();
    return this;
  }

  Future<Database> get db async {
    if (_db != null) return _db as Database;
    _db = await _init();
    return _db as Database;
  }

  /* ------ DB EDITING ------ */

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await this.db;
    return await db.query('my_table');
  }

  Future<Map<String, dynamic>?> query(int id) async {
    Database db = await this.db;
    List<Map<String, dynamic>> result =
        await db.query('my_table', where: "id = ?", whereArgs: [id]);
    if (result.isNotEmpty) return result[0];
    return null;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await this.db;
    int id = row['id'];
    return await db.update('my_table', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await this.db;
    return await db.insert('my_table', row);
  }

  Future<int> delete(int id) async {
    Database db = await this.db;
    return await db.delete('my_table', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database db = await this.db;
    return await db.delete('my_table');
  }

  /* ------ INITIALIZATION ------ */

  Future<Database> _init() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE my_table (
        id INTEGER PRIMARY KEY,
        highScore INTEGER
      )
    ''');
  }

  DB();

  /* ------ TASK SPECIFIC ------ */

  Future<int> get highScore async {
    var resp = await query(gridTileCount);
    return resp != null ? resp["highScore"] : 0;
  }

  Future<int> saveHighScore({required int highScore, required int id}) async {
    var resp = await query(id);
    var row = {"id": id, "highScore": highScore};
    if (resp == null) return insert(row);
    return update(row);
  }
}
