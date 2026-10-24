import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'recipe.dart';

class RecipeDb {
  RecipeDb._();
  static final RecipeDb instance = RecipeDb._();
  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'tarifler.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) => db.execute('''
        CREATE TABLE recipes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          ingredients TEXT NOT NULL,
          steps TEXT NOT NULL
        )
      '''),
    );
    return _db!;
  }

  Future<List<Recipe>> all({String query = ''}) async {
    final db = await _database;
    final rows = query.trim().isEmpty
        ? await db.query('recipes', orderBy: 'id DESC')
        : await db.query(
            'recipes',
            where: 'title LIKE ? OR ingredients LIKE ?',
            whereArgs: ['%$query%', '%$query%'],
            orderBy: 'id DESC',
          );
    return rows.map(Recipe.fromMap).toList();
  }

  Future<void> save(Recipe r) async {
    final db = await _database;
    if (r.id == null) {
      await db.insert('recipes', r.toMap()..remove('id'));
    } else {
      await db.update('recipes', r.toMap(), where: 'id = ?', whereArgs: [r.id]);
    }
  }

  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }
}
