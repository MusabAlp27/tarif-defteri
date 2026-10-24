import 'package:flutter/material.dart';

import 'db.dart';
import 'recipe.dart';

class EditScreen extends StatefulWidget {
  final Recipe? recipe;

  /// true ise fotoğraftan gelen taslaktır (henüz kayıtlı değil).
  final bool isDraft;

  const EditScreen({super.key, this.recipe, this.isDraft = false});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TextEditingController _title;
  late final TextEditingController _ingredients;
  late final TextEditingController _steps;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.recipe?.title ?? '');
    _ingredients = TextEditingController(text: widget.recipe?.ingredients ?? '');
    _steps = TextEditingController(text: widget.recipe?.steps ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _ingredients.dispose();
    _steps.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarife bir ad verin.')),
      );
      return;
    }
    await RecipeDb.instance.save(Recipe(
      id: widget.isDraft ? null : widget.recipe?.id,
      title: _title.text.trim(),
      ingredients: _ingredients.text.trim(),
      steps: _steps.text.trim(),
    ));
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isDraft
            ? 'Okunan tarifi kontrol et'
            : (widget.recipe == null ? 'Yeni tarif' : 'Tarifi düzenle')),
        actions: [
          TextButton(onPressed: _save, child: const Text('Kaydet')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.isDraft)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Yazı fotoğraftan okundu. Hataları düzeltip kaydedin.',
              ),
            ),
          TextField(
            controller: _title,
            decoration: const InputDecoration(
                labelText: 'Tarif adı', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ingredients,
            minLines: 4,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Malzemeler (her satıra bir tane)',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _steps,
            minLines: 6,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Yapılışı (her satıra bir adım)',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
