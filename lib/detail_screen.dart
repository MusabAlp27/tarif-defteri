import 'package:flutter/material.dart';

import 'db.dart';
import 'edit_screen.dart';
import 'recipe.dart';

class DetailScreen extends StatelessWidget {
  final Recipe recipe;
  const DetailScreen({super.key, required this.recipe});

  List<String> _lines(String s) =>
      s.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  @override
  Widget build(BuildContext context) {
    final ing = _lines(recipe.ingredients);
    final steps = _lines(recipe.steps);
    final heading = Theme.of(context).textTheme.titleLarge;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final saved = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => EditScreen(recipe: recipe)),
              );
              if (saved == true && context.mounted) Navigator.pop(context, true);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Tarif silinsin mi?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Vazgeç')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Sil')),
                  ],
                ),
              );
              if (ok == true) {
                await RecipeDb.instance.delete(recipe.id!);
                if (context.mounted) Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Malzemeler', style: heading),
          const SizedBox(height: 8),
          for (final i in ing)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• $i'),
            ),
          const SizedBox(height: 24),
          Text('Yapılışı', style: heading),
          const SizedBox(height: 8),
          for (var n = 0; n < steps.length; n++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('${n + 1}. ${steps[n]}'),
            ),
        ],
      ),
    );
  }
}
