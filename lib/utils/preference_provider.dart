// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class PreferenceProvider extends ChangeNotifier {
  bool reminderValue;
  String reminderTime;

  PreferenceProvider({required this.reminderValue,required this.reminderTime});

  bool get reminderPrefValue => reminderValue;
  String get reminderTimePrefValue => reminderTime;
  void changeReminderValue(bool value) {
    reminderValue = value;
    notifyListeners();
  }

  void changeReminderTime(String value) {
    if (value != null) {
      reminderTime = value;
    }
    notifyListeners();
  }
}
