import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'main_scaffold.dart';

/// Écran 5 (bonus) : préférences d'affichage et statistiques de l'app.
/// Ajouté pour dépasser confortablement l'exigence minimale de 4 écrans.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.themeMode == ThemeMode.dark;

    return MainScaffold(
      currentIndex: 3,
      title: 'Réglages',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Apparence', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Thème sombre'),
              subtitle: const Text('Basculer entre thème clair et sombre'),
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              value: isDark,
              onChanged: (_) => appState.toggleTheme(),
            ),
          ),
          const SizedBox(height: 16),
          Text('Affichage par défaut',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Vue préférée sur petit écran'),
                  ),
                  SegmentedButton<ViewMode>(
                    segments: const [
                      ButtonSegment(
                        value: ViewMode.list,
                        icon: Icon(Icons.view_list),
                        label: Text('Liste'),
                      ),
                      ButtonSegment(
                        value: ViewMode.grid,
                        icon: Icon(Icons.grid_view),
                        label: Text('Grille'),
                      ),
                    ],
                    selected: {appState.preferredViewMode},
                    onSelectionChanged: (selection) =>
                        appState.setPreferredViewMode(selection.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Statistiques', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: const Text('Recettes au total'),
                  trailing: Text(
                    '${appState.recipes.length}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Favoris'),
                  trailing: Text(
                    '${appState.favoriteRecipes.length}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.person_add_alt),
                  title: const Text('Recettes ajoutées par toi'),
                  trailing: Text(
                    '${appState.recipes.where((r) => r.isCustom).length}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'RecipeBook — projet L1 MIA',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
