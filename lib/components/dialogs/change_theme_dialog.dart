import 'package:flutter/material.dart';
import 'package:utopian_rocks_2/bloc_providers/base_provider.dart';
import 'package:utopian_rocks_2/blocs/settings_bloc.dart';
import 'package:utopian_rocks_2/blocs/theme_bloc.dart';
import 'package:utopian_rocks_2/models/settings_model.dart';
import 'package:utopian_rocks_2/providers/settings_provider.dart';

class ChangeThemeDialog {
  final BuildContext context;

  ChangeThemeDialog(this.context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Customise',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: _ChangeTheme(),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'DISMISS',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class _ChangeTheme extends StatefulWidget {
  __ChangeThemeState createState() => __ChangeThemeState();
}

class __ChangeThemeState extends State<_ChangeTheme> {
  @override
  Widget build(BuildContext context) {
    final themeBloc = Provider.of<ThemeBloc>(context);
    final settingsBloc = Provider.of<SettingsBloc>(context);
    return StreamBuilder(
      stream: themeBloc.getTheme,
      builder: (BuildContext context, AsyncSnapshot<Themes> themeSnapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: DropdownButton(
                value: themeSnapshot.data,
                items: [
                  DropdownMenuItem(
                    value: Themes.light,
                    child: Text('Light Theme'),
                  ),
                  DropdownMenuItem(
                    value: Themes.dark,
                    child: Text('Dark Theme'),
                  ),
                  DropdownMenuItem(
                    value: Themes.amoled,
                    child: Text('Dark Theme(AMOLED)'),
                  ),
                  DropdownMenuItem(
                    value: Themes.utopian,
                    child: Text('Utopian Theme'),
                  ),
                ],
                onChanged: themeBloc.setTheme.add,
              ),
            ),
            StreamBuilder(
              stream: settingsBloc.getSettings,
              builder: (context, AsyncSnapshot<SettingsModel> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      CheckboxListTile(
                        value: snapshot.data.showAvatar,
                        onChanged: (selected) {
                          settingsBloc.setValue(Settings.SHOW_AVATAR, selected);
                        },
                        title: Text('Show Avatar'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: snapshot.data.showCategory,
                        onChanged: (selected) {
                          settingsBloc.setValue(
                              Settings.SHOW_CATEGORY, selected);
                        },
                        title: Text('Show Category Icon'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: snapshot.data.showCard,
                        onChanged: (selected) {
                          settingsBloc.setValue(Settings.SHOW_CARD, selected);
                        },
                        title: Text('Display As Cards'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: snapshot.data.showStats,
                        onChanged: (selected) {
                          settingsBloc.setValue(Settings.SHOW_STATS, selected);
                        },
                        title: Text('Show Extra Stats'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
