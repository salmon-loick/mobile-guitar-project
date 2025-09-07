import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:mobile_guitar_project/main.dart';


import 'login_form.dart';

// Notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationsEnabled = false;
  bool _metronomeSound = true;
  String? _username;
  int _dailyGoal = 30;
  ThemeMode _themeMode = ThemeMode.system;
  TimeOfDay? _notifTime;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _initNotifications();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? false;
      _metronomeSound = prefs.getBool('metronomeSound') ?? true;
      _username = prefs.getString('username');
      _dailyGoal = prefs.getInt('dailyGoal') ?? 30;
      final hour = prefs.getInt('notifHour');
      final minute = prefs.getInt('notifMinute');
      if (hour != null && minute != null) {
        _notifTime = TimeOfDay(hour: hour, minute: minute);
      }
      _themeMode = (prefs.getString('themeMode') ?? 'system') == 'light'
          ? ThemeMode.light
          : (prefs.getString('themeMode') ?? 'system') == 'dark'
              ? ThemeMode.dark
              : ThemeMode.system;
    });
  }


  Future<void> _initNotifications() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Demande d’autorisation Android 13+
    final androidImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();

    // Demande d’autorisation iOS
    final iosImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<void> _saveString(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 19, minute: 0),
      );
      if (pickedTime != null) {
        await _saveBool('notifications', true);
        await _saveInt('notifHour', pickedTime.hour);
        await _saveInt('notifMinute', pickedTime.minute);

        _scheduleDailyNotification(pickedTime);

        setState(() {
          _notificationsEnabled = true;
          _notifTime = pickedTime;
        });
      }
    } else {
      await _saveBool('notifications', false);
      _cancelDailyNotification();
      setState(() {
        _notificationsEnabled = false;
        _notifTime = null;
      });
    }
  }

  Future<void> _scheduleDailyNotification(TimeOfDay time) async {
    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Rappel d'entraînement",
      "Il est temps de pratiquer ta guitare 🎸",
      TZDateTime.from(
        scheduledDate.isBefore(now)
            ? scheduledDate.add(const Duration(days: 1))
            : scheduledDate,
        local,
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Rappel quotidien',
          channelDescription:
              'Envoie une notification chaque jour à heure fixe',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notification programmée")),
    );
  }

  Future<void> _cancelDailyNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  void _toggleMetronomeSound(bool value) {
    _saveBool('metronomeSound', value);
    setState(() {
      _metronomeSound = value;
    });
  }

  void _changeDailyGoal(bool increase) {
    setState(() {
      _dailyGoal = increase
          ? _dailyGoal + 5
          : (_dailyGoal > 5 ? _dailyGoal - 5 : _dailyGoal);
    });
    _saveInt('dailyGoal', _dailyGoal);
  }

  void _navigateToLogin() async {
    if (_username != null) {
      setState(() {
        _username = null;
      });
      _saveString('username', null);
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      kLoginRoute);

    if (result is String) {
      setState(() {
        _username = result;
      });
      _saveString('username', result);
    }
  }

  void _changeTheme(ThemeMode mode) {
    if (mode == _themeMode) return;
    // save to prefs
    _saveString('themeMode', mode.toString().split('.').last);
    final parentState = appKey.currentState;
    if (parentState != null) {
      parentState.changeTheme(mode);
    }
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: ListView(
        children: [
          // Profil
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

          // Notifications
          SwitchListTile(
            title: const Text("Rappel d’entraînement"),
            subtitle: Text(_notificationsEnabled
                ? "Tous les jours à ${_notifTime?.format(context) ?? "??"}"
                : "Recevoir une notification quotidienne"),
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
                  onPressed: () => _changeDailyGoal(false),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _changeDailyGoal(true),
                ),
              ],
            ),
          ),

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
              style:
              TextStyle(color: Theme.of(context).primaryColor),
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
                  _changeTheme(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
