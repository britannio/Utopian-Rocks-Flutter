import 'package:rxdart/rxdart.dart';
import 'package:utopian_rocks_2/models/settings_model.dart';
import 'package:utopian_rocks_2/providers/settings_provider.dart';

class SettingsBloc {
  SettingsProvider _settingsProvider = SettingsProvider();

  BehaviorSubject<SettingsModel> _settings = BehaviorSubject<SettingsModel>();

  Stream<SettingsModel> get getSettings => _settings.stream;

  SettingsBloc() {
    _settingsProvider.getSettings().then(_settings.add);
  }

  void setValue(Settings settingsValues, bool newValue) {
    _settingsProvider.setValue(settingsValues, newValue);
    _settingsProvider.getSettings().then((SettingsModel settings) {
      _settings.add(settings);
    });
  }

  void dispose() {
    _settings.close();
  }
}
