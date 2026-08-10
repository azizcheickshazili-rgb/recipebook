import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(RecipeBookApp(appState: AppState()));
}

class RecipeBookApp extends StatelessWidget {
  final AppState appState;

  const RecipeBookApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: appState,
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'RecipeBook',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: appState.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
