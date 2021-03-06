import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../helper/box.dart';
import '../models/diary.dart';

class DiaryData with ChangeNotifier {
  final diaryBox = Boxes.getDiariesBox();
  final chapterBox = Boxes.getChaptersBox();
  List<Diary> _items = [];
  late Diary _currentDiary;

  List<Diary> get items => [..._items];

  void getItemsFormDB() async {
    if (diaryBox.values.isNotEmpty) {
      _items = diaryBox.values.toList();
    }
  }

  void addDiary({
    required String name,
    required Color color,
    File? image,
    required String password,
  }) {
    final _newDiary = Diary(
      id: DateTime.now().toString(),
      name: name,
      customColor: color,
      image: image,
      chapters: HiveList(chapterBox),
      password: password,
    );
    _items.add(_newDiary);
    notifyListeners();
    diaryBox.add(_newDiary);
    // print(box.getAt(0)!.name);
  }

  void removeDiary(Diary diary) {
    // _items.removeWhere((diary) => diary.id == id);
    _items.remove(diary);
    notifyListeners();
    diary.delete();
    // box.delete(diary.key);
  }

  void currentDiary(String id) {
    _currentDiary = _items.firstWhere((diary) => diary.id == id);
    notifyListeners();
  }

  void unLockDiary(bool status) {
    _currentDiary.passwordState = status;
    notifyListeners();
  }

  void lockDiary(String lockCode) {
    _currentDiary.password = lockCode;
    notifyListeners();
    _currentDiary.save();
  }
}
