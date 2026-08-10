import 'package:flutter/material.dart';

/// Petit widget réutilisable pour basculer l'état favori d'une recette.
/// Utilisé sur la carte de la liste ET sur l'écran de détail.
class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.redAccent : null,
      ),
      tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
      onPressed: onPressed,
    );
  }
}
