import 'package:flutter/material.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/enums/enums.dart';
import 'package:linkaty/core/helpers/nav_helper.dart';
import 'package:linkaty/core/services/cache/app_preferences.dart';
import 'package:linkaty/features/get_started/views/welcome_screen.dart';
import 'package:linkaty/features/main_home/views/main_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with NavHelper {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => checkLoginStatus());
  }

  void checkLoginStatus() {
    final isLoggedIn = AppPreferences().getter(CacheKeys.loggedIn) ?? false;
    if (isLoggedIn) {
      jump(context, MainHomeScreen(), true);
    } else {
      jump(context, WelcomeScreen(), true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            PositionedDirectional(
              end: 0,
              bottom: 0,
              child: Image.asset(AssetsApp.splash),
            ),
            PositionedDirectional(child: Image.asset(AssetsApp.splash2)),
            Center(child: Image.asset(AssetsApp.logoApp)),
          ],
        ),
      ),
    );
  }
}
