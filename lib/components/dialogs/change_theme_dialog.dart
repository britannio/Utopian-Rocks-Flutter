import 'package:flutter/material.dart';
import 'package:utopian_rocks_2/bloc_providers/base_provider.dart';
import 'package:utopian_rocks_2/blocs/theme_bloc.dart';

class ChangeThemeDialog {
  final BuildContext context;

  ChangeThemeDialog(this.context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Theme',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            content: _ChangeTheme(),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'DISMISS',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class _ChangeTheme extends StatefulWidget {
  __ChangeThemeState createState() => __ChangeThemeState();
}

class __ChangeThemeState extends State<_ChangeTheme> {
  //Themes currentTheme = Themes.dark;
  @override
  Widget build(BuildContext context) {
    final themeBloc = Provider.of<ThemeBloc>(context);
    return StreamBuilder(
      stream: themeBloc.getTheme,
      builder: (BuildContext context, AsyncSnapshot<Themes> themeSnapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadioListTile(
              groupValue: themeSnapshot.data,
              value: Themes.dark,
              onChanged: (Themes value) {
                themeBloc.setTheme.add(value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
              title: Text('Dark Theme'),
            ),
            RadioListTile(
              groupValue: themeSnapshot.data,
              value: Themes.amoled,
              onChanged: (Themes value) {
                themeBloc.setTheme.add(value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
              title: Text('Dark Theme(AMOLED)'),
            ),
            RadioListTile(
              groupValue: themeSnapshot.data,
              value: Themes.light,
              onChanged: (Themes value) {
                themeBloc.setTheme.add(value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
              title: Text('Light Theme'),
            ),
            RadioListTile(
              groupValue: themeSnapshot.data,
              value: Themes.utopian,
              onChanged: (Themes value) {
                themeBloc.setTheme.add(value);
              },
              activeColor: Theme.of(context).colorScheme.primary,
              title: Text('Utopian Theme'),
            ),
          ],
        );
      },
    );
  }
}
