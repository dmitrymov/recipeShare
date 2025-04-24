import 'package:sqflite/sqflite.dart'; // Import sqflite for database operations
import 'package:path/path.dart'; // Import path for manipulating file paths
import 'dart:convert'; // Import dart:convert for JSON encoding and decoding

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
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        name TEXT,
        info TEXT,
        url TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE recipes (
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

  // --- CRUD Operations for Users ---

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.ignore, // Avoid duplicate usernames
    );
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('users', limit: 1); // Assuming only one user profile for now
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [1], // Assuming we're updating the single user profile with ID 1
    );
  }

  Future<int> deleteUser() async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [1], // Assuming we're deleting the single user profile with ID 1
    );
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