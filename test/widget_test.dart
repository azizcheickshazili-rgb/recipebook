import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/state/app_state.dart';

void main() {
  testWidgets('L\'écran d\'accueil affiche le titre et des recettes',
      (WidgetTester tester) async {
    await tester.pumpWidget(RecipeBookApp(appState: AppState()));
    await tester.pumpAndSettle();

    expect(find.text('RecipeBook'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('La recherche filtre la liste des recettes',
      (WidgetTester tester) async {
    await tester.pumpWidget(RecipeBookApp(appState: AppState()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Tiramisu');
    await tester.pumpAndSettle();

    // On utilise le titre de la carte (widget Text), en excluant le champ
    // de recherche lui-même qui contient aussi le texte tapé.
    expect(find.widgetWithText(Card, 'Tiramisu'), findsOneWidget);
    expect(find.text('Poulet Yassa'), findsNothing);
  });
}
