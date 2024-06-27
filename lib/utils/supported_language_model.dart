import 'package:flutter/material.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';

class Language {
  final String languageCode;
  final String label;
  final String countryCode;

  Language({
    required this.languageCode,
    required this.label,
    required this.countryCode,
  });

  static List<Language> supportedLanguages(BuildContext context) {
    final localizations = AppLocale.of(context)!;
    return [
      Language(
          languageCode: 'en',
          label: localizations.language_en,
          countryCode: 'en'),
      Language(
          languageCode: 'bg',
          label: localizations.language_bg,
          countryCode: 'bg'),
      Language(
          languageCode: 'de',
          label: localizations.language_de,
          countryCode: 'de'),
    ];
  }
}
