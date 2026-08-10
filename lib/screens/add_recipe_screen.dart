import 'package:flutter/material.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';
import '../state/app_state.dart';

/// Écran 3 : formulaire de création de recette.
/// 4 champs validés : titre, description, temps de préparation, catégorie.
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _ingredientsController = TextEditingController();

  String? _category;
  String _difficulty = RecipeRepository.difficulties.first;
  double _rating = 4.0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final appState = AppStateScope.of(context);
    final ingredients = _ingredientsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final recipe = Recipe(
      id: 'r${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category!,
      emoji: '🍽️',
      difficulty: _difficulty,
      prepTimeMinutes: int.parse(_timeController.text.trim()),
      rating: _rating,
      ingredients:
          ingredients.isEmpty ? ['Ingrédient à préciser'] : ingredients,
    );

    appState.addRecipe(recipe);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${recipe.title}" a été ajoutée !')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle recette')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le titre est obligatoire';
                  }
                  if (value.trim().length < 3) {
                    return 'Le titre doit contenir au moins 3 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La description est obligatoire';
                  }
                  if (value.trim().length < 10) {
                    return 'Décris la recette en au moins 10 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Temps de préparation (minutes)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Indique un temps de préparation';
                  }
                  final n = int.tryParse(value.trim());
                  if (n == null || n <= 0) {
                    return 'Entre un nombre de minutes valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: RecipeRepository.categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value),
                validator: (value) =>
                    value == null ? 'Choisis une catégorie' : null,
              ),
              const SizedBox(height: 16),
              Text('Difficulté', style: Theme.of(context).textTheme.labelLarge),
              Wrap(
                spacing: 8,
                children: RecipeRepository.difficulties.map((d) {
                  return ChoiceChip(
                    label: Text(d),
                    selected: _difficulty == d,
                    onSelected: (_) => setState(() => _difficulty = d),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('Note : ${_rating.toStringAsFixed(1)} / 5',
                  style: Theme.of(context).textTheme.labelLarge),
              Slider(
                value: _rating,
                min: 0,
                max: 5,
                divisions: 10,
                label: _rating.toStringAsFixed(1),
                onChanged: (value) => setState(() => _rating = value),
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingrédients (séparés par des virgules)',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('Enregistrer la recette'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
