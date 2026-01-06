import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../../../logic/providers/auth_provider.dart';
import '../../widgets/custom_pin_pad.dart';
import '../../widgets/theme_selector.dart';

/// Setup wizard with 4 steps: Real PIN, Ghost PIN, Theme, Summary
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  int _step = 0;
  String _realPin = '';
  String _ghostPin = '';
  bool _isConfirming = false;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _nextStep() {
    if (_step < 3) {
      setState(() {
        _step += 1;
        _isConfirming = false;
      });
    }
  }

  void _previousStep() {
    if (_step > 0) {
      setState(() {
        _step -= 1;
        _isConfirming = false;
      });
    }
  }

  void _onPinComplete(String pin) {
    setState(() {
      if (_step == 0) {
        if (!_isConfirming) {
          _realPin = pin;
          _isConfirming = true;
        } else {
          if (pin == _realPin) {
            _nextStep();
          } else {
            _showError('PINs do not match');
            _realPin = '';
            _isConfirming = false;
          }
        }
      } else if (_step == 1) {
        if (!_isConfirming) {
          if (pin == _realPin) {
            _showError('Ghost PIN must be different from Real PIN');
            return;
          }
          _ghostPin = pin;
          _isConfirming = true;
        } else {
          if (pin == _ghostPin) {
            _nextStep();
          } else {
            _showError('PINs do not match');
            _ghostPin = '';
            _isConfirming = false;
          }
        }
      }
    });
  }

  Future<void> _finishSetup() async {
    if (_realPin.length != AppConfig.pinLength ||
        _ghostPin.length != AppConfig.pinLength) {
      _showError('Please complete both PINs first');
      return;
    }

    try {
      await ref.read(authProvider.notifier).setupPins(_realPin, _ghostPin);
      if (mounted) {
        context.go('/pin');
      }
    } catch (e) {
      _showError('Setup failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Wizard'),
        leading: _step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressIndicator(theme),
              const SizedBox(height: 24),
              Expanded(child: _buildStepContent(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    const steps = ['Real PIN', 'Ghost PIN', 'Theme', 'Summary'];

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        final isDivider = index.isOdd;
        if (isDivider) {
          return Expanded(
            child: Container(
              height: 2,
              color: index ~/ 2 < _step
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          );
        } else {
          final stepIndex = index ~/ 2;
          final isActive = stepIndex == _step;
          final isCompleted = stepIndex < _step;
          return Column(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isActive
                    ? theme.colorScheme.primary
                    : isCompleted
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                child: Text(
                  '${stepIndex + 1}',
                  style: TextStyle(
                    color: isActive
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                steps[stepIndex],
                style: TextStyle(
                  fontSize: 12,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildStepContent(ThemeData theme) {
    switch (_step) {
      case 0:
        return _buildPinStep(
          theme,
          title: _isConfirming ? 'Confirm Real PIN' : 'Set Real PIN',
          subtitle: 'This PIN unlocks your secure vault.',
          icon: Icons.lock,
        );
      case 1:
        return _buildPinStep(
          theme,
          title: _isConfirming ? 'Confirm Ghost PIN' : 'Set Ghost PIN',
          subtitle:
              'This PIN opens the decoy app. It must differ from Real PIN.',
          icon: Icons.visibility_off,
        );
      case 2:
        return _buildThemeStep(theme);
      case 3:
        return _buildSummaryStep(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPinStep(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 72, color: theme.colorScheme.primary),
        const SizedBox(height: 24),
        Text(
          title,
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        if (_isConfirming)
          Text(
            'Re-enter to confirm',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        const SizedBox(height: 24),
        CustomPinPad(
          pinLength: AppConfig.pinLength,
          onPinComplete: _onPinComplete,
        ),
      ],
    );
  }

  Widget _buildThemeStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your vibe',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Pick a theme you like. You can always change it later.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        const ThemeSelector(),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton.icon(
            onPressed: _nextStep,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All set!',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Real PIN and Ghost PIN are configured. Theme selected. Tap Finish to start.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        _buildSummaryRow(
          theme,
          icon: Icons.lock,
          title: 'Real PIN',
          value: '•' * _realPin.length,
        ),
        const SizedBox(height: 12),
        _buildSummaryRow(
          theme,
          icon: Icons.visibility_off,
          title: 'Ghost PIN',
          value: '•' * _ghostPin.length,
        ),
        const Spacer(),
        Row(
          children: [
            TextButton(
              onPressed: _previousStep,
              child: const Text('Back'),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _finishSetup,
              icon: const Icon(Icons.check_circle),
              label: const Text('Finish'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Text(title, style: theme.textTheme.bodyLarge),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            letterSpacing: 4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
