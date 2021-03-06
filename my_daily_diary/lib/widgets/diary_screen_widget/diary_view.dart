import 'package:flutter/material.dart';
import 'package:my_daily_diary/widgets/lock_view.dart';
import 'package:provider/provider.dart';

import 'package:my_daily_diary/models/diary.dart';
import 'package:my_daily_diary/providers/diary_data.dart';
import 'package:my_daily_diary/providers/chapter_data.dart';
import 'package:my_daily_diary/widgets/popup_menu.dart';

class DiaryView extends StatelessWidget {
  final Diary diaryData;
  final AnimationController animationController;
  final Animation animation;

  const DiaryView({
    required this.diaryData,
    required this.animationController,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final _password = diaryData.password;
    final _providerChapterData =
        Provider.of<ChapterData>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: animation as Animation<double>,
            child: Transform(
              transform:
                  Matrix4.translationValues(25 * (1.0 * animation.value), 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Material(
                          child: InkWell(
                            onTap: () {
                              if (_password.isNotEmpty &&
                                  !diaryData.passwordState) {
                                showDialog(
                                  context: context,
                                  builder: (context) => LockView(
                                    btnName: 'Unlock',
                                    lockCode: _password,
                                    unLockItem: () {
                                      Provider.of<DiaryData>(context,
                                          listen: false)
                                        ..currentDiary(diaryData.id)
                                        ..unLockDiary(true);
                                    },
                                  ),
                                );
                              } else if (_password.isNotEmpty &&
                                  diaryData.passwordState) {
                                _providerChapterData
                                  ..setClick(true)
                                  ..setChapters(
                                    diaryData,
                                  );
                              } else {
                                _providerChapterData
                                  ..setClick(true)
                                  ..setChapters(
                                    diaryData,
                                  );
                              }
                            },
                            child: Container(
                              width: 130,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: diaryData.customColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                  topLeft: Radius.circular(3),
                                  bottomLeft: Radius.circular(3),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    diaryData.customColor.withAlpha(255),
                                    diaryData.customColor.withAlpha(50),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .shadowColor
                                        .withOpacity(0.4),
                                    offset: const Offset(2.0, 2.0),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: diaryData.image == null
                                  ? _password.isNotEmpty &&
                                          !diaryData.passwordState
                                      ? Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            SizedBox(),
                                            Icon(
                                              Icons.lock,
                                              size: 40,
                                            ),
                                          ],
                                        )
                                      : _password.isNotEmpty &&
                                              diaryData.passwordState
                                          ? Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                SizedBox(),
                                                Positioned(
                                                  left: 10,
                                                  bottom: 10,
                                                  child: Icon(
                                                    Icons.lock_open,
                                                    size: 25,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox()
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3),
                                      ),
                                      child: _password.isNotEmpty &&
                                              !diaryData.passwordState
                                          ? Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Container(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  child: Opacity(
                                                    opacity: 0.3,
                                                    child: Image.file(
                                                      diaryData.image!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.lock,
                                                  size: 40,
                                                ),
                                              ],
                                            )
                                          : _password.isNotEmpty &&
                                                  diaryData.passwordState
                                              ? Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Image.file(
                                                      diaryData.image!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                      left: 10,
                                                      bottom: 10,
                                                      child: Icon(
                                                        Icons.lock_open,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Image.file(
                                                  diaryData.image!,
                                                  fit: BoxFit.cover,
                                                ),
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          top: 1,
                          child: PopUpMenu(
                            dialogContent:
                                'Are you sure that you want to delete this diary ?',
                            snackBarContent: 'This diary has been deleted',
                            removeItem: () {
                              Provider.of<DiaryData>(context, listen: false)
                                  .removeDiary(diaryData);
                              Provider.of<ChapterData>(context, listen: false)
                                  .setClick(false);
                            },
                            itemPassword: _password,
                            lockItem: (String? lockcode) {
                              Provider.of<DiaryData>(context, listen: false)
                                ..currentDiary(diaryData.id)
                                ..lockDiary(lockcode!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    diaryData.name,
                    style: Theme.of(context)
                        .textTheme
                        .merge(TextTheme(caption: TextStyle(fontSize: 14)))
                        .caption,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
