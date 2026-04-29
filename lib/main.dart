import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SSEMApp(),
    ),
  );
}

class SSEMApp extends ConsumerWidget {
  const SSEMApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'SSEM - Smart Study Environment Monitor',
      debugShowCheckedModeBanner: false,
      theme: SSEMTheme.lightTheme,
      darkTheme: SSEMTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
