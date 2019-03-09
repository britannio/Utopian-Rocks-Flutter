import 'package:flutter/material.dart';
import 'package:utopian_rocks_2/blocs/settings_bloc.dart';
import 'package:utopian_rocks_2/blocs/theme_bloc.dart';
import 'package:utopian_rocks_2/providers/rocks_api.dart';
import 'package:utopian_rocks_2/bloc_providers/base_provider.dart';
import 'package:utopian_rocks_2/blocs/contribution_bloc.dart';
import 'package:utopian_rocks_2/providers/theme_provider.dart';
import 'package:utopian_rocks_2/views/home_page.dart';

void main() => runApp(
      BlocProvider<ThemeBloc>(
        builder: (_, bloc) => bloc ?? ThemeBloc(ThemeProvider()),
        onDispose: (_, bloc) => bloc.dispose(),
        child: BlocProvider<SettingsBloc>(
          builder: (_, bloc) => bloc ?? SettingsBloc(),
          onDispose: (_, bloc) => bloc.dispose(),
          child: MyApp(),
        ),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeBloc = Provider.of<ThemeBloc>(context);
    final ThemeData _utopianTheme = ThemeData(
      colorScheme: ColorScheme.light().copyWith(
        primary: Color(0xFF26A69A),
        primaryVariant: Color(0xFF24292f),
        secondary: Color(0xFF24292f), //Color(0xFF26A69A),
        secondaryVariant: Color(0xFF000005),
        onSecondary: Colors.white,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        background: Color(0xFFf6f8fa),
        onBackground: Colors.black,
      ),
      fontFamily: 'Quantico',
      dividerColor: Color(0xFF272729),
      cardColor: Colors.white,
      brightness: Brightness.light,
      accentColor: Color(0xFF26A69A),
      dialogBackgroundColor: Colors.white,
    );

    final ThemeData _darkTheme = ThemeData(
      colorScheme: ColorScheme.dark().copyWith(
        primary: Color(0xFF26A69A), //Color(0xFF121213),
        primaryVariant: Color(0xFF050505), //Color(0xFF00766C),
        onPrimary: Colors.white,
        secondary: Color(0xFF121213),
        secondaryVariant: Color(0xFF050505),
        onSecondary: Colors.white,
        surface: Color(0xFF121213),
        onSurface: Colors.white,
        background: Color(0xFF050505),
        onBackground: Colors.white,
      ),
      fontFamily: 'Quantico',
      dividerColor: Color(0xFF272729),
      cardColor: Color(0xFF121213),
      brightness: Brightness.dark,
      accentColor: Color(0xFF26A69A),
      dialogBackgroundColor: Color(0xFF121213),
    );

    final ThemeData _lightTheme = ThemeData(
      colorScheme: ColorScheme(
          primary: Color(0xFF26A69A),
          primaryVariant: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.white, //Color(0xFF26A69A),
          secondaryVariant: Color(0xFFf6f8fa),
          onSecondary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          background: Colors.white, //Color(0xFFf6f8fa),
          onBackground: Colors.black,
          brightness: Brightness.light,
          error: Colors.red,
          onError: Colors.white),
      fontFamily: 'Quantico',
      dividerColor: Color(0xFF272729),
      cardColor: Colors.white,
      brightness: Brightness.light,
      accentColor: Color(0xFF26A69A),
      dialogBackgroundColor: Colors.white,
      buttonColor: Color(0xFFF8F8F8)
    );

    final ThemeData _blackTheme = ThemeData(
      colorScheme: ColorScheme.dark().copyWith(
        primary: Color(0xFF26A69A), //Color(0xFF121213),
        primaryVariant: Color(0xFF050505), //Color(0xFF00766C),
        onPrimary: Colors.white,
        secondary: Colors.black, //Color(0xFF121213),
        secondaryVariant: Color(0xFF121213),
        onSecondary: Colors.white,
        surface: Colors.black,
        onSurface: Colors.white,
        background: Colors.black,
        onBackground: Colors.white,
      ),
      fontFamily: 'Quantico',
      dividerColor: Color(0xFF272729),
      cardColor: Color(0xFF121213),
      brightness: Brightness.dark,
      accentColor: Color(0xFF26A69A),
      dialogBackgroundColor: Color(0xFF121213),
    );
    return StreamBuilder(
      stream: themeBloc.getTheme,
      builder: (BuildContext context, AsyncSnapshot<Themes> themeSnapshot) {
        ThemeData theme;
        switch (themeSnapshot.data) {
          case Themes.light:
            theme = _lightTheme;
            break;
          case Themes.utopian:
            theme = _utopianTheme;
            break;
          case Themes.dark:
            theme = _darkTheme;
            break;
          case Themes.amoled:
            theme = _blackTheme;
            break;
        }
        return MaterialApp(
          title: 'Utopian Rocks',
          theme: theme,
          home: BlocProvider<ContributionBloc>(
            // _ makes the build context an anonymous variable.
            builder: (_, bloc) => bloc ?? ContributionBloc(RocksApi()),
            onDispose: (_, bloc) => bloc.dispose(),
            child: HomePage(),
          ),
        );
      },
    );
  }
}

// TODO add pull to refresh
// TODO add a card appearance animation
// TODO add percentage circle indicator option to the upvote section
// TODO add option to hide avatars, hide category icons while viewing a single category,
//    always hide category icons, switch themes, show comment/vote count and rank
// TODO name this
// TODO make contribution abstractions to prevent use of utils.dart within the _content widget
// TODo enable expanding of botton app bar
// TODO Use a persistent bottom sheet instead of a bottom app bar for category selection
// TODO add dialog to customise contribution view(multiple check boxes) and app theme(dropdown), all with sp persistence
// TODO show next vote cycle and vote power
