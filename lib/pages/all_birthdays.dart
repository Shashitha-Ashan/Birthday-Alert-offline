import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../helpers/database_helper.dart';
import '../model/birthday_model.dart';
import 'birthday_search.dart';

class AllBirthdayList extends StatefulWidget {
  AllBirthdayList({super.key});

  @override
  State<AllBirthdayList> createState() => _AllBirthdayListState();
}

class _AllBirthdayListState extends State<AllBirthdayList> {
  final DatabaseProvider databaseProvider = DatabaseProvider();

  late String? searchItemName;

  bool isSearchButtonpressed = false;
  @override
  void initState() {
    searchItemName = null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthdays'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate:
                      SearchPage(DatabaseProvider().getAlreadyOpenedBox()));
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Consumer<DatabaseProvider>(
              builder: (context, value, child) {
                return Expanded(
                  child: FutureBuilder<List<Birthday>>(
                    future: value.getBirthdays(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        final friends = snapshot.data!;
                        return ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 5,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            final friend = friends[index];
                            return Container(
                              margin: const EdgeInsets.only(left: 3, right: 3),
                              child: Material(
                                elevation: 5,
                                child: ListTile(
                                  trailing: friend.isStared
                                      ? const Icon(Icons.favorite_rounded,
                                          color:
                                              Color.fromARGB(255, 253, 0, 84))
                                      : const Icon(null),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  enableFeedback: true,
                                  title: Text(friend.name[0].toUpperCase() +
                                      friend.name.substring(1)),
                                  leading: Text('${index + 1}'),
                                  subtitle: Text(DateFormat('MMMM d')
                                      .format(friend.birthday)),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

void showDeleteDialog(BuildContext context, int index, value,
    bool isSearchedItem, String? searchName) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to delete this record'),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (isSearchedItem && searchName != null) {
                    await value.deleteBirthdayByName(searchName);
                  } else {
                    await value.deleteBirthday(index);
                  }
                },
                child: const Text('OK')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'))
          ],
        );
      });
}
