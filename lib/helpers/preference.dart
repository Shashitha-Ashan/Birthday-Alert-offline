import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static Future<bool> getReminderPreferenceValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? preferenceValue = prefs.getBool('repeat') ?? false;
    return preferenceValue;
  }

  static Future<bool> getThemeButtonValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? preferenceValue = prefs.getBool('theme') ?? false;
    return preferenceValue;
  }

  static Future<String> getReminderTimePreferenceValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String preferenceValue = prefs.getString('reminderTime') ?? '22:0';
    return preferenceValue;
  }

  static void setThemeValue(bool themeValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', themeValue);
  }

  static void setReminderTimePreferenceValue(String? hour, String? min) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (hour != null && min != null) {
      await prefs.setString('reminderTime', '$hour:$min');
    }
  }

  static void setReminderStartupPreferenceValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? reminderValue = prefs.getBool('repeat');
    String? preferenceValue = prefs.getString('reminderTime');
    bool? themeValue = prefs.getBool('theme');
    if (reminderValue == null &&
        preferenceValue == null &&
        themeValue == null) {
      await prefs.setBool('repeat', true);
      await prefs.setString('reminderTime', '22:0');
      await prefs.setBool('theme', false);
    }
  }
}
