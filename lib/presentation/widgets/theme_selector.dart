import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/themes/theme_data.dart';
import '../../logic/providers/theme_provider.dart';

/// Theme selector widget with horizontal scrollable previews
class ThemeSelector extends ConsumerWidget {
  final bool showLabels;
  final double previewHeight;

  const ThemeSelector({
    super.key,
    this.showLabels = true,
    this.previewHeight = 120,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    return SizedBox(
      height: previewHeight + (showLabels ? 40 : 0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: AppTheme.values.length,
        itemBuilder: (context, index) {
          final theme = AppTheme.values[index];
          final isSelected = theme == currentTheme;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _ThemePreviewCard(
              theme: theme,
              isSelected: isSelected,
              showLabel: showLabels,
              height: previewHeight,
              onTap: () => ref.read(themeProvider.notifier).setTheme(theme),
            )
                .animate(delay: Duration(milliseconds: 50 * index))
                .fadeIn(duration: const Duration(milliseconds: 300))
                .slideX(
                  begin: 0.2,
                  end: 0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                ),
          );
        },
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  final AppTheme theme;
  final bool isSelected;
  final bool showLabel;
  final double height;
  final VoidCallback onTap;

  const _ThemePreviewCard({
    required this.theme,
    required this.isSelected,
    required this.showLabel,
    required this.height,
    required this.onTap,
  });

  String _getThemeName(AppTheme theme) {
    switch (theme) {
      case AppTheme.cyberpunk:
        return 'Cyberpunk';
      case AppTheme.ocean:
        return 'Ocean';
      case AppTheme.forest:
        return 'Forest';
      case AppTheme.sunset:
        return 'Sunset';
      case AppTheme.minimal:
        return 'Minimal';
    }
  }

  ColorScheme _getColorScheme(AppTheme theme) {
    return theme.themeData.colorScheme;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = _getColorScheme(theme);
    final name = _getThemeName(theme);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: 100,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? colorScheme.primary.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: isSelected ? 12 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Stack(
                children: [
                  // Background
                  Container(
                    color: colorScheme.surface,
                  ),
                  // Color preview layers
                  Column(
                    children: [
                      // Primary color bar
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary,
                                colorScheme.primaryContainer,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Secondary color section
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Small accent circles
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildColorDot(colorScheme.secondary, 12),
                                  const SizedBox(width: 6),
                                  _buildColorDot(colorScheme.tertiary, 12),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Mini card preview
                              Container(
                                width: 70,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: colorScheme.outline.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Selection checkmark
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check,
                          color: colorScheme.onPrimary,
                          size: 18,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: const Duration(milliseconds: 200))
                          .scale(
                            begin: const Offset(0.5, 0.5),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.elasticOut,
                          ),
                    ),
                ],
              ),
            ),
          ),
          if (showLabel)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
