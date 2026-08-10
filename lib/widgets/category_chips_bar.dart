import 'package:flutter/material.dart';

/// Barre horizontale de filtres par catégorie, réutilisable partout où
/// une liste de recettes doit être filtrée (ici : écran d'accueil).
class CategoryChipsBar extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const CategoryChipsBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ChoiceChip(
              label: const Text('Toutes'),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            );
          }
          final category = categories[index - 1];
          return ChoiceChip(
            label: Text(category),
            selected: selected == category,
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}
