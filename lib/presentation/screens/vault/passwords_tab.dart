import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cypherkeep/logic/providers/vault_provider.dart';
import 'package:cypherkeep/data/models/password_entry.dart';
import 'dart:math';

class PasswordsTab extends ConsumerStatefulWidget {
  const PasswordsTab({super.key});

  @override
  ConsumerState<PasswordsTab> createState() => _PasswordsTabState();
}

class _PasswordsTabState extends ConsumerState<PasswordsTab> {
  void _showPasswordDialog({PasswordEntry? entry}) {
    final siteController = TextEditingController(text: entry?.site ?? '');
    final usernameController =
        TextEditingController(text: entry?.username ?? '');
    final passwordController =
        TextEditingController(text: entry?.password ?? '');
    final notesController = TextEditingController(text: entry?.notes ?? '');
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(entry == null ? 'New Password' : 'Edit Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: siteController,
                  decoration: const InputDecoration(
                    labelText: 'Website/App',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.language),
                  ),
                  maxLength: 100,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username/Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  maxLength: 100,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.auto_awesome),
                          onPressed: () {
                            final generated = _generatePassword();
                            passwordController.text = generated;
                          },
                          tooltip: 'Generate password',
                        ),
                      ],
                    ),
                  ),
                  maxLength: 100,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 3,
                  maxLength: 500,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final site = siteController.text.trim();
                final username = usernameController.text.trim();
                final password = passwordController.text.trim();
                final notes = notesController.text.trim();

                if (site.isEmpty || username.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Site, username, and password are required')),
                  );
                  return;
                }

                if (entry == null) {
                  await ref.read(vaultProvider.notifier).addPassword(
                        site,
                        username,
                        password,
                        notes: notes.isEmpty ? null : notes,
                      );
                } else {
                  await ref.read(vaultProvider.notifier).updatePassword(
                        entry.id,
                        site,
                        username,
                        password,
                        notes: notes.isEmpty ? null : notes,
                      );
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  String _generatePassword() {
    const length = 16;
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+-=[]{}|;:,.<>?';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final passwords = ref.watch(vaultProvider).passwords;
    final theme = Theme.of(context);

    return Scaffold(
      body: passwords.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.password,
                    size: 80,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No passwords yet',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first password',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: passwords.length,
              itemBuilder: (context, index) {
                final entry = passwords[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        entry.site[0].toUpperCase(),
                        style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer),
                      ),
                    ),
                    title: Text(
                      entry.site,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(entry.username),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PasswordField(
                              label: 'Password',
                              value: entry.password,
                            ),
                            if (entry.notes != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Notes:',
                                style: theme.textTheme.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(entry.notes!),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit'),
                                  onPressed: () =>
                                      _showPasswordDialog(entry: entry),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Delete'),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Password'),
                                        content: const Text(
                                            'Are you sure you want to delete this password?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              ref
                                                  .read(vaultProvider.notifier)
                                                  .deletePassword(entry.id);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPasswordDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final String label;
  final String value;

  const _PasswordField({
    required this.label,
    required this.value,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              Text(
                _obscured ? '••••••••' : widget.value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscured = !_obscured;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: widget.value));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password copied to clipboard')),
            );
          },
        ),
      ],
    );
  }
}
