// ignore_for_file: unnecessary_null_comparison

import 'package:birthday_alert/pages/home.dart';
import 'package:birthday_alert/utils/preference_provider.dart';
import 'package:birthday_alert/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'helpers/database_helper.dart';
import 'helpers/preference.dart';
import 'helpers/reminder.dart';
import 'model/birthday_model.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init Android local notifications
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
// Hive database part
  await Hive.initFlutter();
  Hive.registerAdapter(BirthdayAdapter());
  await Hive.openBox('birthdayBox');
  await AndroidAlarmManager.initialize(); // Alarm manager init
  PreferenceHelper.setReminderStartupPreferenceValue();
  //
  // get the shred pref value
  bool reminderPrefValue = await PreferenceHelper.getReminderPreferenceValue();
  String remindertimePrefValue =
      await PreferenceHelper.getReminderTimePreferenceValue();
  bool themeMode = await PreferenceHelper.getThemeButtonValue();
  //runapp
  runApp(MyApp(
    themePref: themeMode,
    reminderBool: reminderPrefValue,
    reminderTime: remindertimePrefValue,
  ));
  // this line excute when app first run
  if (reminderPrefValue) {
    Reminder.runReminder(remindertimePrefValue); // run reminder
  } else {
    Reminder.cancelReminder();
  }
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key,
      required this.themePref,
      required this.reminderBool,
      required this.reminderTime});
  final bool themePref;
  final bool reminderBool;
  final String reminderTime;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // For database updates
        ChangeNotifierProvider(
          create: (context) => DatabaseProvider(),
        ),
        // For theme updates
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(isDarkMode: themePref),
        ),
        
        // For shared preference updates
        ChangeNotifierProvider(
          create: (context) => PreferenceProvider(
              reminderTime: reminderTime, reminderValue: reminderBool),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            theme: value.theme,
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
