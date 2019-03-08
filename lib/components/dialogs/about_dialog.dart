import 'package:flutter/material.dart';

// TODO ABOUT DIALOG
// My website
// My github
// A short description

class AboutAppDialog {
  final BuildContext context;

  AboutAppDialog(this.context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //My site, my github, short description,
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'DISMISS',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
