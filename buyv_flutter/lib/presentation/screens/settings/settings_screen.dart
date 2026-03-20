import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../router/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const Map<String, String> _languages = <String, String>{
    'fr': 'Francais',
    'en': 'English',
    'ar': 'العربية',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Parametres')),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Langue'),
            subtitle: Text(_languages[settings.languageCode] ?? settings.languageCode),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final selected = await showModalBottomSheet<String>(
                context: context,
                builder: (sheetContext) {
                  return SafeArea(
                    child: ListView(
                      shrinkWrap: true,
                      children: _languages.entries
                          .map(
                            (entry) => ListTile(
                              title: Text(entry.value),
                              trailing: settings.languageCode == entry.key
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () {
                                Navigator.of(sheetContext).pop(entry.key);
                              },
                            ),
                          )
                          .toList(growable: false),
                    ),
                  );
                },
              );

              if (selected != null && selected != settings.languageCode) {
                await settingsNotifier.setLanguageCode(selected);
              }
            },
          ),
          const Divider(height: 8),
          SwitchListTile(
            title: const Text('Notifications push'),
            subtitle: const Text('Recevoir les alertes et activites compte.'),
            value: settings.notificationsEnabled,
            onChanged: settingsNotifier.setNotificationsEnabled,
          ),
          SwitchListTile(
            title: const Text('Lecture auto reels'),
            subtitle: const Text('Demarrer automatiquement les reels dans le feed.'),
            value: settings.reelsAutoplay,
            onChanged: settingsNotifier.setReelsAutoplay,
          ),
          SwitchListTile(
            title: const Text('Utiliser les donnees mobiles'),
            subtitle: const Text('Autoriser le chargement media hors wifi.'),
            value: settings.useMobileData,
            onChanged: settingsNotifier.setUseMobileData,
          ),
          SwitchListTile(
            title: const Text('Verrouillage biometrique'),
            subtitle: const Text('Demander un deblocage local a l ouverture.'),
            value: settings.biometricLock,
            onChanged: settingsNotifier.setBiometricLock,
          ),
          const Divider(height: 24),
          if (authState is AuthAuthenticated)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Se deconnecter'),
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              },
            ),
        ],
      ),
    );
  }
}

