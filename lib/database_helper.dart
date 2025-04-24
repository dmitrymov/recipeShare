import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'dart:convert';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'recipe_app.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initDatabase() async {
    final path = await fullPath;
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

 Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL
      )
    ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS recipes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          ingredients TEXT NOT NULL,
          instructions TEXT NOT NULL,
          category_id INTEGER,
          notes TEXT,
          created_at TEXT,
          FOREIGN KEY (category_id) REFERENCES categories(id)
      )
    ''');
  }

  // --- CRUD Operations for Categories ---

  Future<int> insertCategory(String name) async {
    final db = await database;
    return await db.insert(
      'categories',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace, // Avoid duplicate entries
    );
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  // --- CRUD Operations for Recipes ---

  Future<int> insertRecipe(Map<String, dynamic> recipe) async {
    final db = await database;
    return await db.insert(
      'recipes',
      {
        'name': recipe['name'],
        'ingredients': jsonEncode(recipe['ingredients']),
        'instructions': jsonEncode(recipe['instructions']),
        'category_id': recipe['categoryId'],
        'notes': recipe['notes'],
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllRecipes() async {
    final db = await database;
    return await db.query('recipes');
  }

  Future<Map<String, dynamic>?> getRecipeById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateRecipe(Map<String, dynamic> recipe) async {
    final db = await database;
    return await db.update(
      'recipes',
      {
        'name': recipe['name'],
        'ingredients': jsonEncode(recipe['ingredients']),
        'instructions': jsonEncode(recipe['instructions']),
        'category_id': recipe['categoryId'],
        'notes': recipe['notes'],
      },
      where: 'id = ?',
      whereArgs: [recipe['id']],
    );
  }

  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}