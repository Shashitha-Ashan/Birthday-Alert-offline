// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helpers/database_helper.dart';
import '../utils/colors.dart';
import '../utils/text_style.dart';

class BottomSheetController {
  BottomSheetController(
      {required this.isAddNew,
      this.previousDate,
      this.previousName,
      this.previousStar = false,
      this.recodIndex,
      this.isSearchedItem = false,
      required this.context});
  final bool isAddNew;
  final DateTime? previousDate;
  final String? previousName;
  final bool previousStar;
  final BuildContext context;
  final recodIndex;
  final bool isSearchedItem;

  void showBottomUpSheet() {
    if (isAddNew) {
      showModalBottomSheet(
          isScrollControlled: true,
          elevation: 10,
          showDragHandle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
          context: context,
          builder: (BuildContext context) {
            return BotttomSheet(
              isAddNew: isAddNew,
            );
          });
    } else {
      showModalBottomSheet(
          isScrollControlled: true,
          elevation: 10,
          showDragHandle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
          context: context,
          builder: (BuildContext context) {
            return BotttomSheet(
              isAddNew: isAddNew,
              previousDate: previousDate,
              previousName: previousName,
              previousStar: previousStar,
              recordIndex: recodIndex,
              isSearchedItem: isSearchedItem,
            );
          });
    }
  }

  DateTime selectedDate = DateTime.now();

  Future<void> datePicker(BuildContext context) async {
    // ignore: unused_local_variable
    final DateTime? pickedDate = await showDatePicker(
        helpText: 'Select birthdate',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
  }
}

class BotttomSheet extends StatefulWidget {
  const BotttomSheet(
      {super.key,
      required this.isAddNew,
      this.previousDate,
      this.previousName,
      this.recordIndex,
      this.previousStar = false,
      this.isSearchedItem = false});
  final bool isAddNew;
  final String? previousName;
  final DateTime? previousDate;
  final bool previousStar;
  final recordIndex;
  final bool isSearchedItem;

  @override
  State<BotttomSheet> createState() => _BotttomSheetState();
}

class _BotttomSheetState extends State<BotttomSheet> {
  @override
  void initState() {
    starFriend = widget.previousStar;
    if (widget.previousName != null) {
      _textEditingControllerName.text = widget.previousName!;
      name = widget.previousName!;
    }
    if (widget.previousDate != null) {
      _textEditingControllerDate.text =
          DateFormat('MMMM d').format(widget.previousDate!);
      selectedDate = widget.previousDate!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _textEditingControllerDate.dispose();
    _textEditingControllerName.dispose();
    super.dispose();
  }

  final TextEditingController _textEditingControllerDate =
      TextEditingController();
  final TextEditingController _textEditingControllerName =
      TextEditingController();
  bool starFriend = false;
  DateTime selectedDate = DateTime.now();
  late String name;
  final DatabaseProvider databaseProvider = DatabaseProvider();
// date picker
  Future<void> _datePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      helpText: 'Select birthdate',
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        selectedDate = pickedDate;
        _textEditingControllerDate.text =
            DateFormat('MMMM d').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isAddNew ? 'Add new Birthday' : 'Edit Birthday',
                style: kBottomSheetTitleStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: _textEditingControllerName,
                      onSubmitted: (value) {
                        // ignore: unnecessary_null_comparison
                        if (value != null) {
                          name = value;
                        }
                      },
                      onChanged: (value) {
                        name = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter name',
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: addBirthdayPageBackColor)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _textEditingControllerDate,
                      decoration: const InputDecoration(
                        hintText: 'Enter birthdate',
                        filled: true,
                        suffixIcon: Icon(Icons.calendar_month),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () {
                        _datePicker(context);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Make as a hearted friend',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        Switch(
                            value: starFriend,
                            onChanged: (value) {
                              setState(() {
                                starFriend = value;
                              });
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        //print(widget.isSearchedItem);
                        if (_textEditingControllerName.text.isNotEmpty &&
                            _textEditingControllerDate.text.isNotEmpty) {
                          bool isRecordExist =
                              await DatabaseProvider.isNameExist(name);
                            if (widget.isAddNew) {
                          if (isRecordExist) {
                              Provider.of<DatabaseProvider>(context,
                                      listen: false)
                                  .addBirthday(name, selectedDate, starFriend);
                              triggerSnackBar(
                                context,
                                'Succesfully added',
                                const Color.fromARGB(255, 1, 245, 34),
                              );
                              Navigator.pop(context);
                          }else {
                            triggerSnackBar(
                              context,
                              'Record already Exist please change name',
                              Colors.redAccent,
                            );
                          }
                            }
                            if (widget.isAddNew == false) {
                              widget.isSearchedItem
                                  ? Provider.of<DatabaseProvider>(context,
                                          listen: false)
                                      .editBirthdayByName(widget.previousName,
                                          name, selectedDate, starFriend)
                                  : Provider.of<DatabaseProvider>(context,
                                          listen: false)
                                      .editBirthday(widget.recordIndex, name,
                                          selectedDate, starFriend);
                              triggerSnackBar(
                                context,
                                'Succesfully edited',
                                const Color.fromARGB(255, 1, 245, 34),
                              );
                              Navigator.pop(context);
                            }
                            starFriend = false;
                            _textEditingControllerName.clear();
                            _textEditingControllerDate.clear();
                          
                        } else {
                          triggerSnackBar(
                            context,
                            'Both Name and birthdate fields are required',
                            Colors.red,
                          );
                        }
                      },
                      child: Text(widget.isAddNew ? 'Add' : 'OK'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

void triggerSnackBar(BuildContext context, String title, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      elevation: 10,
      content: Text(
        title,
        textAlign: TextAlign.center,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
    ),
  );
}
