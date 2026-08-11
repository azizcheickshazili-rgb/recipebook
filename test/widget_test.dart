import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipebook/main.dart';

void main() {
  testWidgets('L\'écran d\'accueil affiche le titre et des recettes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeBookApp());
    await tester.pumpAndSettle();

    expect(find.text('RecipeBook'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('La recherche filtre la liste des recettes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeBookApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Tiramisu');
    await tester.pumpAndSettle();

    // On utilise le titre de la carte (widget Text), en excluant le champ
    // de recherche lui-même qui contient aussi le texte tapé.
    expect(find.widgetWithText(Card, 'Tiramisu'), findsOneWidget);
    expect(find.text('Poulet Yassa'), findsNothing);
  });

  testWidgets('La navigation basse permet d\'atteindre les Réglages',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeBookApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Réglages'));
    await tester.pumpAndSettle();

    expect(find.text('Thème sombre'), findsOneWidget);
  });
}
