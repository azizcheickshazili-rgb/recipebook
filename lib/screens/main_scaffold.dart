import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../state/app_state.dart';

/// Largeur à partir de laquelle l'interface bascule en mise en page tablette.
const double kTabletBreakpoint = 600;

/// Structure commune partagée par les écrans "Accueil", "Favoris" et
/// "Réglages". Adaptative : navigation basse (`BottomNavigationBar`) sur
/// mobile, navigation latérale (`NavigationRail`) sur tablette, où l'on
/// dispose de plus d'espace horizontal.
class MainScaffold extends StatelessWidget {
  final int currentIndex;
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const MainScaffold({
    super.key,
    required this.currentIndex,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/favorites');
        break;
      case 2:
        context.push('/add');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.themeMode == ThemeMode.dark;

    final appBar = AppBar(
      title: Text(title),
      actions: [
        IconButton(
          tooltip: isDark ? 'Thème clair' : 'Thème sombre',
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: appState.toggleTheme,
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= kTabletBreakpoint;

        if (isTablet) {
          // Mise en page tablette : rail de navigation latéral persistant,
          // qui laisse davantage de place horizontale au contenu.
          return Scaffold(
            appBar: appBar,
            floatingActionButton: floatingActionButton,
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: (index) =>
                        _navigate(context, index),
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Accueil'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favoris'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.add_box),
                        label: Text('Ajouter'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Réglages'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: body),
                ],
              ),
            ),
          );
        }

        // Mise en page mobile : navigation basse classique.
        return Scaffold(
          appBar: appBar,
          body: SafeArea(child: body),
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) => _navigate(context, index),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Accueil'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favoris'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box), label: 'Ajouter'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Réglages'),
            ],
          ),
        );
      },
    );
  }
}
