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

  BehaviorSubject<Themes> _selectedTheme = BehaviorSubject<Themes>();

  Stream<Themes> get getTheme => _selectedTheme.stream;
  Sink<Themes> get setTheme => _selectedTheme.sink;

  ThemeBloc(this.themeProvider) {
    themeProvider.getTheme().then(setTheme.add);
    _selectedTheme.distinct().listen(themeProvider.setTheme);
  }

  void dispose() {
    _selectedTheme.close();
  }
}
