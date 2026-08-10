# 🍽️ RecipeBook

Application Flutter multi-écrans de recettes de cuisine, développée dans le cadre du projet
« App multi-écrans avec navigation » (L1 MIA).

## Fonctionnalités

- **5 écrans** : Accueil (liste), Détail, Ajout (formulaire), Favoris, Réglages
- **Navigation** avec **GoRouter** et routes nommées (`/`, `/recipe/:id`, `/add`, `/favorites`, `/settings`)
- **Recherche en temps réel** + **filtrage par catégorie** + **tri** (nom, temps, note) sur l'écran d'accueil
- **Bascule manuelle liste/grille** en plus de l'adaptation responsive automatique
- **Écran de détail** recevant l'identifiant de la recette en paramètre de route, avec **note en étoiles**
- **Formulaire** avec validation (titre, description, temps de préparation, catégorie, note)
- **Suppression** des recettes ajoutées par l'utilisateur (avec confirmation)
- **Retrait des favoris par glissement** (Dismissible) sur l'écran Favoris
- **Écran Réglages** : thème, vue préférée, statistiques (nombre de recettes, favoris, recettes ajoutées)
- **Thème clair/sombre** personnalisé (palette vert basilic / piment) basculable depuis l'AppBar ou les Réglages
- **Responsive** : liste sur mobile, grille sur tablette (largeur ≥ 600 px), via `LayoutBuilder`
- **Aucune donnée codée en dur dans les widgets** : tout provient de `data/recipe_repository.dart` et de l'état applicatif (`state/app_state.dart`)

## Architecture

```
lib/
 ├─ main.dart                     # Point d'entrée
 ├─ models/
 │   └─ recipe.dart                # Modèle de données Recipe
 ├─ data/
 │   └─ recipe_repository.dart     # Données initiales (séparées des widgets)
 ├─ state/
 │   └─ app_state.dart             # État global : thème, favoris, recettes
 ├─ theme/
 │   └─ app_theme.dart             # Thèmes clair / sombre
 ├─ router/
 │   └─ app_router.dart            # Configuration GoRouter
 ├─ screens/
 │   ├─ home_screen.dart           # Écran 1 : liste + recherche + filtres + tri
 │   ├─ recipe_detail_screen.dart  # Écran 2 : détail (paramètre :id) + suppression
 │   ├─ add_recipe_screen.dart     # Écran 3 : formulaire avec validation + note
 │   ├─ favorites_screen.dart      # Écran 4 : favoris (glisser pour retirer)
 │   ├─ settings_screen.dart       # Écran 5 : réglages et statistiques
 │   └─ main_scaffold.dart         # AppBar + navigation basse partagées
 └─ widgets/
     ├─ recipe_card.dart           # Carte recette réutilisable
     ├─ favorite_button.dart       # Bouton favori réutilisable
     ├─ category_chips_bar.dart    # Barre de filtres réutilisable
     ├─ rating_stars.dart          # Affichage de note en étoiles réutilisable
     └─ empty_state.dart           # État vide réutilisable
```

### Widgets Flutter utilisés (8+)
`ListView`, `GridView`, `Stack`/`Hero`, `Card`, `TextFormField`, `DropdownButtonFormField`,
`ChoiceChip`, `CircleAvatar`, `SliverAppBar`/`CustomScrollView`, `BottomNavigationBar`,
`FloatingActionButton`, `LayoutBuilder`, `Form`, `SafeArea`, `Slider`, `SegmentedButton`,
`PopupMenuButton`, `Dismissible`, `AlertDialog`, `SwitchListTile`.

## Installation et lancement

```bash
flutter pub get
flutter run
```

Pour lancer les tests :

```bash
flutter test
```

## Captures d'écran

*(à ajouter après un premier lancement : accueil, détail, formulaire, favoris, mode sombre)*

## Auteur

Cheick — Licence 1, Mathématiques et Informatique Appliquées (MIA).
