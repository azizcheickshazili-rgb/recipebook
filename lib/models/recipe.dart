/// Modèle représentant une recette.
/// Contient uniquement des données, aucune logique d'affichage :
/// la séparation UI / données est assurée en gardant les widgets
/// totalement indépendants de ce fichier.
class Recipe {
  final String id;
  final String title;
  final String description;
  final String category;
  final String emoji;
  final String difficulty; // Facile / Moyen / Difficile
  final int prepTimeMinutes;
  final int servings;
  final List<String> ingredients;
  final double rating;

  /// Vrai uniquement pour les recettes ajoutées par l'utilisateur via le
  /// formulaire : seules celles-ci peuvent être supprimées.
  final bool isCustom;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.emoji,
    required this.difficulty,
    required this.prepTimeMinutes,
    required this.ingredients,
    this.servings = 4,
    this.rating = 4.0,
    this.isCustom = false,
  });

  Recipe copyWith({
    String? title,
    String? description,
    String? category,
    String? emoji,
    String? difficulty,
    int? prepTimeMinutes,
    int? servings,
    List<String>? ingredients,
    double? rating,
    bool? isCustom,
  }) {
    return Recipe(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      difficulty: difficulty ?? this.difficulty,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      servings: servings ?? this.servings,
      ingredients: ingredients ?? this.ingredients,
      rating: rating ?? this.rating,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
