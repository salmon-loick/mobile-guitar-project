import 'package:flutter/material.dart';

class Accords extends StatefulWidget {
  @override
  State<Accords> createState() => _AccordsState();
}

class _AccordsState extends State<Accords> {
  // Liste des accords avec leur image
  final List<Map<String, String>> accords = [
    {"titre": "Do", "image": "assets/img/AccordDo.png"},
    {"titre": "Ré", "image": "assets/img/AccordRe.png"},
    {"titre": "Mi", "image": "assets/img/AccordMi.png"},
    {"titre": "Fa", "image": "assets/img/AccordFa.png"},
    {"titre": "Sol", "image": "assets/img/AccordSol.png"},
    {"titre": "La", "image": "assets/img/AccordLa.png"},
    {"titre": "Si", "image": "assets/img/AccordSi.png"},
  ];

  Brightness? _lastBrightness;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentBrightness = Theme.of(context).brightness;

    // Si le thème (jour/nuit) a changé → on force un rebuild
    if (_lastBrightness != currentBrightness) {
      _lastBrightness = currentBrightness;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("Accords de guitare")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 images par ligne
            crossAxisSpacing: 8,
            mainAxisSpacing: 12,
          ),
          itemCount: accords.length,
          itemBuilder: (context, index) {
            final accord = accords[index];
            return Column(
              children: [
                Text(
                  accord["titre"]!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    // Lorsqu’on clique -> on ouvre l'image en grand
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AccordDetailPage(
                          titre: accord["titre"]!,
                          imagePath: accord["image"]!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Image.asset(
                      accord["image"]!,
                      key: ValueKey(Theme.of(context).brightness), // 🔑 force le rebuild quand le thème change
                      height: 120,
                      fit: BoxFit.contain,
                      color: isDark
                          ? Colors.white.withOpacity(0.9)
                          : null,
                      colorBlendMode: isDark
                          ? BlendMode.srcIn
                          : null,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AccordDetailPage extends StatelessWidget {
  final String titre;
  final String imagePath;

  const AccordDetailPage({
    Key? key,
    required this.titre,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text("Accord $titre")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Accord $titre",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset(
              imagePath,
              height: 300,
              fit: BoxFit.contain,
              color: isDark
                  ? Colors.white.withOpacity(0.9)
                  : null,
              colorBlendMode: isDark
                  ? BlendMode.srcIn
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}