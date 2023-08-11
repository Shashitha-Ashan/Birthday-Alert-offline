// ignore_for_file: unnecessary_null_comparison, prefer_final_fields

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restart_app/restart_app.dart';

import '../model/birthday_model.dart';

class Reminder {
  static int _alarmId = 0;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<bool> isTommorrowHasBirthdays() async {
    await Hive.initFlutter();
    Hive.registerAdapter(BirthdayAdapter(), override: true);
    final birthdayBox = await Hive.openBox('birthdayBox');
    final birthdayList = birthdayBox.values.toList();
    var tomorrow = DateTime.now().add(const Duration(days: 1));
    final tommorowList = birthdayList.where((element) {
      return element.birthday.day == tomorrow.day &&
          element.birthday.month == tomorrow.month;
    }).toList();
    if (tommorowList.isNotEmpty && tommorowList != null) {
      return true;
    } else {
      return false;
    }
  }

  @pragma('vm:entry-point')
  static Future<void> showNotification() async {
    bool tommorowBirthdays = await isTommorrowHasBirthdays();
    if (tommorowBirthdays) {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'bodNotify', 'Birthdays notification',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true);
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        'Birthday Alert',
        'Check, tomorrow may be your friend\'s birthday',
        platformChannelSpecifics,
        payload: 'Custom payload',
      );
    }
  }

  static Future<void> showRestartAppAlert(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Restart.restartApp();
                },
                child: const Text('OK'),
              )
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Icon(
              Icons.warning_rounded,
              size: 35,
              color: Colors.amber,
            ),
            content: const Text(
              'Please restart the app to complete this process',
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  static Future<void> runReminder(String timeVal) async {
    //

    final time = timeVal.split(':');
    int hour = int.parse(time[0]);
    int min = int.parse(time[1]);
    await AndroidAlarmManager.periodic(
        const Duration(days: 1), _alarmId, showNotification,
        startAt: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, hour, min),
        rescheduleOnReboot: true);
  }

  static void cancelReminder() async {
    await AndroidAlarmManager.cancel(_alarmId);
  }
}
