import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_daily_diary/widgets/lock_view.dart';
import '../providers/chapter_data.dart';

import 'package:my_daily_diary/providers/diary_data.dart';
import 'package:my_daily_diary/providers/page_data.dart';
import 'package:my_daily_diary/widgets/cover_picker.dart';
import 'package:provider/provider.dart';

enum AddAction { diary, chapter, page }

// ignore: must_be_immutable
class DialogView extends StatelessWidget {
  final String name;
  final String hint;
  final String coverName;
  final String lockName;
  final AddAction action;
  DialogView({
    required this.name,
    required this.hint,
    required this.coverName,
    required this.action,
    required this.lockName,
  });

  final _form = GlobalKey<FormState>();
  String _name = '';
  Color _coverColor = Colors.cyan;
  // ignore: avoid_init_to_null
  File? _coverImage = null;
  String _password = '';

  void _saveForm(BuildContext context) {
    switch (action) {
      case AddAction.diary:
        _form.currentState!.save();
        Provider.of<DiaryData>(context, listen: false).addDiary(
          name: _name,
          color: _coverColor,
          image: _coverImage,
          password: _password,
        );
        Navigator.pop(context);
        break;
      case AddAction.chapter:
        _form.currentState!.save();
        Provider.of<ChapterData>(context, listen: false).addChapter(
          name: _name,
          color: _coverColor,
          image: _coverImage,
          password: _password,
        );
        Navigator.pop(context);
        break;
      case AddAction.page:
        _form.currentState!.save();
        Provider.of<PageData>(context, listen: false).addPage(
          name: _name,
          color: _coverColor,
          image: _coverImage,
          password: _password,
        );
        Navigator.pop(context);
        break;
      default:
    }
  }

  void _getCover(Color? pickcolor, File? image) {
    switch (action) {
      case AddAction.diary:
        if (pickcolor != null && image == null) {
          _coverColor = pickcolor;
        } else if (pickcolor == null && image != null) {
          _coverImage = image;
        }
        break;

      case AddAction.chapter:
        if (pickcolor != null && image == null) {
          _coverColor = pickcolor;
        } else if (pickcolor == null && image != null) {
          _coverImage = image;
        }
        break;

      case AddAction.page:
        if (pickcolor != null && image == null) {
          _coverColor = pickcolor;
        } else if (pickcolor == null && image != null) {
          _coverImage = image;
        }
        break;
      default:
    }
  }

  void _getPassword(String? password) {
    if (password != null) {
      _password = password;
    }
  }

  void _close(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height / 2 + 20,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                _buildTitle(context, name),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: hint,
                    ),
                    onSaved: (newValue) {
                      switch (action) {
                        case AddAction.diary:
                          _name = newValue!;
                          break;
                        case AddAction.chapter:
                          _name = newValue!;
                          break;
                        case AddAction.page:
                          _name = newValue!;
                          break;
                        default:
                      }
                    },
                  ),
                ),
                _buildTitle(context, coverName),
                CoverPicker(_getCover),
                _buildTitle(context, lockName),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        shape: StadiumBorder(),
                        primary: Theme.of(context).primaryIconTheme.color,
                      ),
                      icon: Icon(Icons.pin),
                      label: Text('Enter PIN code'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => LockView(
                            btnName: 'Save',
                            password: _getPassword,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text('Cancel'),
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () {
                        _close(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text('Save'),
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () {
                        _saveForm(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _buildTitle(BuildContext context, String? name) {
    return Text.rich(
      TextSpan(
        text: name,
        style: Theme.of(context)
            .textTheme
            .merge(
              TextTheme(
                headline6: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
            .headline6,
        // children: [
        //   TextSpan(
        //     text: ' *',
        //     style: TextStyle(color: Colors.red),
        //   ),
        // ],
      ),
    );
  }
}
