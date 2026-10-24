import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'db.dart';
import 'detail_screen.dart';
import 'edit_screen.dart';
import 'ocr_parser.dart';
import 'recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> _recipes = [];
  String _query = '';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r = await RecipeDb.instance.all(query: _query);
    if (mounted) setState(() => _recipes = r);
  }

  Future<void> _openEditor([Recipe? recipe]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditScreen(recipe: recipe)),
    );
    if (saved == true) _load();
  }

  Future<void> _fromPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Fotoğraf çek'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galeriden seç'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ]),
      ),
    );
    if (source == null) return;

    final file = await ImagePicker().pickImage(source: source);
    if (file == null) return;

    setState(() => _busy = true);
    String text = '';
    try {
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final result =
          await recognizer.processImage(InputImage.fromFilePath(file.path));
      await recognizer.close();
      text = result.text;
    } catch (_) {
      text = '';
    }
    if (!mounted) return;
    setState(() => _busy = false);

    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Yazı okunamadı. Daha net bir fotoğraf deneyin.')),
      );
      return;
    }
    final draft = parseRecipeText(text);
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditScreen(recipe: draft, isDraft: true)),
    );
    if (saved == true) _load();
  }

  void _showAddMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.document_scanner),
            title: const Text('Fotoğraftan ekle'),
            subtitle: const Text('Defter veya kitaptaki tarifi okut'),
            onTap: () {
              Navigator.pop(context);
              _fromPhoto();
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Kendim yazayım'),
            onTap: () {
              Navigator.pop(context);
              _openEditor();
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarif Defteri')),
      body: Stack(children: [
        Column(children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Tarif veya malzeme ara',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                _query = v;
                _load();
              },
            ),
          ),
          Expanded(
            child: _recipes.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Henüz tarif yok.\nSağ alttaki + ile ilk tarifini ekle.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (_, i) {
                      final r = _recipes[i];
                      return ListTile(
                        leading: const Icon(Icons.restaurant_menu),
                        title: Text(r.title),
                        onTap: () async {
                          final changed = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailScreen(recipe: r)),
                          );
                          if (changed == true) _load();
                        },
                      );
                    },
                  ),
          ),
        ]),
        if (_busy)
          const ColoredBox(
            color: Color(0x88000000),
            child: Center(child: CircularProgressIndicator()),
          ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMenu,
        icon: const Icon(Icons.add),
        label: const Text('Tarif ekle'),
      ),
    );
  }
}
