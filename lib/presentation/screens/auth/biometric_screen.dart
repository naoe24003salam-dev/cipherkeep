import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../logic/providers/auth_provider.dart';
import '../../../logic/state/auth_state.dart';
import '../../widgets/biometric_button.dart';

class BiometricScreen extends ConsumerStatefulWidget {
  const BiometricScreen({super.key});

  @override
  ConsumerState<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends ConsumerState<BiometricScreen> {
  BiometricButtonState _state = BiometricButtonState.idle;
  String? _error;
  int _attempts = 0;

  Future<void> _startAuth() async {
    _attempts++;
    setState(() {
      _state = BiometricButtonState.authenticating;
      _error = null;
    });

    final result =
        await ref.read(authProvider.notifier).authenticateWithBiometric();
    if (!mounted) return;

    if (result.success) {
      setState(() {
        _state = BiometricButtonState.success;
      });

      final authState = ref.read(authProvider);
      if (authState is AuthAuthenticated) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) context.go('/vault');
      } else if (authState is AuthDecoy) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) context.go('/decoy');
      }
    } else {
      setState(() {
        _state = BiometricButtonState.failure;
        _error = result.errorMessage ?? 'Biometric authentication failed';
      });
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _state = BiometricButtonState.idle;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Unlock'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fingerprint,
                size: 120,
                color: theme.colorScheme.primary,
              ).animate(onPlay: (c) => c.repeat()).shimmer(
                    duration: 1800.ms,
                    color: theme.colorScheme.secondary.withOpacity(0.4),
                  ),
              const SizedBox(height: 32),
              Text(
                'Use your fingerprint or face to unlock',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'This is faster and secure. You can always use PIN instead.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              BiometricButton(
                state: _state,
                onPressed: _startAuth,
                color: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Column(
                  children: [
                    Text(
                      _error!,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_attempts >= 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Too many attempts. Use PIN instead.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go('/pin'),
                child: const Text('Use PIN instead'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
