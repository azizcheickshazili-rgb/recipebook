# 🍽️ RecipeBook

Application Flutter multi-écrans de recettes de cuisine, développée dans le cadre du projet
« App multi-écrans avec navigation » (L1 MIA).

## Fonctionnalités

- **5 écrans** : Accueil (liste), Détail, Ajout (formulaire), Favoris, Réglages
- **Navigation** avec **GoRouter** et routes nommées (`/`, `/recipe/:id`, `/add`, `/favorites`, `/settings`)
- **Recherche en temps réel** + **filtrage par catégorie** + **tri** (nom, temps, note) sur l'écran d'accueil
- **Bascule manuelle liste/grille**, en plus d'une **mise en page réellement adaptative** :
  navigation basse sur mobile, `NavigationRail` latéral sur tablette (≥ 600 px)
- **Écran de détail** recevant l'identifiant de la recette en paramètre de route, avec **note en étoiles**
- **Formulaire** à 5 champs validés (titre, description, temps, nombre de personnes, catégorie)
  avec **gestion d'erreurs explicite** (try/catch, messages utilisateur en cas de saisie invalide)
- **Suppression** des recettes ajoutées par l'utilisateur (avec confirmation)
- **Retrait des favoris par glissement** (`Dismissible`) sur l'écran Favoris
- **Écran Réglages** : thème, vue préférée, statistiques (nombre de recettes, favoris, recettes ajoutées)
- **Thème clair/sombre** personnalisé (palette vert basilic / piment) basculable depuis l'AppBar ou les Réglages
- **Gestion d'état avec `provider`** (`ChangeNotifierProvider` / `context.watch` / `context.read`)
- **Aucune donnée codée en dur dans les widgets** : tout provient de `data/recipe_repository.dart`
  et de l'état applicatif (`state/app_state.dart`)

## Architecture

```
lib/
 ├─ main.dart                     # Point d'entrée, ChangeNotifierProvider<AppState>
 ├─ models/
 │   └─ recipe.dart                # Modèle de données Recipe
 ├─ data/
 │   └─ recipe_repository.dart     # Données initiales (séparées des widgets)
 ├─ state/
 │   └─ app_state.dart             # État global : thème, favoris, recettes, tri
 ├─ theme/
 │   └─ app_theme.dart             # Thèmes clair / sombre (palette basilic/piment)
 ├─ router/
 │   └─ app_router.dart            # Configuration GoRouter
 ├─ screens/
 │   ├─ home_screen.dart           # Écran 1 : liste + recherche + filtres + tri
 │   ├─ recipe_detail_screen.dart  # Écran 2 : détail (paramètre :id) + suppression
 │   ├─ add_recipe_screen.dart     # Écran 3 : formulaire avec validation + gestion d'erreurs
 │   ├─ favorites_screen.dart      # Écran 4 : favoris (glisser pour retirer)
 │   ├─ settings_screen.dart       # Écran 5 : réglages et statistiques
 │   └─ main_scaffold.dart         # AppBar + navigation adaptative (bas / rail latéral)
 └─ widgets/
     ├─ recipe_card.dart           # Carte recette réutilisable
     ├─ favorite_button.dart       # Bouton favori réutilisable
     ├─ category_chips_bar.dart    # Barre de filtres réutilisable
     ├─ rating_stars.dart          # Affichage de note en étoiles réutilisable
     └─ empty_state.dart           # État vide réutilisable

test/
 ├─ widget_test.dart               # Tests d'intégration UI (recherche, navigation)
 ├─ state/
 │   └─ app_state_test.dart        # Tests unitaires de la logique métier (AppState)
 └─ data/
     └─ recipe_repository_test.dart # Tests unitaires des données initiales
```

### Widgets Flutter utilisés (8+)
`ListView`, `GridView`, `Stack`/`Hero`, `Card`, `TextFormField`, `DropdownButtonFormField`,
`ChoiceChip`, `CircleAvatar`, `SliverAppBar`/`CustomScrollView`, `BottomNavigationBar`,
`NavigationRail`, `FloatingActionButton`, `LayoutBuilder`, `Form`, `SafeArea`, `Slider`,
`SegmentedButton`, `PopupMenuButton`, `Dismissible`, `AlertDialog`, `SwitchListTile`.

### Responsive design
La mise en page s'adapte à deux niveaux, via `LayoutBuilder` avec un point de rupture à
600 px (`kTabletBreakpoint`) :
- **Mobile** : `BottomNavigationBar`, liste verticale de recettes.
- **Tablette** : `NavigationRail` latéral persistant, grille de recettes à plusieurs colonnes.
L'utilisateur peut aussi forcer manuellement liste/grille depuis l'écran d'accueil ou les Réglages.

### Gestion d'état
L'application utilise le package **`provider`** (`ChangeNotifierProvider`), une solution de
gestion d'état standard et largement adoptée dans l'écosystème Flutter. `AppState` centralise
le thème, les recettes, les favoris, le tri et les préférences d'affichage ; les écrans y
accèdent via `context.watch<AppState>()` (pour se reconstruire aux changements) ou
`context.read<AppState>()` (pour déclencher une action ponctuelle, ex. dans un callback).

### Gestion des erreurs
Le formulaire d'ajout (`add_recipe_screen.dart`) encapsule la construction de la recette dans
un bloc `try/catch` : toute saisie numérique invalide affiche un message d'erreur explicite
(`SnackBar`) plutôt que de faire planter l'application. L'écran de détail gère aussi le cas
d'une recette introuvable (identifiant invalide dans l'URL).

## Installation et lancement

```bash
flutter pub get
flutter run
```

Pour lancer l'analyse statique (lints) :

```bash
flutter analyze
```

Pour lancer les tests (unitaires + widgets) :

```bash
flutter test
```

## Intégration continue

Un workflow GitHub Actions (`.github/workflows/build.yml`) exécute automatiquement, à chaque
push : `flutter analyze`, `flutter test`, puis `flutter build apk --release`. L'APK généré est
disponible en téléchargement dans l'onglet **Actions** du dépôt, section **Artifacts**.

## Captures d'écran

*(à ajouter après un premier lancement : accueil, détail, formulaire, favoris, réglages, mode sombre)*

## Auteur

Cheick — Licence 1, Mathématiques et Informatique Appliquées (MIA).
