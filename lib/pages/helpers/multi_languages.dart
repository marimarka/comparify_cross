import 'dart:convert';

import 'package:comparify_cross/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'multi_languages_delegate.dart';

class MultiLanguages {
  final Locale locale;

  MultiLanguages({this.locale = const Locale.fromSubtags(languageCode: 'en')});

  static MultiLanguages? of(BuildContext context) {
    return Localizations.of<MultiLanguages>(context, MultiLanguages);
  }

  void keepLocaleKey(String localeKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("localeKey");
    await prefs.setString("localeKey", localeKey);
  }

  Future<String> readLocaleKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("localeKey") ?? "lv";
  }

  void setLocale(BuildContext context, Locale locale) async {
    keepLocaleKey(locale.languageCode);
    print("key language" + locale.languageCode);

    MyApp.setLocal(context, locale);
  }

  static const LocalizationsDelegate<MultiLanguages> delegate =
      MultiLanguagesDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString("assets/language/${locale.languageCode}.json");
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key]!;
  }
}
