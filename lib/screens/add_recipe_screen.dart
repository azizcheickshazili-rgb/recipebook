import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';
import '../state/app_state.dart';

/// Écran 3 : formulaire de création de recette.
/// 5 champs validés : titre, description, temps de préparation, nombre de
/// personnes et catégorie (plus la difficulté et la note, sans validation
/// stricte puisqu'ils ont toujours une valeur par défaut valide).
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
  final _servingsController = TextEditingController(text: '4');
  final _ingredientsController = TextEditingController();

  String? _category;
  String _difficulty = RecipeRepository.difficulties.first;
  double _rating = 4.0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    _servingsController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Toute la construction de la recette est protégée : si un champ
    // numérique s'avérait malgré tout invalide (ex. saisie modifiée après
    // validation), l'utilisateur reçoit un message clair plutôt qu'un crash.
    try {
      final prepTime = int.parse(_timeController.text.trim());
      final servings = int.parse(_servingsController.text.trim());

      final ingredients = _ingredientsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final recipe = Recipe(
        id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category!,
        emoji: '🍽️',
        difficulty: _difficulty,
        prepTimeMinutes: prepTime,
        servings: servings,
        rating: _rating,
        ingredients:
            ingredients.isEmpty ? ['Ingrédient à préciser'] : ingredients,
      );

      // context.read (pas watch) : on déclenche une action ponctuelle,
      // ce widget n'a pas besoin de se reconstruire quand AppState change.
      context.read<AppState>().addRecipe(recipe);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${recipe.title}" a été ajoutée !')),
      );
      Navigator.of(context).pop();
    } on FormatException catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Certains champs numériques sont invalides. Vérifie tes saisies.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur est survenue : $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        labelText: 'Temps (minutes)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatoire';
                        }
                        final n = int.tryParse(value.trim());
                        if (n == null || n <= 0) {
                          return 'Nombre invalide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _servingsController,
                      decoration: const InputDecoration(
                        labelText: 'Personnes',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatoire';
                        }
                        final n = int.tryParse(value.trim());
                        if (n == null || n <= 0 || n > 50) {
                          return 'Entre 1 et 50';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
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
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Enregistrer la recette'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
