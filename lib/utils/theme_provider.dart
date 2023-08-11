import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode;
  ThemeProvider({required this.isDarkMode});
  final ThemeData dark = ThemeData(
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: Colors.orange),
      brightness: Brightness.dark,
      listTileTheme: ListTileThemeData(
        textColor: Colors.white,
        tileColor: const Color(0xFF3E3E3E),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromARGB(87, 238, 180, 92), width: 1)),
      ),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.orange),
      switchTheme: const SwitchThemeData(
        thumbColor: MaterialStatePropertyAll<Color>(Colors.orange),
        trackColor: MaterialStatePropertyAll<Color>(Colors.orangeAccent),
      ),
      primaryColor: const Color(0xFF3E3E3E),
      dividerColor: Colors.white38,
      appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 58, 37, 116)));

  final ThemeData light = ThemeData(
      appBarTheme: const AppBarTheme(color: Color(0xff6F47DF)),
      primaryColor: Colors.white,
      tabBarTheme: const TabBarTheme(labelColor: Colors.white),
      brightness: Brightness.light,
      listTileTheme: ListTileThemeData(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color.fromARGB(80, 131, 97, 226),width: 1)),
          textColor: Colors.black,
          tileColor: Colors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.cyanAccent[700]));

  bool get themeBool => isDarkMode;
  ThemeData get theme {
    if (isDarkMode) {
      return dark;
    } else {
      return light;
    }
  }

  void toggleTheme(bool isDark) {
    isDarkMode = isDark;
    notifyListeners();
  }
}
