import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';
import '../state/app_state.dart';
import '../widgets/category_chips_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/recipe_card.dart';
import 'main_scaffold.dart';

/// Écran de liste : recherche par texte + filtrage par catégorie + tri.
/// Responsive : ListView sur mobile, GridView sur tablette (largeur >= 600),
/// avec possibilité de forcer manuellement l'affichage sur mobile.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Recipe> _filter(List<Recipe> all) {
    return all.where((r) {
      final matchesQuery =
          r.title.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _selectedCategory == null || r.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final filtered = _filter(appState.recipes);

    return MainScaffold(
      currentIndex: 0,
      title: 'RecipeBook',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher une recette...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                            ),
                    ),
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<SortOption>(
                  tooltip: 'Trier',
                  icon: const Icon(Icons.sort),
                  initialValue: appState.sortOption,
                  onSelected: appState.setSortOption,
                  itemBuilder: (context) => SortOption.values
                      .map((option) => PopupMenuItem(
                            value: option,
                            child: Text(option.label),
                          ))
                      .toList(),
                ),
                IconButton(
                  tooltip: appState.preferredViewMode == ViewMode.list
                      ? 'Afficher en grille'
                      : 'Afficher en liste',
                  icon: Icon(appState.preferredViewMode == ViewMode.list
                      ? Icons.grid_view
                      : Icons.view_list),
                  onPressed: () => appState.setPreferredViewMode(
                    appState.preferredViewMode == ViewMode.list
                        ? ViewMode.grid
                        : ViewMode.list,
                  ),
                ),
              ],
            ),
          ),
          CategoryChipsBar(
            categories: RecipeRepository.categories,
            selected: _selectedCategory,
            onSelected: (value) => setState(() => _selectedCategory = value),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off,
                    message: 'Aucune recette ne correspond à ta recherche.',
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final isTablet = constraints.maxWidth >= 600;
                      final showGrid =
                          isTablet || appState.preferredViewMode == ViewMode.grid;
                      if (showGrid) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet ? 3 : 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final recipe = filtered[index];
                            return RecipeCard(
                              recipe: recipe,
                              isFavorite: appState.isFavorite(recipe.id),
                              onToggleFavorite: () =>
                                  appState.toggleFavorite(recipe.id),
                            );
                          },
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final recipe = filtered[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: RecipeCard(
                              recipe: recipe,
                              isFavorite: appState.isFavorite(recipe.id),
                              onToggleFavorite: () =>
                                  appState.toggleFavorite(recipe.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }
}
