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

  Recipe copyWith({
    int? id,
    String? name,
    String? ingredients,
    String? instructions,
    int? categoryId,
    String? notes,
    List<String>? images,
    DateTime? createdAt,
  }) => Recipe(
    id: id ?? this.id,
    name: name ?? this.name,
    ingredients: ingredients ?? this.ingredients,
    instructions: instructions ?? this.instructions,
    categoryId: categoryId ?? this.categoryId,
    notes: notes ?? this.notes,
    images: images ?? this.images,
    createdAt: createdAt ?? this.createdAt,
  );
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'ingredients': ingredients,
        'instructions': instructions,
        'category_id': categoryId,
        'notes': notes,
        'images': images.join('\n'),
        'created_at': createdAt.toIso8601String(),
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        name: json['name'],
        ingredients: json['ingredients'],
        instructions: json['instructions'],
        categoryId: json['category_id'],
        notes: json['notes'],
        images: json['images'].split('\n'),
        createdAt: DateTime.parse(json['created_at']),
      );
}