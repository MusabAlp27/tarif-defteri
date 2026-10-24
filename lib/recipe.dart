class Recipe {
  final int? id;
  final String title;
  final String ingredients; // her satır bir malzeme
  final String steps; // her satır bir adım

  const Recipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.steps,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'ingredients': ingredients,
        'steps': steps,
      };

  factory Recipe.fromMap(Map<String, Object?> m) => Recipe(
        id: m['id'] as int?,
        title: m['title'] as String,
        ingredients: m['ingredients'] as String,
        steps: m['steps'] as String,
      );
}
