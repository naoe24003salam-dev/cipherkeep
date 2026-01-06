import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Custom PIN pad widget with circular buttons, haptic feedback, and animations
class CustomPinPad extends StatefulWidget {
  final int pinLength;
  final ValueChanged<String> onPinComplete;
  final VoidCallback? onDeletePressed;
  final bool obscurePin;
  final Color? buttonColor;
  final Color? textColor;
  final Color? activeColor;

  const CustomPinPad({
    super.key,
    required this.pinLength,
    required this.onPinComplete,
    this.onDeletePressed,
    this.obscurePin = true,
    this.buttonColor,
    this.textColor,
    this.activeColor,
  });

  @override
  State<CustomPinPad> createState() => _CustomPinPadState();
}

class _CustomPinPadState extends State<CustomPinPad> {
  String _currentPin = '';

  void _onNumberPressed(int number) {
    if (_currentPin.length < widget.pinLength) {
      HapticFeedback.lightImpact();
      setState(() {
        _currentPin += number.toString();
      });

      if (_currentPin.length == widget.pinLength) {
        HapticFeedback.mediumImpact();
        widget.onPinComplete(_currentPin);
        // Clear PIN after completion for next entry
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _currentPin = '';
            });
          }
        });
      }
    }
  }

  void _onDeletePressed() {
    if (_currentPin.isNotEmpty) {
      HapticFeedback.selectionClick();
      setState(() {
        _currentPin = _currentPin.substring(0, _currentPin.length - 1);
      });
      widget.onDeletePressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor =
        widget.buttonColor ?? theme.colorScheme.surfaceContainerHighest;
    final textColor = widget.textColor ?? theme.colorScheme.onSurface;
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // PIN dots display
        _buildPinDisplay(activeColor, theme),
        const SizedBox(height: 40),
        // Number pad grid
        _buildNumberPad(buttonColor, textColor),
      ],
    );
  }

  Widget _buildPinDisplay(Color activeColor, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.pinLength,
        (index) {
          final isFilled = index < _currentPin.length;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? activeColor : Colors.transparent,
                border: Border.all(
                  color: isFilled ? activeColor : theme.colorScheme.outline,
                  width: 2,
                ),
              ),
            )
                .animate(target: isFilled ? 1 : 0)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: const Duration(milliseconds: 200),
                )
                .fadeIn(duration: const Duration(milliseconds: 150)),
          );
        },
      ),
    );
  }

  Widget _buildNumberPad(Color buttonColor, Color textColor) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          // Rows 1-3 (numbers 1-9)
          for (var row = 0; row < 3; row++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var col = 1; col <= 3; col++)
                    _buildNumberButton(
                      row * 3 + col,
                      buttonColor,
                      textColor,
                    ),
                ],
              ),
            ),
          // Last row (delete, 0, empty/biometric)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDeleteButton(buttonColor, textColor),
              _buildNumberButton(0, buttonColor, textColor),
              _buildEmptyButton(), // Placeholder for symmetry
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(int number, Color buttonColor, Color textColor) {
    return Material(
      color: buttonColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () => _onNumberPressed(number),
        customBorder: const CircleBorder(),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 50 * number)).scale(
          begin: const Offset(0.8, 0.8),
          delay: Duration(milliseconds: 50 * number),
        );
  }

  Widget _buildDeleteButton(Color buttonColor, Color textColor) {
    return Material(
      color: _currentPin.isEmpty ? buttonColor.withOpacity(0.3) : buttonColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: _currentPin.isEmpty ? null : _onDeletePressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          child: Icon(
            Icons.backspace_outlined,
            color: _currentPin.isEmpty ? textColor.withOpacity(0.3) : textColor,
            size: 28,
          ),
        ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 450)).scale(
          begin: const Offset(0.8, 0.8),
          delay: const Duration(milliseconds: 450),
        );
  }

  Widget _buildEmptyButton() {
    return const SizedBox(width: 72, height: 72);
  }
}
