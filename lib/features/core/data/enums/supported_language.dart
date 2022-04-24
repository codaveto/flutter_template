import 'package:flutter/material.dart';

enum SupportedLanguage {
  en,
  nl,
}

const _defaultLanguage = SupportedLanguage.en;

extension SupportedLocaleExtension on SupportedLanguage {
  Locale get toLocale => Locale(name, name.toUpperCase());
}

extension LocaleExtension on Locale {
  Locale get toSupportedLocaleWithDefault =>
      SupportedLanguage.values.asNameMap()[languageCode]?.toLocale ?? _defaultLanguage.toLocale;
}
