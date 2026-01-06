import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/routes.dart';
import 'config/themes/theme_data.dart';
import 'data/services/hive_service.dart';
import 'data/services/secure_storage_service.dart';
import 'logic/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Set portrait orientation only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize services
  final hiveService = HiveService();
  await hiveService.init();

  final secureStorage = SecureStorageService();
  secureStorage.initialize();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  runZonedGuarded(() {
    runApp(const ProviderScope(child: CipherKeepApp()));
  }, (error, stack) {
    // In production, send to crash reporting
    debugPrint('Unhandled error: $error');
  });
}

class CipherKeepApp extends ConsumerWidget {
  const CipherKeepApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CipherKeep',
      debugShowCheckedModeBanner: false,
      theme: currentTheme.themeData,
      routerConfig: router,
    );
  }
}
