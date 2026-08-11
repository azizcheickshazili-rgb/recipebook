import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipebook/models/recipe.dart';
import 'package:recipebook/state/app_state.dart';

void main() {
  group('AppState - favoris', () {
    test('une recette n\'est pas favorite par défaut', () {
      final state = AppState();
      final firstId = state.recipes.first.id;
      expect(state.isFavorite(firstId), isFalse);
    });

    test('toggleFavorite ajoute puis retire une recette des favoris', () {
      final state = AppState();
      final id = state.recipes.first.id;

      state.toggleFavorite(id);
      expect(state.isFavorite(id), isTrue);
      expect(state.favoriteRecipes.map((r) => r.id), contains(id));

      state.toggleFavorite(id);
      expect(state.isFavorite(id), isFalse);
      expect(state.favoriteRecipes.map((r) => r.id), isNot(contains(id)));
    });

    test('toggleFavorite notifie les écouteurs', () {
      final state = AppState();
      var notifications = 0;
      state.addListener(() => notifications++);

      state.toggleFavorite(state.recipes.first.id);

      expect(notifications, 1);
    });
  });

  group('AppState - ajout et suppression de recettes', () {
    test('addRecipe ajoute une recette marquée comme personnalisée', () {
      final state = AppState();
      final initialCount = state.recipes.length;

      const newRecipe = Recipe(
        id: 'custom-test-1',
        title: 'Test Recette',
        description: 'Une recette de test',
        category: 'Dessert',
        emoji: '🍮',
        difficulty: 'Facile',
        prepTimeMinutes: 10,
        ingredients: ['Ingrédient A'],
      );

      state.addRecipe(newRecipe);

      expect(state.recipes.length, initialCount + 1);
      final added = state.recipeById('custom-test-1');
      expect(added, isNotNull);
      expect(added!.isCustom, isTrue);
    });

    test('deleteRecipe supprime uniquement les recettes personnalisées', () {
      final state = AppState();
      final originalRecipeId = state.recipes.first.id;
      final originalCount = state.recipes.length;

      // Une recette d'origine (isCustom == false) ne doit pas pouvoir être
      // supprimée : c'est le jeu de données de démonstration de l'app.
      state.deleteRecipe(originalRecipeId);
      expect(state.recipes.length, originalCount);
      expect(state.recipeById(originalRecipeId), isNotNull);

      const custom = Recipe(
        id: 'custom-test-2',
        title: 'À supprimer',
        description: 'Recette temporaire',
        category: 'Entrée',
        emoji: '🥣',
        difficulty: 'Facile',
        prepTimeMinutes: 5,
        ingredients: ['Ingrédient B'],
      );
      state.addRecipe(custom);
      expect(state.recipeById('custom-test-2'), isNotNull);

      state.deleteRecipe('custom-test-2');
      expect(state.recipeById('custom-test-2'), isNull);
    });

    test('supprimer une recette la retire aussi des favoris', () {
      final state = AppState();
      const custom = Recipe(
        id: 'custom-test-3',
        title: 'Favorite puis supprimée',
        description: 'Recette temporaire',
        category: 'Boisson',
        emoji: '🍹',
        difficulty: 'Facile',
        prepTimeMinutes: 5,
        ingredients: ['Ingrédient C'],
      );
      state.addRecipe(custom);
      state.toggleFavorite('custom-test-3');
      expect(state.isFavorite('custom-test-3'), isTrue);

      state.deleteRecipe('custom-test-3');

      expect(state.isFavorite('custom-test-3'), isFalse);
    });
  });

  group('AppState - tri', () {
    test('le tri par nom trie les recettes par ordre alphabétique', () {
      final state = AppState();
      state.setSortOption(SortOption.nameAsc);

      final titles = state.recipes.map((r) => r.title).toList();
      final sortedTitles = List<String>.from(titles)..sort();

      expect(titles, sortedTitles);
    });

    test('le tri par temps croissant respecte l\'ordre des durées', () {
      final state = AppState();
      state.setSortOption(SortOption.timeAsc);

      final times = state.recipes.map((r) => r.prepTimeMinutes).toList();
      for (var i = 0; i < times.length - 1; i++) {
        expect(times[i] <= times[i + 1], isTrue);
      }
    });

    test('le tri par temps décroissant respecte l\'ordre inverse des durées',
        () {
      final state = AppState();
      state.setSortOption(SortOption.timeDesc);

      final times = state.recipes.map((r) => r.prepTimeMinutes).toList();
      for (var i = 0; i < times.length - 1; i++) {
        expect(times[i] >= times[i + 1], isTrue);
      }
    });
  });

  group('AppState - thème et préférences', () {
    test('toggleTheme bascule entre clair et sombre', () {
      final state = AppState();
      expect(state.themeMode, ThemeMode.light);

      state.toggleTheme();
      expect(state.themeMode, ThemeMode.dark);

      state.toggleTheme();
      expect(state.themeMode, ThemeMode.light);
    });

    test('setPreferredViewMode met à jour la vue préférée', () {
      final state = AppState();
      expect(state.preferredViewMode, ViewMode.list);

      state.setPreferredViewMode(ViewMode.grid);
      expect(state.preferredViewMode, ViewMode.grid);
    });
  });

  group('AppState - recherche par id', () {
    test('recipeById retourne null pour un identifiant inconnu', () {
      final state = AppState();
      expect(state.recipeById('id-inexistant'), isNull);
    });

    test('recipeById retourne la bonne recette pour un identifiant valide',
        () {
      final state = AppState();
      final expected = state.recipes.first;
      expect(state.recipeById(expected.id)?.title, expected.title);
    });
  });
}
