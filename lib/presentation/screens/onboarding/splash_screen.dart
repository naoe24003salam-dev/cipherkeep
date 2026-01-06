import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/providers/auth_provider.dart';

/// Enhanced splash screen with animations, shimmer, and gradient
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for animations to play
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check auth state and navigate accordingly
    final hasSetup = await ref.read(authProvider.notifier).hasExistingSetup();

    if (!mounted) return;

    if (!hasSetup) {
      context.go('/setup');
    } else {
      context.go('/pin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo with scale and fade animation
              _buildLogo(theme),
              const SizedBox(height: 24),
              // App name with shimmer
              _buildAppName(theme),
              const SizedBox(height: 12),
              // Tagline
              _buildTagline(theme),
              const Spacer(flex: 2),
              // Loading indicator
              _buildLoadingIndicator(theme),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
            theme.colorScheme.tertiary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.lock,
        size: 70,
        color: theme.colorScheme.onPrimary,
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
        )
        .fadeIn(
          duration: const Duration(milliseconds: 600),
        )
        .then()
        .shimmer(
          delay: const Duration(milliseconds: 1200),
          duration: const Duration(seconds: 2),
          color: theme.colorScheme.primaryContainer,
        );
  }

  Widget _buildAppName(ThemeData theme) {
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.onSurface,
      highlightColor: theme.colorScheme.primary,
      period: const Duration(seconds: 2),
      child: Text(
        'CipherKeep',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
          letterSpacing: 1.2,
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 600),
        )
        .slideY(
          begin: 0.3,
          end: 0,
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildTagline(ThemeData theme) {
    return Text(
      'Your Invisible Vault',
      style: TextStyle(
        fontSize: 16,
        color: theme.colorScheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    )
        .animate()
        .fadeIn(
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 600),
        )
        .slideY(
          begin: 0.2,
          end: 0,
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return SizedBox(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .fadeIn(
          delay: const Duration(milliseconds: 1400),
          duration: const Duration(milliseconds: 400),
        );
  }
}
