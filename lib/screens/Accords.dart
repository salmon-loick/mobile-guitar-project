// dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Widget principal : écran d'accords
class Accords extends StatefulWidget {
  @override
  State<Accords> createState() => _AccordsState();
}

class _AccordsState extends State<Accords> {
  // ImagePicker pour ouvrir la galerie et récupérer une image
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> accords = [
    {"titre": "Do", "image": "assets/img/AccordDo.png", "isAsset": true},
    {"titre": "Ré", "image": "assets/img/AccordRe.png", "isAsset": true},
    {"titre": "Mi", "image": "assets/img/AccordMi.png", "isAsset": true},
    {"titre": "Fa", "image": "assets/img/AccordFa.png", "isAsset": true},
    {"titre": "Sol", "image": "assets/img/AccordSol.png", "isAsset": true},
    {"titre": "La", "image": "assets/img/AccordLa.png", "isAsset": true},
    {"titre": "Si", "image": "assets/img/AccordSi.png", "isAsset": true},
  ];

  // Variables pour la persistance locale
  Directory? _appDir; // ApplicationDocumentsDirectory
  File? _dataFile; // <appDir>/tablatures.json : liste des images utilisateur
  Directory?
      _imagesDir; // <appDir>/tablatures_images : copie des images importées

  // Utilisé pour forcer un rebuild si le thème change
  Brightness? _lastBrightness;

  @override
  void initState() {
    super.initState();
    // Initialisation asynchrone du stockage local et chargement des données
    _initStorage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentBrightness = Theme.of(context).brightness;
    if (_lastBrightness != currentBrightness) {
      _lastBrightness = currentBrightness;
      setState(() {});
    }
  }

  // Initialisation du stockage local
  // Crée un dossier pour stocker les images et référence le fichier JSON
  Future<void> _initStorage() async {
    _appDir = await getApplicationDocumentsDirectory();

    // dossier pour conserver les images importées par l'utilisateur
    _imagesDir = Directory(p.join(_appDir!.path, 'tablatures_images'));
    if (!await _imagesDir!.exists()) {
      await _imagesDir!.create(recursive: true);
    }

    // fichier JSON pour enregistrer la liste des images utilisateur
    _dataFile = File(p.join(_appDir!.path, 'tablatures.json'));

    // Charger les images sauvegardées (si présentes)
    await _loadSaved();
  }

  // Chargement des tablatures sauvegardées
  // Lit tablatures.json et ajoute chaque entrée existante à la liste "accords"
  Future<void> _loadSaved() async {
    if (_dataFile == null) return;
    if (!await _dataFile!.exists()) return;
    try {
      final content = await _dataFile!.readAsString();
      final List<dynamic> list = json.decode(content);
      for (final item in list) {
        if (item is Map<String, dynamic>) {
          // Vérifier que le fichier image copié existe toujours avant de l'ajouter
          final String imgPath = item['image'] as String? ?? '';
          if (await File(imgPath).exists()) {
            accords.add({
              "titre": item['titre'] ?? 'Nouvelle tablature',
              "image": imgPath,
              "isAsset": false,
            });
          }
        }
      }

      // Mettre à jour l'interface après le chargement asynchrone
      setState(() {});
    } catch (e) {
      // Erreur JSON/IO : on peut logger ou afficher un message si nécessaire
    }
  }

  // Sauvegarde des images utilisateur
  // Écrit dans tablatures.json la liste des éléments non-asset
  Future<void> _saveUserImages() async {
    if (_dataFile == null) return;

    final List<Map<String, dynamic>> toSave = accords
        .where((a) => !(a['isAsset'] as bool? ?? false))
        .map((a) => {
              'titre': a['titre'],
              'image': a['image'],
              'isAsset': false,
            })
        .toList();

    await _dataFile!.writeAsString(json.encode(toSave));
  }

  Future<void> _pickImageAndAdd() async {
    try {
      final XFile? picked =
          await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return; // utilisateur annule

      // Générer un nom unique (timestamp) et copier le fichier dans _imagesDir
      final ext = p.extension(picked.path);
      final filename = '${DateTime.now().millisecondsSinceEpoch}$ext';
      final targetPath = p.join(_imagesDir!.path, filename);
      await File(picked.path).copy(targetPath);
      final String name =
          picked.name.isNotEmpty ? picked.name : 'Nouvelle tablature';

      // Ajouter l'image copiée à la liste
      setState(() {
        accords.add({
          "titre": name,
          "image": targetPath,
          "isAsset": false,
        });
      });

      // Sauvegarder la nouvelle liste
      await _saveUserImages();
    } catch (e) {
      // Gestion d'erreur possible : affichage d'un snackbar ou log
    }
  }

