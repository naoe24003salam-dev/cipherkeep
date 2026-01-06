import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum BiometricButtonState {
  idle,
  authenticating,
  success,
  failure,
}

/// Biometric button with pulse animation and multiple states
class BiometricButton extends StatefulWidget {
  final VoidCallback onPressed;
  final BiometricButtonState state;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final bool useFaceId;

  const BiometricButton({
    super.key,
    required this.onPressed,
    this.state = BiometricButtonState.idle,
    this.size = 64,
    this.color,
    this.backgroundColor,
    this.useFaceId = false,
  });

  @override
  State<BiometricButton> createState() => _BiometricButtonState();
}

class _BiometricButtonState extends State<BiometricButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    if (widget.state == BiometricButtonState.authenticating) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(BiometricButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state != oldWidget.state) {
      if (widget.state == BiometricButtonState.authenticating) {
        _pulseController.repeat();
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  IconData _getIcon() {
    switch (widget.state) {
      case BiometricButtonState.idle:
      case BiometricButtonState.authenticating:
        return widget.useFaceId ? Icons.face : Icons.fingerprint;
      case BiometricButtonState.success:
        return Icons.check_circle;
      case BiometricButtonState.failure:
        return Icons.error;
    }
  }

  Color _getColor(ThemeData theme) {
    if (widget.color != null) return widget.color!;

    switch (widget.state) {
      case BiometricButtonState.idle:
      case BiometricButtonState.authenticating:
        return theme.colorScheme.primary;
      case BiometricButtonState.success:
        return Colors.green;
      case BiometricButtonState.failure:
        return theme.colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor(theme);
    final backgroundColor =
        widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest;

    return GestureDetector(
      onTap:
          widget.state == BiometricButtonState.idle ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring for authenticating state
              if (widget.state == BiometricButtonState.authenticating)
                Container(
                  width: widget.size + (30 * _pulseController.value),
                  height: widget.size + (30 * _pulseController.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(1 - _pulseController.value),
                      width: 2,
                    ),
                  ),
                ),
              // Button
              child!,
            ],
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: widget.state == BiometricButtonState.authenticating
                    ? 16
                    : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              _getIcon(),
              key: ValueKey<BiometricButtonState>(widget.state),
              color: color,
              size: widget.size * 0.5,
            ),
          ),
        )
            .animate(
                target: widget.state == BiometricButtonState.failure ? 1 : 0)
            .shake(
              duration: const Duration(milliseconds: 400),
              hz: 5,
              curve: Curves.easeInOut,
            ),
      ),
    );
  }
}
