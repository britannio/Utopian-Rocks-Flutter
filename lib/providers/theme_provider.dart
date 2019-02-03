import 'package:utopian_rocks_2/blocs/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider {
  Themes _theme;

  Future<Themes> getTheme() async {
    if (_theme != null) {
      return _theme;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String themeString = prefs.getString('theme') ?? themeMap[Themes.dark];

    if (themeString == themeMap[Themes.dark]) {
      _theme = Themes.dark;
    } else if (themeString == themeMap[Themes.amoled]) {
      _theme = Themes.amoled;
    } else if (themeString == themeMap[Themes.light]) {
      _theme = Themes.light;
    } else if (themeString == themeMap[Themes.utopian]) {
      _theme = Themes.utopian;
    }

    print('Current theme retrieved: $themeString');
    return _theme;
  }

  Future<void> setTheme(Themes newTheme) async {
    if (newTheme != _theme) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _theme = newTheme;

      await prefs.setString('theme', themeMap[newTheme]);
      print('New theme saved: ${themeMap[newTheme]}');
    }
  }
}

const themeMap = <Themes, String>{
  Themes.dark: 'theme_dark',
  Themes.amoled: 'theme_amoled',
  Themes.light: 'theme_light',
  Themes.utopian: 'theme_utopian'
};
