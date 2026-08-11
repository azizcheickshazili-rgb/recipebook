import 'package:flutter/material.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';

/// Modes d'affichage possibles pour les listes de recettes.
enum ViewMode { list, grid }

/// Critères de tri disponibles sur l'écran d'accueil.
enum SortOption { nameAsc, timeAsc, timeDesc, ratingDesc }

extension SortOptionLabel on SortOption {
  String get label {
    switch (this) {
      case SortOption.nameAsc:
        return 'Nom (A-Z)';
      case SortOption.timeAsc:
        return 'Temps (croissant)';
      case SortOption.timeDesc:
        return 'Temps (décroissant)';
      case SortOption.ratingDesc:
        return 'Meilleure note';
    }
  }
}

/// État global partagé de l'application : thème clair/sombre, préférences
/// d'affichage, liste des recettes et favoris. Diffusé via `provider`
/// (`ChangeNotifierProvider` dans `main.dart`), donc accessible partout via
/// `context.watch<AppState>()` ou `context.read<AppState>()`.
class AppState extends ChangeNotifier {
  AppState() : _recipes = RecipeRepository.initialRecipes();

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  ViewMode _preferredViewMode = ViewMode.list;
  ViewMode get preferredViewMode => _preferredViewMode;

  SortOption _sortOption = SortOption.nameAsc;
  SortOption get sortOption => _sortOption;

  final List<Recipe> _recipes;
  List<Recipe> get recipes {
    final sorted = List<Recipe>.from(_recipes);
    switch (_sortOption) {
      case SortOption.nameAsc:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.timeAsc:
        sorted.sort((a, b) => a.prepTimeMinutes.compareTo(b.prepTimeMinutes));
        break;
      case SortOption.timeDesc:
        sorted.sort((a, b) => b.prepTimeMinutes.compareTo(a.prepTimeMinutes));
        break;
      case SortOption.ratingDesc:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return List.unmodifiable(sorted);
  }

  final Set<String> _favoriteIds = {};
  bool isFavorite(String id) => _favoriteIds.contains(id);
  List<Recipe> get favoriteRecipes =>
      recipes.where((r) => _favoriteIds.contains(r.id)).toList();

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setPreferredViewMode(ViewMode mode) {
    _preferredViewMode = mode;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  void addRecipe(Recipe recipe) {
    _recipes.insert(0, recipe.copyWith(isCustom: true));
    notifyListeners();
  }

  /// Supprime une recette. Réservé aux recettes ajoutées par l'utilisateur
  /// (isCustom == true) pour préserver le jeu de données de démonstration.
  void deleteRecipe(String id) {
    _recipes.removeWhere((r) => r.id == id && r.isCustom);
    _favoriteIds.remove(id);
    notifyListeners();
  }

  Recipe? recipeById(String id) {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
