import 'package:flutter/material.dart';
import '../constants/translations.dart';

class TranslationsHelper {
  static String translate(BuildContext context, String key) {
    final locale = Localizations.localeOf(context);
    return Translations.translate(key, locale.languageCode);
  }

  static String translateWithLocale(String key, String languageCode) {
    return Translations.translate(key, languageCode);
  }
}
