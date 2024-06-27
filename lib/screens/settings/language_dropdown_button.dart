import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_gp5/main.dart';
import 'package:flutter_gp5/utils/supported_language_model.dart';

class LanguageDropdownButton extends StatefulWidget {
  const LanguageDropdownButton({super.key});

  @override
  LanguageDropdownButtonState createState() => LanguageDropdownButtonState();
}

class LanguageDropdownButtonState extends State<LanguageDropdownButton> {
  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = MyApp.locale!.languageCode;
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguageCode = languageCode;
    });
    MyApp.setLocale(context, Locale(_selectedLanguageCode));
  }

  @override
  Widget build(BuildContext context) {
    final supportedLanguages = Language.supportedLanguages(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(2, 2), // Sharp shadow edges
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguageCode,
          onChanged: (String? newValue) {
            if (newValue != null) {
              _changeLanguage(newValue);
            }
          },
          items: supportedLanguages.map<DropdownMenuItem<String>>((language) {
            return DropdownMenuItem<String>(
              value: language.languageCode,
              child: Row(
                children: [
                  CountryFlag.fromLanguageCode(
                    language.countryCode,
                    height: 24,
                    width: 32,
                    shape: const Circle(),
                  ),
                  const SizedBox(width: 8),
                  Text(language.label),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
