import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../state/app_state.dart';

/// Structure commune (AppBar avec bouton de thème + navigation basse)
/// partagée par les écrans "Accueil" et "Favoris" pour éviter la duplication.
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

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = appState.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: isDark ? 'Thème clair' : 'Thème sombre',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: appState.toggleTheme,
          ),
        ],
      ),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
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
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Ajouter'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Réglages'),
        ],
      ),
    );
  }
}
