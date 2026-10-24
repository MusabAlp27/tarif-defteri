import 'recipe.dart';

/// Fotoğraftan okunan düz metni başlık / malzemeler / yapılış olarak böler.
/// Kusursuz değildir; kullanıcı kaydetmeden önce düzenleme ekranında düzeltir.
Recipe parseRecipeText(String raw) {
  final lines = raw
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();
  if (lines.isEmpty) {
    return const Recipe(title: '', ingredients: '', steps: '');
  }

  bool isIngredientHeader(String l) {
    final s = l.toLowerCase();
    return s.startsWith('malzeme');
  }

  bool isStepHeader(String l) {
    final s = l.toLowerCase();
    return s.startsWith('yapılış') ||
        s.startsWith('yapilis') ||
        s.startsWith('hazırlanış') ||
        s.startsWith('hazirlanis') ||
        s.startsWith('yapım');
  }

  final title = lines.first;
  final ingredients = <String>[];
  final steps = <String>[];
  var mode = 'none';

  for (final l in lines.skip(1)) {
    if (isIngredientHeader(l)) {
      mode = 'ing';
      continue;
    }
    if (isStepHeader(l)) {
      mode = 'step';
      continue;
    }
    if (mode == 'ing') {
      ingredients.add(l);
    } else if (mode == 'step') {
      steps.add(l);
    } else {
      // Başlık bulunamadıysa: kısa satırlar malzeme, uzun satırlar adım say.
      (l.length < 40 ? ingredients : steps).add(l);
    }
  }

  return Recipe(
    title: title,
    ingredients: ingredients.join('\n'),
    steps: steps.join('\n'),
  );
}
