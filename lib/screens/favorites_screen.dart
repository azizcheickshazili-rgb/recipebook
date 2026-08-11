import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/empty_state.dart';
import '../widgets/recipe_card.dart';
import 'main_scaffold.dart';

/// Écran 4 : affiche uniquement les recettes marquées comme favorites.
/// Chaque carte peut être retirée des favoris en la glissant (Dismissible).
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final favorites = appState.favoriteRecipes;

    return MainScaffold(
      currentIndex: 1,
      title: 'Mes favoris',
      body: favorites.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              message:
                  'Aucun favori pour le moment.\nTouche le cœur sur une recette pour l\'ajouter ici.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final recipe = favorites[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: ValueKey('favorite-${recipe.id}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                    onDismissed: (_) => appState.toggleFavorite(recipe.id),
                    child: RecipeCard(
                      recipe: recipe,
                      isFavorite: true,
                      onToggleFavorite: () =>
                          appState.toggleFavorite(recipe.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
