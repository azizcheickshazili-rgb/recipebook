import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../state/app_state.dart';
import '../widgets/favorite_button.dart';
import '../widgets/rating_stars.dart';

/// Écran de détail : reçoit l'identifiant de la recette en paramètre de
/// route ('/recipe/:id') et retrouve la recette complète via [AppState].
class RecipeDetailScreen extends StatelessWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final recipe = appState.recipeById(recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recette introuvable')),
        body: const Center(child: Text('Cette recette n\'existe plus.')),
      );
    }

    final isFavorite = appState.isFavorite(recipe.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            actions: [
              FavoriteButton(
                isFavorite: isFavorite,
                onPressed: () => appState.toggleFavorite(recipe.id),
              ),
              if (recipe.isCustom)
                IconButton(
                  tooltip: 'Supprimer cette recette',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Supprimer la recette ?'),
                        content: Text(
                            'Cette action est définitive pour "${recipe.title}".'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Annuler'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Supprimer'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      appState.deleteRecipe(recipe.id);
                      context.pop();
                    }
                  },
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(recipe.title),
              background: Hero(
                tag: 'recipe-emoji-${recipe.id}',
                child: Container(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  alignment: Alignment.center,
                  child: Text(recipe.emoji, style: const TextStyle(fontSize: 72)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.category_outlined, size: 18),
                        label: Text(recipe.category),
                      ),
                      Chip(
                        avatar: const Icon(Icons.timer_outlined, size: 18),
                        label: Text('${recipe.prepTimeMinutes} min'),
                      ),
                      Chip(
                        avatar: const Icon(Icons.people_outline, size: 18),
                        label: Text('${recipe.servings} pers.'),
                      ),
                      Chip(
                        avatar: CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: Text(
                            recipe.difficulty[0],
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white),
                          ),
                        ),
                        label: Text(recipe.difficulty),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RatingStars(rating: recipe.rating, size: 20),
                      const SizedBox(width: 8),
                      Text(recipe.rating.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text('Ingrédients',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.ingredients.length,
                    itemBuilder: (context, index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(recipe.ingredients[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
