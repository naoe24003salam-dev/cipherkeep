import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum PasswordStrength {
  weak,
  fair,
  good,
  strong,
}

/// Password strength indicator with 4-segment bar and color progression
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final bool showLabel;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.showLabel = true,
  });

  /// Calculate password strength based on various criteria
  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.length >= 16) score++;

    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) score++; // Lowercase
    if (password.contains(RegExp(r'[A-Z]'))) score++; // Uppercase
    if (password.contains(RegExp(r'[0-9]'))) score++; // Numbers
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      score++; // Special chars
    }

    // Bonus for mixed character types
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    final typesCount = [hasLower, hasUpper, hasDigit, hasSpecial]
        .where((element) => element)
        .length;

    if (typesCount >= 3) score++;
    if (typesCount == 4) score++;

    // Penalty for common patterns
    if (password.toLowerCase().contains('password')) score -= 2;
    if (password.contains('123')) score -= 1;
    if (password.contains('abc')) score -= 1;

    // Map score to strength
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.fair;
    if (score <= 6) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  Color _getColor(PasswordStrength strength, ThemeData theme) {
    switch (strength) {
      case PasswordStrength.weak:
        return theme.colorScheme.error; // Red
      case PasswordStrength.fair:
        return Colors.orange; // Orange
      case PasswordStrength.good:
        return Colors.yellow.shade700; // Yellow
      case PasswordStrength.strong:
        return Colors.green; // Green
    }
  }

  String _getLabel(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  int _getSegmentCount(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.fair:
        return 2;
      case PasswordStrength.good:
        return 3;
      case PasswordStrength.strong:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strength = _calculateStrength(password);
    final color = _getColor(strength, theme);
    final label = _getLabel(strength);
    final activeSegments = _getSegmentCount(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 4-segment strength bar
        Row(
          children: List.generate(4, (index) {
            final isActive = index < activeSegments;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < 3 ? 6 : 0,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive
                        ? color
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
                    .animate(target: isActive ? 1 : 0)
                    .fadeIn(
                      duration: const Duration(milliseconds: 200),
                    )
                    .scaleX(
                      begin: 0.8,
                      end: 1.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                    ),
              ),
            );
          }),
        ),
        // Strength label
        if (showLabel && password.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Password strength: $label',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 200))
                .slideX(
                  begin: -0.1,
                  end: 0,
                  duration: const Duration(milliseconds: 200),
                ),
          ),
      ],
    );
  }
}

/// Static method to check if password meets minimum strength
bool isPasswordStrong(String password) {
  final indicator = PasswordStrengthIndicator(password: password);
  final strength = indicator._calculateStrength(password);
  return strength == PasswordStrength.good ||
      strength == PasswordStrength.strong;
}
