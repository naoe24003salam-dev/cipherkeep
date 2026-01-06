import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cypherkeep/logic/providers/theme_provider.dart';
import 'package:cypherkeep/logic/providers/auth_provider.dart';
import 'package:cypherkeep/logic/providers/vault_provider.dart';
import 'package:cypherkeep/config/themes/theme_data.dart';
import 'package:cypherkeep/config/app_config.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.palette, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Appearance',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Theme',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...AppTheme.values.map((appTheme) {
                  return RadioListTile<AppTheme>(
                    title: Text(appTheme.name),
                    value: appTheme,
                    groupValue: currentTheme,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(themeProvider.notifier).setTheme(value);
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.security, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Security',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.lock_reset),
                  title: const Text('Change PINs'),
                  subtitle: const Text('Update your real and ghost PINs'),
                  onTap: () {
                    _showChangePinDialog(context, ref);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.fingerprint),
                  title: const Text('Biometric Authentication'),
                  subtitle: const Text('Enable fingerprint/face unlock'),
                  trailing: Switch(
                    value: false, // TODO: Implement biometric toggle
                    onChanged: (value) {
                      // TODO: Implement biometric enable/disable
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.storage, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Data Management',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.delete_forever,
                      color: theme.colorScheme.error),
                  title: Text(
                    'Clear All Data',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  subtitle: const Text('Permanently delete all vault data'),
                  onTap: () {
                    _showClearDataDialog(context, ref);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      'About',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const ListTile(
                  title: Text('Version'),
                  subtitle: Text(AppConfig.appVersion),
                ),
                const ListTile(
                  title: Text('Developer'),
                  subtitle: Text(AppConfig.developer),
                ),
                const ListTile(
                  title: Text('Privacy'),
                  subtitle: Text('100% offline, no internet access'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showChangePinDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change PINs'),
        content: const Text(
          'To change your PINs, you need to clear all data and set up the app again. '
          'This will permanently delete all your notes, passwords, and encoded images.\n\n'
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _showClearDataDialog(context, ref);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('Clear All Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will permanently delete:\n'
              '• All secure notes\n'
              '• All saved passwords\n'
              '• All encoded images\n'
              '• App settings and PINs\n\n'
              'This action CANNOT be undone!\n\n'
              'Type "DELETE" to confirm:',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                labelText: 'Confirmation',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (confirmController.text.trim() == 'DELETE') {
                await ref.read(vaultProvider.notifier).clearAllData();
                await ref.read(authProvider.notifier).logout();

                if (context.mounted) {
                  Navigator.pop(context);
                  context.go('/onboarding');
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please type DELETE to confirm')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }
}
