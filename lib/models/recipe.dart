class Recipe {
  int? id;
  String name;
  String ingredients;
  String instructions;
  int categoryId;
  String notes;
  List<String> images;
  DateTime createdAt;

  Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.categoryId,
    required this.notes,
    required this.images,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'ingredients': ingredients,
        'instructions': instructions,
        'category_id': categoryId,
        'notes': notes,
        'images': images,
        'created_at': createdAt.toIso8601String(),
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        name: json['name'],
        ingredients: json['ingredients'],
        instructions: json['instructions'],
        categoryId: json['category_id'],
        notes: json['notes'],
        images: List<String>.from(json['images']),
        createdAt: DateTime.parse(json['created_at']),
      );
}