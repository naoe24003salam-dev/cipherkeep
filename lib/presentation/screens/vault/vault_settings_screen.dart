import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../logic/providers/auth_provider.dart';
import '../../../logic/providers/theme_provider.dart';
import '../../../logic/providers/vault_provider.dart';
import '../../widgets/theme_selector.dart';

class VaultSettingsScreen extends ConsumerStatefulWidget {
  const VaultSettingsScreen({super.key});

  @override
  ConsumerState<VaultSettingsScreen> createState() =>
      _VaultSettingsScreenState();
}

class _VaultSettingsScreenState extends ConsumerState<VaultSettingsScreen> {
  bool _biometricEnabled = true;

  Future<void> _changeRealPin() async {
    final currentPinController = TextEditingController();
    final controller1 = TextEditingController();
    final controller2 = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Real PIN'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPinController,
                decoration: const InputDecoration(labelText: 'Current Real PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (v) =>
                    v?.length == 6 ? null : 'PIN must be 6 digits',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller1,
                decoration: const InputDecoration(labelText: 'New Real PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (v) =>
                    v?.length == 6 ? null : 'PIN must be 6 digits',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller2,
                decoration:
                    const InputDecoration(labelText: 'Confirm Real PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (v) =>
                    v == controller1.text ? null : 'PINs do not match',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                // Verify current PIN
                final authResult = await ref
                    .read(authProvider.notifier)
                    .authenticateWithPin(currentPinController.text);
                if (authResult.success) {
                  Navigator.pop(context, true);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(authResult.errorMessage ?? 'Invalid PIN')),
                    );
                  }
                }
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      await ref.read(authProvider.notifier).changeRealPin(controller1.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Real PIN updated successfully')),
        );
      }
    }
  }

  Future<void> _changeGhostPin() async {
    final currentPinController = TextEditingController();
    final controller1 = TextEditingController();
    final controller2 = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Ghost PIN'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPinController,
                decoration: const InputDecoration(labelText: 'Current Ghost PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (v) =>
                    v?.length == 6 ? null : 'PIN must be 6 digits',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller1,
                decoration: const InputDecoration(labelText: 'New Ghost PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (v) =>
                    v?.length == 6 ? null : 'PIN must be 6 digits',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller2,
                decoration:
                    const InputDecoration(labelText: 'Confirm Ghost PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (v) =>
                    v == controller1.text ? null : 'PINs do not match',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                // Verify current PIN
                final authResult = await ref
                    .read(authProvider.notifier)
                    .authenticateWithPin(currentPinController.text);
                if (authResult.success) {
                  Navigator.pop(context, true);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(authResult.errorMessage ?? 'Invalid PIN')),
                    );
                  }
                }
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      await ref.read(authProvider.notifier).changeGhostPin(controller1.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ghost PIN updated successfully')),
        );
      }
    }
  }

  Future<void> _exportVault() async {
    try {
      final vault = ref.read(vaultProvider);
      final exportData = {
        'notes': vault.notes.map((n) => n.toJson()).toList(),
        'passwords': vault.passwords.map((p) => p.toJson()).toList(),
        'encodedImages':
            vault.encodedImages.map((img) => img.toJson()).toList(),
        'exportedAt': DateTime.now().toIso8601String(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      
      // Show export options dialog
      final exportOption = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Vault'),
          content: const Text('Choose export method:'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'share'),
              child: const Text('Share to App'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'save'),
              child: const Text('Save to Downloads'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );

      if (exportOption == null) return;

      final fileName = 'cypherkeep_backup_${DateTime.now().millisecondsSinceEpoch}.json';

      if (exportOption == 'save') {
        // Save to Downloads folder
        final dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          final docDir = await getApplicationDocumentsDirectory();
          final file = File('${docDir.path}/$fileName');
          await file.writeAsString(jsonString);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Saved to: ${file.path}')),
            );
          }
        } else {
          final file = File('${dir.path}/$fileName');
          await file.writeAsString(jsonString);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vault saved to Downloads folder')),
            );
          }
        }
      } else if (exportOption == 'share') {
        // Share via any app
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$fileName');
        await file.writeAsString(jsonString);

        await Share.shareXFiles(
          [XFile(file.path)],
          subject: 'CypherKeep Vault Backup',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vault exported successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _importVault() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) return;

      final file = File(result.files.first.path!);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      await ref.read(vaultProvider.notifier).importVault(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vault imported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Security', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_reset),
                  title: const Text('Change Real PIN'),
                  onTap: _changeRealPin,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.visibility_off),
                  title: const Text('Change Ghost PIN'),
                  onTap: _changeGhostPin,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() => _biometricEnabled = value);
                  },
                  secondary: const Icon(Icons.fingerprint),
                  title: const Text('Enable Biometric'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Appearance', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Theme'),
                  const SizedBox(height: 12),
                  const ThemeSelector(showLabels: true, previewHeight: 100),
                  const SizedBox(height: 8),
                  Text('Current: $appTheme'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Data', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Export encrypted backup'),
                  onTap: _exportVault,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.upload),
                  title: const Text('Import backup'),
                  onTap: _importVault,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: const Text('Clear vault data'),
                  onTap: () async {
                    await ref.read(authProvider.notifier).triggerPanicWipe();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vault cleared')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Danger Zone',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.colorScheme.error)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                ref.read(authProvider.notifier).logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
