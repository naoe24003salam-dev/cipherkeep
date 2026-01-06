import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'secure_notes_screen.dart';
import 'password_manager_screen.dart';
import 'stego_lab_screen.dart';
import 'vault_settings_screen.dart';
import 'package:cypherkeep/logic/providers/auth_provider.dart';

final _selectedTabIndexProvider = StateProvider<int>((ref) => 0);

class VaultHomeScreen extends ConsumerWidget {
  const VaultHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(_selectedTabIndexProvider);

    const screens = [
      SecureNotesScreen(),
      PasswordManagerScreen(),
      StegoLabScreen(),
      VaultSettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CipherKeep'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/pin');
            },
            tooltip: 'Lock',
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(_selectedTabIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.note),
            selectedIcon: Icon(Icons.note),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.password),
            selectedIcon: Icon(Icons.password),
            label: 'Passwords',
          ),
          NavigationDestination(
            icon: Icon(Icons.image),
            selectedIcon: Icon(Icons.image),
            label: 'Stego Lab',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
