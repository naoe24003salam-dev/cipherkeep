import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Secure text field with show/hide toggle, validation, and animated error messages
class SecureTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool enableShowHide;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const SecureTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.enableShowHide = true,
    this.prefixIcon,
    this.suffix,
    this.autofocus = false,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<SecureTextField> createState() => _SecureTextFieldState();
}

class _SecureTextFieldState extends State<SecureTextField> {
  bool _obscureText = true;
  String? _errorText;
  bool _hasError = false;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _validateInput(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _errorText = error;
        _hasError = error != null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscureText,
          autofocus: widget.autofocus,
          textInputAction: widget.textInputAction,
          onChanged: (value) {
            _validateInput(value);
            widget.onChanged?.call(value);
          },
          onEditingComplete: widget.onEditingComplete,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _hasError
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  )
                : null,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.suffix != null) widget.suffix!,
                if (widget.enableShowHide)
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return RotationTransition(
                          turns: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        key: ValueKey<bool>(_obscureText),
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onPressed: _toggleVisibility,
                    tooltip: _obscureText ? 'Show password' : 'Hide password',
                  ),
              ],
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
            errorText:
                _hasError ? '' : null, // Use empty string to reserve space
            errorStyle: const TextStyle(height: 0), // Hide default error text
          ),
          validator: widget.validator,
        ),
        // Custom animated error message
        if (_hasError && _errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 6),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _errorText!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
                  curve: Curves.easeOutCubic,
                )
                .shake(
                  duration: const Duration(milliseconds: 400),
                  hz: 4,
                  curve: Curves.easeInOut,
                ),
          ),
      ],
    );
  }
}
