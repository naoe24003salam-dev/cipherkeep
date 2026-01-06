import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/password_entry.dart';
import '../../../logic/providers/vault_provider.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/password_strength_indicator.dart';
import '../../widgets/secure_text_field.dart';

class PasswordManagerScreen extends ConsumerStatefulWidget {
  const PasswordManagerScreen({super.key});

  @override
  ConsumerState<PasswordManagerScreen> createState() =>
      _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends ConsumerState<PasswordManagerScreen> {
  String _search = '';

  String _generatePassword({int length = 16}) {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789@#%*?!';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }

  void _showEntryDialog({PasswordEntry? entry}) {
    final titleController = TextEditingController(text: entry?.title ?? '');
    final usernameController =
        TextEditingController(text: entry?.username ?? '');
    final passwordController =
        TextEditingController(text: entry?.password ?? '');
    final siteController = TextEditingController(text: entry?.site ?? '');
    final notesController = TextEditingController(text: entry?.notes ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(entry == null ? 'New Password' : 'Edit Password'),
        content: SizedBox(
          width: 360,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: siteController,
                  decoration: const InputDecoration(labelText: 'Site / URL'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SecureTextField(
                        controller: passwordController,
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        passwordController.text = _generatePassword();
                      },
                      icon: const Icon(Icons.autorenew),
                      tooltip: 'Generate strong password',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: passwordController,
                  builder: (context, value, _) {
                    return PasswordStrengthIndicator(password: value.text);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final password = passwordController.text.trim();
              if (title.isEmpty || password.isEmpty) return;
              if (entry == null) {
                await ref.read(vaultProvider.notifier).addPassword(
                      siteController.text.trim().isEmpty
                          ? title
                          : siteController.text.trim(),
                      usernameController.text.trim(),
                      password,
                      notes: notesController.text.trim(),
                    );
              } else {
                await ref.read(vaultProvider.notifier).updatePassword(
                      entry.id,
                      siteController.text.trim().isEmpty
                          ? title
                          : siteController.text.trim(),
                      usernameController.text.trim(),
                      password,
                      notes: notesController.text.trim(),
                    );
              }
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(vaultProvider).passwords.where((p) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return p.title.toLowerCase().contains(q) ||
          p.username.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Manager'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search credentials...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEntryDialog(),
        child: const Icon(Icons.add),
      ),
      body: entries.isEmpty
          ? const Center(child: Text('No passwords stored'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedCard(
                    staggerIndex: index,
                    onTap: () => _showEntryDialog(entry: entry),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child:
                              Text(entry.title.characters.first.toUpperCase()),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(entry.username,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 2),
                              const Text('••••••••'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: entry.password));
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Password copied')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => _showMenu(context, entry),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showMenu(BuildContext context, PasswordEntry entry) async {
    final selection = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );

    if (selection == 'edit') {
      _showEntryDialog(entry: entry);
    } else if (selection == 'delete') {
      ref.read(vaultProvider.notifier).deletePassword(entry.id);
    }
  }
}
