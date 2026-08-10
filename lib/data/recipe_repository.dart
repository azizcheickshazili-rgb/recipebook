import '../models/recipe.dart';

/// Fournit les données initiales de l'application.
/// Aucune donnée n'est écrite en dur dans les widgets : tout passe par ici,
/// puis par [AppState], respectant l'exigence de séparation UI / données.
class RecipeRepository {
  static List<Recipe> initialRecipes() => [
        const Recipe(
          id: 'r1',
          title: 'Poulet Yassa',
          description:
              'Un classique sénégalais : poulet mariné au citron et oignons confits.',
          category: 'Plat principal',
          emoji: '🍗',
          difficulty: 'Moyen',
          prepTimeMinutes: 45,
          rating: 4.5,
          ingredients: [
            '1 poulet découpé',
            '4 oignons',
            '2 citrons',
            'Moutarde',
            'Huile',
            'Piment',
          ],
        ),
        const Recipe(
          id: 'r2',
          title: 'Salade César',
          description: 'Laitue croquante, poulet grillé, parmesan et croûtons.',
          category: 'Entrée',
          emoji: '🥗',
          difficulty: 'Facile',
          prepTimeMinutes: 20,
          rating: 4.0,
          ingredients: [
            'Laitue romaine',
            'Blanc de poulet',
            'Parmesan',
            'Croûtons',
            'Sauce César',
          ],
        ),
        const Recipe(
          id: 'r3',
          title: 'Tiramisu',
          description: 'Le dessert italien crémeux au café et mascarpone.',
          category: 'Dessert',
          emoji: '🍰',
          difficulty: 'Moyen',
          prepTimeMinutes: 30,
          rating: 5.0,
          ingredients: [
            'Mascarpone',
            'Café fort',
            'Biscuits cuillère',
            'Œufs',
            'Cacao en poudre',
          ],
        ),
        const Recipe(
          id: 'r4',
          title: 'Smoothie mangue-banane',
          description: 'Boisson fruitée rapide, parfaite pour le petit-déjeuner.',
          category: 'Boisson',
          emoji: '🥤',
          difficulty: 'Facile',
          prepTimeMinutes: 5,
          rating: 3.5,
          ingredients: ['Mangue', 'Banane', 'Lait', 'Miel'],
        ),
        const Recipe(
          id: 'r5',
          title: 'Riz sauté aux légumes',
          description: 'Un plat végétarien coloré et rapide à préparer.',
          category: 'Plat principal',
          emoji: '🍚',
          difficulty: 'Facile',
          prepTimeMinutes: 25,
          rating: 4.0,
          ingredients: [
            'Riz cuit',
            'Carottes',
            'Petits pois',
            'Sauce soja',
            'Œuf',
          ],
        ),
        const Recipe(
          id: 'r6',
          title: 'Soupe à l\'oignon',
          description: 'Réconfortante, gratinée au fromage et croûtons.',
          category: 'Entrée',
          emoji: '🍲',
          difficulty: 'Moyen',
          prepTimeMinutes: 50,
          rating: 4.5,
          ingredients: ['Oignons', 'Bouillon', 'Pain', 'Gruyère'],
        ),
      ];

  static const List<String> categories = [
    'Entrée',
    'Plat principal',
    'Dessert',
    'Boisson',
  ];

  static const List<String> difficulties = ['Facile', 'Moyen', 'Difficile'];
}
