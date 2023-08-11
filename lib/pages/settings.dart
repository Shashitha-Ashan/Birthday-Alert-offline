// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/preference.dart';
import '../helpers/reminder.dart';
import '../utils/preference_provider.dart';
import '../utils/theme_provider.dart';
import 'developer_info.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _sendEmail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'shashithaashan2001@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Report bug/Feedback',
      }),
    );

    launchUrl(emailLaunchUri);
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 10,
        title: const Text('Settings'),
      ),
      body: ListView(
        physics:const BouncingScrollPhysics(),
        children: [
          settingSectionTile('Genaral Settings'),
          Consumer<PreferenceProvider>(
            builder: (context, value, child) {
              return SettingTile(
                  title: 'Daily reminder',
                  description: value.reminderPrefValue ? 'on' : 'off',
                  trailingWidget: Switch(
                    onChanged: (value) async {
                      Reminder.cancelReminder(); // the
                      // reminder on off button logic
                      final SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.setBool('repeat', value);
                      Reminder.showRestartAppAlert(context);
                      Provider.of<PreferenceProvider>(context, listen: false)
                          .changeReminderValue(value);
                    },
                    value: value.reminderValue,
                  ));
            },
          ),
          Consumer<PreferenceProvider>(builder: (context, value, child) {
            return SettingTile(
              isDisable: value.reminderPrefValue,
              onTap: value.reminderValue
                  ? () async {
                      TimeOfDay? selectedTime =
                          await showTimePickerDialog(context);
                      if (selectedTime != null) {
                        String hour = selectedTime.hour.toString();
                        String min = selectedTime.minute.toString();
                        String selectedTimeString = '$hour:$min';
                        Provider.of<PreferenceProvider>(context, listen: false)
                            .changeReminderTime(selectedTimeString);
                        PreferenceHelper.setReminderTimePreferenceValue(
                            hour, min);
                        Reminder.cancelReminder(); // cancel the reminder
                        Reminder.showRestartAppAlert(context);
                      }
                    }
                  : null,
              title: 'Reminder time',
              description: value.reminderTimePrefValue,
              trailingWidget: const Icon(Icons.access_alarm),
            );
          }),
          SettingTile(
            isDisable: false,
            onTap: () {},
            title: 'backup & restore',
            description: 'Back up your birthdays in the cloud',
          ),
          divider(),
          settingSectionTile('Theme'),
          Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return SettingTile(
                  title: 'Theme',
                  description: value.themeBool ? 'Dark' : 'Light',
                  trailingWidget: Switch(
                    onChanged: (value) async {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(value);
                      PreferenceHelper.setThemeValue(value);
                    },
                    value: value.themeBool,
                  ));
            },
          ),
          divider(),
          settingSectionTile('info'),
          SettingTile(
            onTap: _sendEmail,
            title: 'Contact us',
            description: 'Report issues',
          ),
          SettingTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const DevInfoPage()));
            },
            title: 'About us',
            description: 'Developer information',
          ),
          divider(),
          settingSectionTile('Version'),
          const SettingTile(
            title: 'Birthday Alert',
            description: 'Current version:Birthday Alert 1.0.0',
          ),
        ],
      ),
    );
  }

  Divider divider() {
    return const Divider(
      thickness: 1.5,
      height: 20,
    );
  }

  Container settingSectionTile(String title) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.only(left: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  const SettingTile(
      {super.key,
      this.isDisable = true,
      required this.title,
      required this.description,
      this.trailingWidget,
      this.onTap});
  final String title;
  final String description;
  final Widget? trailingWidget;
  final Function()? onTap;
  final bool isDisable;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        shape:const Border(),
        enabled: isDisable,
        // tileColor: Colors.transparent,
        enableFeedback: true,
        title: Text(title),
        subtitle: Text(description),
        trailing: trailingWidget,
      ),
    );
  }
}

Future<TimeOfDay?> showTimePickerDialog(BuildContext context) {
  return showTimePicker(
    initialTime: const TimeOfDay(hour: 22, minute: 0),
    context: context,
  );
}