  // Suppression d'une image utilisateur
  // Affiche une confirmation, supprime le fichier si présent, met à jour la liste et sauvegarde
  Future<void> _confirmDelete(int index) async {
    final item = accords[index];
    final bool isAsset = item['isAsset'] as bool;

    // Empêcher la suppression des assets intégrés
    if (isAsset) {
      // ne pas permettre suppression
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Suppression'),
          content:
              const Text('Les accords intégrés ne peuvent pas être supprimés.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    // Demander confirmation pour la suppression
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous supprimer cette tablature ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer')),
        ],
      ),
    );

    if (res == true) {
      try {
        // Supprime physiquement le fichier copié si il existe
        final String imgPath = item['image'] as String;
        final f = File(imgPath);
        if (await f.exists()) await f.delete();
      } catch (e) {
        // Ignorer / logger l'erreur
      }

      // Mettre à jour la liste en mémoire et sauvegarder
      setState(() {
        accords.removeAt(index);
      });
      await _saveUserImages();
    }
  }

  // Construction de l'interface utilisateur
  @override
  Widget build(BuildContext context) {

    // Scaffold principal : AppBar + grille d'images + FloatingActionButton
    return Scaffold(
      appBar: AppBar(title: const Text("Accords de guitare")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 12,
          ),
          itemCount: accords.length,
          itemBuilder: (context, index) {
            final accord = accords[index];
            final bool isAsset = accord['isAsset'] as bool;
            final String imagePath = accord['image'] as String;
            return Column(
              children: [
                Text(accord["titre"] as String,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                GestureDetector(
                  onLongPress: () => _confirmDelete(index),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AccordDetailPage(
                          titre: accord["titre"] as String,
                          imagePath: imagePath,
                          isAsset: isAsset,
                          // onDelete est un callback qui permet de supprimer depuis la page détail
                          onDelete: isAsset
                              ? null
                              : () async {
                                  final idx = accords.indexWhere(
                                      (a) => a['image'] == imagePath);
                                  if (idx != -1) {
                                    await _confirmDelete(idx);
                                  }
                                },
                        ),
                      ),
                    );
                  },

                  // Conteneur visuel de la vignette
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),

                    // Affichage : si asset utilise Image.asset sinon Image.file
                    child: isAsset
                        ? Image.asset(
                            imagePath,
                            height: 120,
                            fit: BoxFit.contain,
                            color: Theme.of(context).primaryColor,
                          )
                        : Image.file(
                            File(imagePath),
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      // Bouton flottant pour ajouter une nouvelle tablature
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImageAndAdd,
        child: const Icon(Icons.add),
        tooltip: 'Ajouter une tablature',
      ),
    );
  }
}

// Page de détail affichant l'image en grand (InteractiveViewer pour zoom/pan)
// Le titre est affiché dans l'AppBar à côté du bouton retour.
class AccordDetailPage extends StatelessWidget {
  final String titre;
  final String imagePath;
  final bool isAsset;
  final Future<void> Function()?
      onDelete; // callback optionnel pour déclencher suppression

  const AccordDetailPage({
    Key? key,
    required this.titre,
    required this.imagePath,
    required this.isAsset,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titre), // titre près de la flèche retour
        actions: [
          // Si l'image est importée par l'utilisateur, on propose un bouton supprimer
          if (!isAsset)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Supprimer'),
                    content: const Text('Supprimer cette tablature ?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Annuler')),
                      TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Supprimer')),
                    ],
                  ),
                );
                if (confirm == true) {
                  // Appelle le callback défini par la page précédente, puis ferme la page détail
                  if (onDelete != null) await onDelete!();
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),

      // InteractiveViewer permet le zoom + déplacement (pan) de l'image
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 5.0,
          child: isAsset
              ? Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  color: Theme.of(context).primaryColor,
                )
              : Image.file(File(imagePath), fit: BoxFit.contain),
        ),
      ),
    );
  }
}
