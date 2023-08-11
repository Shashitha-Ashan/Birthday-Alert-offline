import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helpers/database_helper.dart';
import '../model/birthday_model.dart';
import '../utils/colors.dart';
import '../widgets/bottom_sheet.dart';

class SearchPage extends SearchDelegate {
  final List<Birthday> list;

  SearchPage(this.list);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Birthday> buildResults = [];
    for (var element in list) {
      if (element.name.toLowerCase().contains(query.toLowerCase())) {
        buildResults.add(element);
      }
    }
    if (buildResults.isNotEmpty) {
      return listBuilderWidget(buildResults);
    } else {
      return const Center(
        child: Text('No birthdays to display'),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Birthday> buildSuggestions = [];
    for (var element in list) {
      if (element.name.toLowerCase().contains(query.toLowerCase())) {
        buildSuggestions.add(element);
      }
    }
    if (buildSuggestions.isNotEmpty) {
      return listBuilderWidget(buildSuggestions);
    }else{
      return const Center(
        child: Text("We couldn\'t find any matches."),
      );
    }
    
  }

  ListView listBuilderWidget(List<Birthday> friends) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        height: 5,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Consumer<DatabaseProvider>(
          builder: (context, value, child) {
            return Container(
              margin: const EdgeInsets.only(left: 3, right: 3),
              child: Material(
                elevation: 5,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  enableFeedback: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // birthday Edit onPressed
                      IconButton(
                          onPressed: () async {
                            BottomSheetController(
                                    isSearchedItem: true,
                                    context: context,
                                    isAddNew: false,
                                    previousDate: friend.birthday,
                                    previousName: friend.name,
                                    previousStar: friend.isStared)
                                .showBottomUpSheet();
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: secondaryIconColor,
                          )),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        // birthday Delete onPressed
                        onPressed: () async {
                          showDeleteDialog(context, value, friend.name);
                        },
                      ),
                    ],
                  ),
                  title: Text(
                      friend.name[0].toUpperCase() + friend.name.substring(1)),
                  leading: Text('${index + 1}'),
                  subtitle: Text(DateFormat('MMMM d').format(friend.birthday)),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context, value, String? searchName) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Do you want to delete this record'),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (searchName != null) {
                      await value.deleteBirthdayByName(searchName);
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
}
