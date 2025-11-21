import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/timeline_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const ZzzeeeApp());
}

class ZzzeeeApp extends StatelessWidget {
  const ZzzeeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zzzeee Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      // 처음 실행 시 온보딩부터 시작
      initialRoute: OnboardingScreen.routeName,
      routes: {
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        TimelineScreen.routeName: (_) => const TimelineScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
      },
    );
  }
}
