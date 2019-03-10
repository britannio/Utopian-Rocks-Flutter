import 'package:shared_preferences/shared_preferences.dart';
import 'package:utopian_rocks_2/models/settings_model.dart';

class SettingsProvider {
  Future<SettingsModel> getSettings() async {
    SettingsModel settingsModel = SettingsModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool showAvatar = prefs.getBool(settingsKeys[Settings.SHOW_AVATAR]) ?? true;
    bool showCard = prefs.getBool(settingsKeys[Settings.SHOW_CARD]) ?? false;
    bool showCategory =
        prefs.getBool(settingsKeys[Settings.SHOW_CATEGORY]) ?? true;
    bool showStats = prefs.getBool(settingsKeys[Settings.SHOW_STATS]) ?? false;

    settingsModel.showAvatar = showAvatar;
    settingsModel.showCard = showCard;
    settingsModel.showCategory = showCategory;
    settingsModel.showStats = showStats;

    return settingsModel;
  }

  Future<void> setValue(Settings settingsValues, bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(settingsKeys[settingsValues], newValue);
    print('${settingsValues.toString()}: $newValue');
  }
}

enum Settings { SHOW_AVATAR, SHOW_STATS, SHOW_CATEGORY, SHOW_CARD }

const settingsKeys = <Settings, String>{
  Settings.SHOW_AVATAR: 'show_avatar',
  Settings.SHOW_CARD: 'show_card',
  Settings.SHOW_CATEGORY: 'show_category',
  Settings.SHOW_STATS: 'show_stats',
};
