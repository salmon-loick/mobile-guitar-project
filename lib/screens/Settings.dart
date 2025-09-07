import 'package:flutter/material.dart';

import 'login_form.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationsEnabled = false;
  bool _metronomeSound = true;
  String? _username; // null = utilisateur non connecté
  int _dailyGoal = 30; // minutes d’entraînement par défaut
  ThemeMode _themeMode = ThemeMode.system;

  void _navigateToLogin() async {
    // Simule la navigation vers ta page de login
    bool loggedIn = _username != null;
    if (loggedIn) {
      // Déconnexion
      setState(() {
        _username = null;
      });
      return;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginForm()),
    );

    // Simule un retour avec un nom d’utilisateur
    if (result is String) {
      setState(() {
        _username = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: ListView(
        children: [
          // Section profil
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(_username ?? "Non connecté"),
            subtitle: Text(_username != null
                ? "Bienvenue, $_username"
                : "Appuyez pour vous connecter"),
            trailing: ElevatedButton(
              onPressed: _navigateToLogin,
              child: Text(_username == null ? "Connexion" : "Déconnexion"),
            ),
          ),
          const Divider(),

          // Notifications d’entraînement
          SwitchListTile(
            title: const Text("Rappel d’entraînement"),
            subtitle: const Text("Recevoir une notification quotidienne"),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications),
          ),

          // Sons du métronome
          SwitchListTile(
            title: const Text("Sons du métronome"),
            subtitle: const Text("Activer/désactiver le son"),
            value: _metronomeSound,
            onChanged: (value) {
              setState(() {
                _metronomeSound = value;
              });
            },
            secondary: const Icon(Icons.music_note),
          ),

          // Objectif quotidien
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text("Objectif quotidien"),
            subtitle: Text("$_dailyGoal minutes d’entraînement"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_dailyGoal > 5) _dailyGoal -= 5;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _dailyGoal += 5;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(),

          // Choix du thème
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text("Thème de l’application"),
            subtitle: Text(_themeMode == ThemeMode.light
                ? "Clair"
                : _themeMode == ThemeMode.dark
                ? "Sombre"
                : "Automatique (système)"),
            trailing: DropdownButton<ThemeMode>(
              value: _themeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text("Système"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text("Clair"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text("Sombre"),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _themeMode = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}