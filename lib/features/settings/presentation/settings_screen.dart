import 'package:flutter/material.dart';
import 'package:recipes/features/localization/presentation/language_picker_bottom_sheet.dart';
import 'package:recipes/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = 'SettingsScreen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Settings Screen'), // In your screen widget (e.g., MyHomePage)
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const LanguagePickerDialog();
                },
              );
            },
            // Using a key from AppLocalizations for the button text itself
            child: Text(AppLocalizations.of(context)!.changeLanguageButtonText), // Add "changeLanguageButtonText" to ARB
          ),
        ],
      ),
    );
  }
}
