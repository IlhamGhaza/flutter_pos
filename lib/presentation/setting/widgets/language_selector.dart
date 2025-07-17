import 'package:flutter/material.dart';
import 'package:flutter_pos/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../main.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  Locale? _selectedLocale; // null means 'system'

  final List<Locale?> _supportedLocales = [
    null, // null for 'System'
    const Locale('en'),
    const Locale('id'),
  ];

  String _localeLabel(Locale? locale, AppLocalizations l10n) {
    if (locale == null) return l10n.system; // label for 'System'
    if (locale.languageCode == 'en') return l10n.english;
    if (locale.languageCode == 'id') return l10n.indonesian;
    return locale.languageCode;
  }

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('locale');
    setState(() {
      if (langCode == null || langCode == 'system') {
        _selectedLocale = null;
      } else {
        _selectedLocale = Locale(langCode);
      }
    });
  }

  Future<void> _changeLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.setString('locale', 'system');
      MyApp.setLocale(context, null);
    } else {
      await prefs.setString('locale', locale.languageCode);
      MyApp.setLocale(context, locale);
    }
    setState(() {
      _selectedLocale = locale;
    });
  }

  Locale? _getEffectiveLocale(BuildContext context) {
    // If system, return null (dropdown value), but for display, use context locale
    if (_selectedLocale == null) {
      return null;
    }
    return _selectedLocale;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // For display, show the actual language in use if system is selected
    final Locale currentLocale = _selectedLocale == null
        ? Localizations.localeOf(context)
        : _selectedLocale!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.language,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.language +
                      (_selectedLocale == null
                          ? ' (${_localeLabel(currentLocale, l10n)})'
                          : ''),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              DropdownButton<Locale?>(
                value: _getEffectiveLocale(context),
                underline: const SizedBox(),
                items: _supportedLocales.map((locale) {
                  return DropdownMenuItem<Locale?>(
                    value: locale,
                    child: Text(_localeLabel(locale, l10n)),
                  );
                }).toList(),
                onChanged: (locale) {
                  _changeLocale(locale);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
