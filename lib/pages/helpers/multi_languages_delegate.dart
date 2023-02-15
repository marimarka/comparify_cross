import 'package:flutter/material.dart';

import 'multi_languages.dart';

class MultiLanguagesDelegate extends LocalizationsDelegate<MultiLanguages> {
  // This delegate instance will never change
  // It can provide a constant constructor.
  const MultiLanguagesDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'lv', 'ru'].contains(locale.languageCode);
  }

  /// read Json
  @override
  Future<MultiLanguages> load(Locale locale) async {
    // MultiLanguages class is where the JSON loading actually runs

    MultiLanguages localizations = MultiLanguages(locale: locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(MultiLanguagesDelegate old) => false;
}
