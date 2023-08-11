// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/birthday_model.dart';

class DatabaseProvider extends ChangeNotifier {
  void addBirthday(String name, DateTime birthdate, bool isStar) async {
    final birthdayBox = await Hive.openBox('birthdayBox');

    final bod = Birthday()
      ..name = name
      ..birthday = birthdate
      ..isStared = isStar;

    birthdayBox.add(bod);
    notifyListeners();
  }

  Future<List<Birthday>> getBirthdays() async {
    final birthdayBox = await Hive.openBox('birthdayBox');
    final allBirthdays = birthdayBox.values.cast<Birthday>().toList();
    return Future.value(allBirthdays);
  }
  List<Birthday> getAlreadyOpenedBox(){
    final box = Hive.box('birthdayBox');
    final list = box.values.toList();
    return list.cast();
  }

  Future<void> deleteBirthday(indexOfBirthday) async {
    final birthdayBox = await Hive.openBox('birthdayBox');
    await birthdayBox.deleteAt(indexOfBirthday);
    notifyListeners();
  }

  Future<void> editBirthday(indexOfBirthday, String? name, DateTime? birthdate,
      bool starFriend) async {
    if (name != null && birthdate != null) {
      final birthdayBox = await Hive.openBox('birthdayBox');
      final record = birthdayBox.getAt(indexOfBirthday);
      record.name = name;
      record.birthday = birthdate;
      record.isStared = starFriend;
      await birthdayBox.putAt(indexOfBirthday, record);
      notifyListeners();
    }
  }

  List<Birthday> getTodayBirthdays(List<Birthday> items) {
    DateTime currentDate = DateTime.now();
    currentDate = currentDate.subtract(const Duration(days: 1));
    DateTime nextDay = currentDate.add(const Duration(days: 1));

    return items
        .where((item) =>
            item.birthday.isAfter(currentDate) &&
            item.birthday.isBefore(nextDay))
        .toList()
      ..sort((a, b) => a.birthday.compareTo(b.birthday));
  }

  List<Birthday> getUpcomingBirthdays(List<Birthday> items) {
    DateTime currentDate = DateTime.now();
    DateTime nextWeek = currentDate.add(const Duration(days: 30));

    return items
        .where((item) =>
            item.birthday.isAfter(currentDate) &&
            item.birthday.isBefore(nextWeek))
        .toList()
      ..sort((a, b) => a.birthday.compareTo(b.birthday));
  }

  List<Birthday> searchRecord(List<Birthday> items, String name) {
    return items
        .where((element) => element.name.toLowerCase() == name.toLowerCase())
        .toList();
  }

  Future<void> editBirthdayByName(String? previousName, String? newName,
      DateTime? newBirthdate, bool newStarFriend) async {
    if (newName != null && newBirthdate != null) {
      final birthdayBox = await Hive.openBox('birthdayBox');
      final birthdayList = birthdayBox.toMap();
      Birthday? record = birthdayList.values.cast<Birthday>().firstWhere(
            (record) =>
                record.name.toLowerCase() == previousName!.toLowerCase(),
            orElse: () => Birthday(),
          );
      if (record.name != null) {
        int indexRecord = birthdayBox.values.toList().indexOf(record);
        record.name = newName;
        record.birthday = newBirthdate;
        record.isStared = newStarFriend;
        await birthdayBox.putAt(indexRecord, record);
        notifyListeners();
      }
    }
  }
 static Future<bool> isNameExist(String? inputName) async{
    final birthdayBox = await Hive.openBox('birthdayBox');
    final birthdayList = birthdayBox.values.toList();
   List<dynamic> getNameList = birthdayList
        .where((element) => element.name.toLowerCase() == inputName!.toLowerCase())
        .toList();
    if (getNameList.isNotEmpty) {
      return false;
    }
    else{
      return true;
    }
  }
  Future<void>deleteBirthdayByName(String? previousName) async {
    if (previousName != null) {
      final birthdayBox = await Hive.openBox('birthdayBox');
      final birthdayList = birthdayBox.toMap();
      Birthday? record = birthdayList.values.cast<Birthday>().firstWhere(
            (record) =>
                record.name.toLowerCase() == previousName.toLowerCase(),
            orElse: () => Birthday(),
          );
      if (record.name != null) {
        int indexRecord = birthdayBox.values.toList().indexOf(record);
        await birthdayBox.deleteAt(indexRecord);
        notifyListeners();
      }
    }
  }


}
