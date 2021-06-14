import 'package:flutter/material.dart';
import 'package:my_daily_diary/widgets/lock_view.dart';

class PopUpMenu extends StatelessWidget {
  final String dialogContent;
  final String snackBarContent;
  final Function removeItem;
  final String? itemId;
  final String? password;

  PopUpMenu({
    required this.dialogContent,
    required this.snackBarContent,
    required this.removeItem,
    this.itemId,
    this.password,
  });
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.lock),
              title: Text('Lock'),
              onTap: password!.isEmpty
                  ? () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return LockView(btnName: 'Lock');
                        },
                      );
                    }
                  : null,
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(dialogContent),
                      actions: [
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () {
                            removeItem();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    snackBarContent,
                                    style: Theme.of(context)
                                        .snackBarTheme
                                        .contentTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  shape: StadiumBorder(),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ];
      },
    );
  }
}
