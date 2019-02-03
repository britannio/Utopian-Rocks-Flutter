import 'package:rxdart/rxdart.dart';
import 'package:utopian_rocks_2/providers/theme_provider.dart';

enum Themes {
  light,
  dark,
  utopian,
  amoled,
}

class ThemeBloc {
  final ThemeProvider themeProvider;

  BehaviorSubject<Themes> _selectedTheme =
      BehaviorSubject<Themes>(seedValue: Themes.dark);

  Stream<Themes> get getTheme => _selectedTheme.stream;
  Sink<Themes> get setTheme => _selectedTheme.sink;

  ThemeBloc(this.themeProvider) {
    // TODO use the theme_provider class to get the latest theme from shared preferences
    // TODO listen to theme changes and update shared preferences
    themeProvider.getTheme().then(setTheme.add);
    _selectedTheme.distinct().listen(themeProvider.setTheme);

  }

  void dispose() {
    _selectedTheme.close();
  }
}
