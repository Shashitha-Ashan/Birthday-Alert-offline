import 'package:birthday_alert/helpers/preference.dart';
import 'package:birthday_alert/pages/all_birthdays.dart';
import 'package:birthday_alert/pages/settings.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'post_create_page.dart';

import '../helpers/database_helper.dart';
import '../model/birthday_model.dart';
import '../utils/colors.dart';
import '../widgets/bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    checkBatteryOptimization();
    super.initState();
  }

  void checkBatteryOptimization() async {
    bool reminderPrefValue =
        await PreferenceHelper.getReminderPreferenceValue();
    if (reminderPrefValue) {
      bool? isAllBatteryOptimizationDisabled =
          await DisableBatteryOptimization.isAllBatteryOptimizationDisabled;
      if (isAllBatteryOptimizationDisabled != null) {
        if (!isAllBatteryOptimizationDisabled) {
          await DisableBatteryOptimization.showDisableAllOptimizationsSettings(
              "Enable Auto Start",
              "Follow the steps and enable the auto start of this app",
              "Your device has additional battery optimization",
              "Follow the steps and disable the optimizations to allow reminder of this app");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Birthday Alert',
            style: TextStyle(
              wordSpacing: 5,
              letterSpacing: 1.5,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PostCreatePage()));
              },
              icon: const Icon(
                Icons.post_add,
                color: iconColor,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllBirthdayList()));
              },
              icon: const Icon(
                Icons.format_list_bulleted_rounded,
                color: iconColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
              icon: const Icon(
                Icons.settings,
                color: iconColor,
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Today',
                icon: Icon(
                  Icons.today,
                  color: iconColor,
                ),
              ),
              Tab(
                text: 'Upcoming',
                icon: Icon(
                  Icons.calendar_month,
                  color: iconColor,
                ),
              )
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(children: [
          //Today Tab
          BirthdayListView(
            isTodayList: true,
          ),
          // Upcoming Tab
          BirthdayListView(
            isTodayList: false,
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BottomSheetController(context: context, isAddNew: true)
                .showBottomUpSheet();
          },
          child: const Icon(Icons.edit_calendar),
        ),
      ),
    );
  }
}

class PostCreate {}

class BirthdayListView extends StatelessWidget {
  BirthdayListView({
    super.key,
    required this.isTodayList,
  });
  final bool isTodayList;

  final DatabaseProvider databaseProvider = DatabaseProvider();
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, value, child) {
        return FutureBuilder<List<Birthday>>(
          future: value.getBirthdays(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              // Get today or next upcoming week birthdays
              List<Birthday> friends = isTodayList
                  ? value.getTodayBirthdays(snapshot.data!)
                  : value.getUpcomingBirthdays(snapshot.data!);
              if (friends.isNotEmpty) {
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  padding: const EdgeInsets.only(top: 8, left: 3, right: 3),
                  physics: const BouncingScrollPhysics(),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      // List tile widget
                      child: ListTile(
                        onTap: () {
                          showSeperatedBirthdayAlert(context, friend.name,
                              friend.birthday, friend.isStared);
                        },
                        minVerticalPadding: 15,
                        enableFeedback: true,
                        trailing: friend.isStared
                            ? const Icon(
                                Icons.favorite_rounded,
                                color: Color.fromARGB(255, 253, 0, 84),
                              )
                            : const Icon(null),
                        title: Text(
                          friend.name[0].toUpperCase() +
                              friend.name.substring(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            fontFamily: AutofillHints.birthday,
                          ),
                        ),
                        leading: Text('${index + 1}'),
                        subtitle: Text(
                          DateFormat('MMMM d').format(friend.birthday),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: isTodayList
                      ? const Text('Today no celebrations')
                      : const Text('No upcoming Birthdays'),
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        );
      },
    );
  }
}

void showSeperatedBirthdayAlert(BuildContext context, String name,
    DateTime birthdate, bool isStaredFriend) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                name[0].toUpperCase() + name.substring(1),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isStaredFriend
                      ? const Color.fromARGB(218, 255, 53, 120)
                      : null,
                ),
              ),
              Column(
                children: [
                  const Text(
                    'Time left',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  // const Text("-"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    remainDateStatus(birthdate),
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          SnackBarAction(label: 'OK', onPressed: () => Navigator.pop(context))
        ],
      );
    },
  );
}

String remainDateStatus(DateTime birthdate) {
  DateTime today = DateTime.now();
  Duration dif = birthdate.difference(today);

  if (dif.inDays > 0) {
    return '${dif.inDays} Days';
  } else if (dif.inHours > 0) {
    return '${dif.inHours} Hours';
  } else if (dif.inMinutes > 0) {
    return '${dif.inMinutes} Min';
  } else {
    return 'Today';
  }
}
