import 'package:flutter_test/flutter_test.dart';
import 'package:recipebook/data/recipe_repository.dart';

void main() {
  group('RecipeRepository', () {
    test('initialRecipes retourne une liste non vide', () {
      final recipes = RecipeRepository.initialRecipes();
      expect(recipes, isNotEmpty);
    });

    test('chaque recette a un identifiant unique', () {
      final recipes = RecipeRepository.initialRecipes();
      final ids = recipes.map((r) => r.id).toSet();
      expect(ids.length, recipes.length);
    });

    test('chaque recette appartient à une catégorie connue', () {
      final recipes = RecipeRepository.initialRecipes();
      for (final recipe in recipes) {
        expect(RecipeRepository.categories, contains(recipe.category));
      }
    });

    test('chaque recette a une difficulté connue', () {
      final recipes = RecipeRepository.initialRecipes();
      for (final recipe in recipes) {
        expect(RecipeRepository.difficulties, contains(recipe.difficulty));
      }
    });

    test('aucune recette de démonstration n\'est marquée comme personnalisée',
        () {
      final recipes = RecipeRepository.initialRecipes();
      expect(recipes.every((r) => !r.isCustom), isTrue);
    });

    test('chaque recette a au moins un ingrédient', () {
      final recipes = RecipeRepository.initialRecipes();
      for (final recipe in recipes) {
        expect(recipe.ingredients, isNotEmpty);
      }
    });
  });
}
