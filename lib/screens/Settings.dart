import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/routes.dart';
import 'Home.dart';
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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Charge les paramètres sauvegardés
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? false;
      _metronomeSound = prefs.getBool('metronomeSound') ?? true;
      _dailyGoal = prefs.getInt('dailyGoal') ?? 30;
      _username = prefs.getString('username');
      final themeIndex = prefs.getInt('themeMode') ?? 0;
      _themeMode = ThemeMode.values[themeIndex];
    });
  }

  /// Sauvegarde le bool notifications
  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  /// Sauvegarde le bool son métronome
  Future<void> _toggleMetronomeSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('metronomeSound', value);
    setState(() {
      _metronomeSound = value;
    });
  }

  /// Sauvegarde l’objectif quotidien
  Future<void> _updateDailyGoal(int newGoal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dailyGoal', newGoal);
    setState(() {
      _dailyGoal = newGoal;
    });
  }

  /// Sauvegarde le thème
  Future<void> _updateTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    setState(() {
      _themeMode = mode;
    });
  }

  /// Gère la connexion / déconnexion
  Future<void> _navigateToLogin() async {
    bool loggedIn = _username != null;
    final prefs = await SharedPreferences.getInstance();

    if (loggedIn) {
      // Déconnexion
      await prefs.remove('username');
      setState(() {
        _username = null;
      });
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      kLoginRoute);

    if (result is String) {
      await prefs.setString('username', result);
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
            subtitle: Text(
                _username != null ? "Bienvenue, $_username" : "Appuyez pour vous connecter"),
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
            onChanged: _toggleNotifications,
            secondary: const Icon(Icons.notifications),
          ),

          // Sons du métronome
          SwitchListTile(
            title: const Text("Sons du métronome"),
            subtitle: const Text("Activer/désactiver le son"),
            value: _metronomeSound,
            onChanged: _toggleMetronomeSound,
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
                    if (_dailyGoal > 5) {
                      _updateDailyGoal(_dailyGoal - 5);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _updateDailyGoal(_dailyGoal + 5);
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
                  _updateTheme(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
