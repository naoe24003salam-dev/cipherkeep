import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../logic/providers/auth_provider.dart';
import '../logic/state/auth_state.dart';
import '../data/services/secure_storage_service.dart';
import 'package:cypherkeep/presentation/screens/splash/splash_screen.dart';
import 'package:cypherkeep/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:cypherkeep/presentation/screens/onboarding/setup_screen.dart';
import 'package:cypherkeep/presentation/screens/auth/pin_screen.dart';
import 'package:cypherkeep/presentation/screens/auth/biometric_screen.dart';
import 'package:cypherkeep/presentation/screens/vault/vault_home_screen.dart';
import 'package:cypherkeep/presentation/screens/decoy/decoy_home_screen.dart';

/// GoRouter configuration with guards and custom transitions
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  final authNotifier = ref.read(authProvider.notifier);
  final secureStorage = SecureStorageService();

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error ?? 'Unknown error'}'),
      ),
    ),
    redirect: (context, state) async {
      final location = state.matchedLocation;
      final isSplash = location == '/';
      final isOnboarding = location == '/onboarding';
      final isSetup = location == '/setup';
      final isPin = location == '/pin' || location == '/biometric';
      final isVault = location.startsWith('/vault');
      final isDecoy = location.startsWith('/decoy');

      // Check if setup completed
      final hasSetup =
          await secureStorage.isFirstLaunch().then((value) => !value);

      if (!hasSetup && !isSplash && !isOnboarding && !isSetup) {
        return '/onboarding';
      }

      if (hasSetup && (isOnboarding || isSetup)) {
        return '/pin';
      }

      if (auth is AuthAuthenticated) {
        if (isPin || isDecoy) return '/vault';
      } else if (auth is AuthDecoy) {
        if (isPin || isVault) return '/decoy';
      } else if (auth is AuthUnauthenticated) {
        if (isVault || isDecoy) return '/pin';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/setup',
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          const SetupScreen(),
        ),
      ),
      GoRoute(
        path: '/pin',
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          const PinScreen(),
        ),
      ),
      GoRoute(
        path: '/biometric',
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          const BiometricScreen(),
        ),
      ),
      GoRoute(
        path: '/vault',
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          const VaultHomeScreen(),
        ),
      ),
      GoRoute(
        path: '/decoy',
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          const DecoyHomeScreen(),
        ),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

CustomTransitionPage _buildTransitionPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
