import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/features/localization/application/locale_provider.dart';
import 'package:recipes/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguagePickerDialog extends ConsumerWidget {
  const LanguagePickerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // It's good practice to ensure AppLocalizations is not null,
    // though if this dialog is shown from within a properly configured app, it should be fine.
    final AppLocalizations? l10n = AppLocalizations.of(context);
    if (l10n == null) {
      // Fallback or error state if l10n is not available.
      // This should ideally not happen if the dialog is launched from
      // a screen that is a child of the main MaterialApp.
      return const AlertDialog(title: Text("Error"), content: Text("Localizations not available."));
    }

    final currentLocale = ref.watch(localeProvider);
    final supportedLocales = AppLocalizations.supportedLocales;

    String getLanguageDisplayName(Locale locale) {
      // Ensure your ARB files have these keys if you use them.
      // Example:
      // In app_en.arb: "englishLanguage": "English", "arabicLanguage": "Arabic"
      // In app_ar.arb: "englishLanguage": "الإنجليزية", "arabicLanguage": "العربية"
      if (locale.languageCode == 'en') return l10n.english;
      if (locale.languageCode == 'ar') return l10n.arabic;
      return locale.toLanguageTag(); // Fallback to language tag
    }

    return AlertDialog(
      title: Text(l10n.selectLanguage), // e.g., "selectLanguageDialogTitle": "Select Language"
      content: SizedBox(
        width: double.maxFinite, // Make dialog content take available width
        child: ListView.builder(
          shrinkWrap: true, // Important for ListView inside AlertDialog
          itemCount: supportedLocales.length,
          itemBuilder: (context, index) {
            final locale = supportedLocales[index];
            return RadioListTile<Locale>(
              title: Text(getLanguageDisplayName(locale)),
              value: locale,
              groupValue: currentLocale,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  ref.read(localeProvider.notifier).setLocale(newLocale);
                  // Optionally, pop only after the setLocale future completes if it's async
                  // and you want to ensure it's saved before closing.
                  // For now, simple pop is fine.
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(l10n.cancelButton), // e.g., "cancelButton": "Cancel"
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
