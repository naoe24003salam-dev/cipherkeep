import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../../../logic/providers/auth_provider.dart';
import '../../../logic/state/auth_state.dart';
import '../../widgets/biometric_button.dart';
import '../../widgets/custom_pin_pad.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  int _failedAttempts = 0;
  bool _isShaking = false;
  BiometricButtonState _bioState = BiometricButtonState.idle;

  Future<void> _onPinComplete(String pin) async {
    final result =
        await ref.read(authProvider.notifier).authenticateWithPin(pin);

    if (!mounted) return;

    if (result.success) {
      final authState = ref.read(authProvider);
      if (authState is AuthAuthenticated) {
        context.go('/vault');
      } else if (authState is AuthDecoy) {
        context.go('/decoy');
      }
    } else {
      _failedAttempts = ref.read(authProvider.notifier).failedAttemptsCount;
      _triggerShake();
      _showError(result.errorMessage ?? 'Incorrect PIN');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _triggerShake() {
    setState(() {
      _isShaking = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isShaking = false;
        });
      }
    });
  }

  Future<void> _authenticateWithBiometric() async {
    setState(() {
      _bioState = BiometricButtonState.authenticating;
    });

    final result =
        await ref.read(authProvider.notifier).authenticateWithBiometric();

    if (!mounted) return;

    if (result.success) {
      setState(() {
        _bioState = BiometricButtonState.success;
      });

      final authState = ref.read(authProvider);
      if (authState is AuthAuthenticated) {
        context.go('/vault');
      } else if (authState is AuthDecoy) {
        context.go('/decoy');
      }
    } else {
      setState(() {
        _bioState = BiometricButtonState.failure;
      });
      _showError(result.errorMessage ?? 'Biometric authentication failed');
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _bioState = BiometricButtonState.idle;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 90,
                  color: theme.colorScheme.primary,
                ).animate(onPlay: (c) => c.repeat()).shimmer(
                      duration: 2000.ms,
                      color: theme.colorScheme.secondary.withOpacity(0.4),
                    ),
                const SizedBox(height: 32),
                Text(
                  'CipherKeep',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter your PIN',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 48),
                _buildPinPad(theme),
                const SizedBox(height: 24),
                if (_failedAttempts > 0)
                  Text(
                    'Failed attempts: $_failedAttempts/${AppConfig.maxFailedAttempts}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                if (_failedAttempts >= AppConfig.maxFailedAttempts)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Too many attempts. Use biometrics or wait before retrying.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 32),
                BiometricButton(
                  state: _bioState,
                  onPressed: _authenticateWithBiometric,
                  color: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
                TextButton(
                  onPressed: () => context.go('/biometric'),
                  child: const Text('Try biometric instead'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinPad(ThemeData theme) {
    Widget pinPad = CustomPinPad(
      pinLength: AppConfig.pinLength,
      onPinComplete: _onPinComplete,
      activeColor: theme.colorScheme.primary,
      buttonColor: theme.colorScheme.surfaceContainerHighest,
      textColor: theme.colorScheme.onSurface,
    );

    if (_isShaking) {
      pinPad = pinPad.animate().shake(
            duration: 500.ms,
            hz: 4,
            curve: Curves.easeInOut,
          );
    }

    return pinPad;
  }
}
