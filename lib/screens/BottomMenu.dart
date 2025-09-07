import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/screens/Accords.dart';
import 'Metronome.dart';
import 'Settings.dart';
import 'Tuner.dart';


class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key, required this.changeChild});

  final void Function(Widget) changeChild;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              changeChild(const Metronome());
            },
            icon: Image.asset(
              'assets/img/metronome.png',
              width: 26,
              height: 26,
              color: Theme.of(context).iconTheme.color,
            ),
            tooltip: 'Métronome',
          ),
          IconButton(
            onPressed: () {
              changeChild(const Tuner());
            },
            icon: Image.asset(
              'assets/img/guitare_icone.png',
              width: 26,
              height: 26,
              color: Theme.of(context).iconTheme.color,
            ),
            tooltip: 'Guitare',
          ),
          IconButton(
            icon: const Icon(Icons.settings, size : 26),
            onPressed: () {
              changeChild(Settings());
            },
          ),
          IconButton(
            icon: const Icon(Icons.library_music),
            onPressed: () {
              changeChild(Accords());

              /*Navigator.pushNamed(
                context,
                kAccordRoute,
              );*/
            },
          ),
        ],
      ),
    );
  }
}


