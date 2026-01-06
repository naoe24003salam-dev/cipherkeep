import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

/// Animated card widget with 3D flip, shimmer, gradient borders, and glassmorphism
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enableFlip;
  final Widget? backWidget;
  final bool showShimmer;
  final bool showGradientBorder;
  final Color? backgroundColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final int staggerIndex;
  final Duration staggerDelay;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enableFlip = false,
    this.backWidget,
    this.showShimmer = false,
    this.showGradientBorder = true,
    this.backgroundColor,
    this.elevation,
    this.padding,
    this.margin,
    this.borderRadius,
    this.staggerIndex = 0,
    this.staggerDelay = const Duration(milliseconds: 50),
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (widget.enableFlip && widget.backWidget != null) {
      setState(() {
        _isFlipped = !_isFlipped;
        if (_isFlipped) {
          _flipController.forward();
        } else {
          _flipController.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(16);
    final backgroundColor = widget.backgroundColor ??
        theme.colorScheme.surfaceContainerHighest.withOpacity(0.8);

    Widget cardContent = _buildCardContent(
      theme,
      borderRadius,
      backgroundColor,
    );

    // Add stagger animation
    cardContent = cardContent
        .animate()
        .fadeIn(
          delay: widget.staggerDelay * widget.staggerIndex,
          duration: const Duration(milliseconds: 300),
        )
        .slideY(
          begin: 0.2,
          end: 0,
          delay: widget.staggerDelay * widget.staggerIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: cardContent,
    );
  }

  Widget _buildCardContent(
    ThemeData theme,
    BorderRadius borderRadius,
    Color backgroundColor,
  ) {
    if (widget.enableFlip && widget.backWidget != null) {
      return _buildFlipCard(theme, borderRadius, backgroundColor);
    } else {
      return _buildStaticCard(theme, borderRadius, backgroundColor);
    }
  }

  Widget _buildFlipCard(
    ThemeData theme,
    BorderRadius borderRadius,
    Color backgroundColor,
  ) {
    return AnimatedBuilder(
      animation: _flipController,
      builder: (context, child) {
        final angle = _flipController.value * math.pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        final showBack = angle > math.pi / 2;

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: showBack
              ? Transform(
                  transform: Matrix4.identity()..rotateY(math.pi),
                  alignment: Alignment.center,
                  child: _buildCard(
                    theme,
                    borderRadius,
                    backgroundColor,
                    widget.backWidget!,
                  ),
                )
              : _buildCard(
                  theme,
                  borderRadius,
                  backgroundColor,
                  widget.child,
                ),
        );
      },
    );
  }

  Widget _buildStaticCard(
    ThemeData theme,
    BorderRadius borderRadius,
    Color backgroundColor,
  ) {
    return _buildCard(theme, borderRadius, backgroundColor, widget.child);
  }

  Widget _buildCard(
    ThemeData theme,
    BorderRadius borderRadius,
    Color backgroundColor,
    Widget content,
  ) {
    Widget card = Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: widget.elevation ?? 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            // Glassmorphism background blur effect simulation
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.surface.withOpacity(0.1),
                    theme.colorScheme.surface.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: content,
            ),
          ],
        ),
      ),
    );

    // Add gradient border if enabled
    if (widget.showGradientBorder) {
      card = Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.3),
              theme.colorScheme.secondary.withOpacity(0.3),
              theme.colorScheme.tertiary.withOpacity(0.3),
            ],
          ),
        ),
        padding: const EdgeInsets.all(1.5),
        child: card,
      );
    }

    // Add shimmer effect if enabled
    if (widget.showShimmer) {
      card = Shimmer.fromColors(
        baseColor: backgroundColor,
        highlightColor: theme.colorScheme.primary.withOpacity(0.2),
        period: const Duration(seconds: 2),
        child: card,
      );
    }

    // Add tap/long press handlers
    if (widget.onTap != null ||
        widget.onLongPress != null ||
        widget.enableFlip) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.enableFlip) {
              _toggleFlip();
            }
            widget.onTap?.call();
          },
          onLongPress: widget.onLongPress,
          borderRadius: borderRadius,
          child: card,
        ),
      );
    }

    return card;
  }
}
