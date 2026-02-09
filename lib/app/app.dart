import 'package:cineghar/app/theme/app_theme.dart';
import 'package:cineghar/features/sensors/presentation/providers/sensors_providers.dart';
import 'package:cineghar/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch only the themeMode to prevent rebuilding the entire app on every sensor tick
    final themeMode = ref.watch(sensorsViewModelProvider.select((state) => state.themeMode));

    return MaterialApp(
      title: 'CineGhar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashPage(),
      restorationScopeId: 'app',
    );
  }
}



