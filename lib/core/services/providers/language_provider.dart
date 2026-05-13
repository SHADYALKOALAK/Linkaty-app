import 'package:flutter/foundation.dart';
import 'package:linkaty/core/enums/enums.dart';
import 'package:linkaty/core/services/cache/app_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String language = AppPreferences().getter(CacheKeys.language) ?? 'en';

  Future<void> changeLanguage() async {
    language = language == 'ar' ? 'en' : 'ar';
    await AppPreferences().setter(CacheKeys.language, language);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    language = lang;
    await AppPreferences().setter(CacheKeys.language, lang);
    notifyListeners();
  }
}
