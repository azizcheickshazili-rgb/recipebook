import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import 'favorite_button.dart';
import 'rating_stars.dart';

/// Widget réutilisable affichant une recette sous forme de carte.
/// Utilisé à la fois dans la liste (mobile) et la grille (tablette),
/// sans jamais contenir de données codées en dur : tout vient de [recipe].
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/recipe/${recipe.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'recipe-emoji-${recipe.id}',
              child: Container(
                height: 90,
                color: Theme.of(context).colorScheme.secondaryContainer,
                alignment: Alignment.center,
                child: Text(recipe.emoji, style: const TextStyle(fontSize: 40)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      recipe.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  FavoriteButton(
                    isFavorite: isFavorite,
                    onPressed: onToggleFavorite,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              child: RatingStars(rating: recipe.rating, size: 14),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Wrap(
                spacing: 6,
                children: [
                  Chip(
                    label: Text(recipe.category),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Chip(
                    avatar: const Icon(Icons.timer_outlined, size: 16),
                    label: Text('${recipe.prepTimeMinutes} min'),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
