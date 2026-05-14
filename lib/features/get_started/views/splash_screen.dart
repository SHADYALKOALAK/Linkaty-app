import 'package:flutter/material.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/enums/enums.dart';
import 'package:linkaty/core/helpers/nav_helper.dart';
import 'package:linkaty/core/services/cache/app_preferences.dart';
import 'package:linkaty/features/auth/models/user_model.dart';
import 'package:linkaty/features/auth/providers/auth_provider.dart';
import 'package:linkaty/features/auth/services/auth_service.dart';
import 'package:linkaty/features/auth/services/user_service.dart';
import 'package:linkaty/features/get_started/views/welcome_screen.dart';
import 'package:linkaty/features/main_home/views/main_home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with NavHelper {

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final loggedIn =
        AppPreferences().getter(CacheKeys.loggedIn) ?? false;

    if (loggedIn) {
      final email = AppPreferences().getter(CacheKeys.email);

      if (email != null) {
        final user =
        await UserService().getUserByEmail(email: email);

        if (context.mounted) {
          Provider.of<AuthProvider>(context, listen: false)
              .setUser(user);
        }
      }
    }

    await Future.delayed(const Duration(seconds: 3));

    if (!context.mounted) return;

    jump(
      context,
      loggedIn ? const MainHomeScreen() : const WelcomeScreen(),
      true,
    );
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
