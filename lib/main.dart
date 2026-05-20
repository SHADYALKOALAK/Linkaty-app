import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/api_constants.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/services/cache/app_preferences.dart';
import 'package:linkaty/core/services/providers/language_provider.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/features/auth/providers/auth_provider.dart';
import 'package:linkaty/features/auth/views/create_new_password_screen.dart';
import 'package:linkaty/features/get_started/views/splash_screen.dart';
import 'package:linkaty/features/main_home/providers/users_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 🔥 مهم للتنقل من أي مكان (حتى من Supabase events)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize cache
  await AppPreferences().initCache;

  /// Initialize supabase
  await Supabase.initialize(
    url: ApiConstants.baseUrl,
    anonKey: ApiConstants.apiKey,
  );

  ///  listen for password recovery link
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;

    if (event == AuthChangeEvent.passwordRecovery) {
      navigatorKey.currentState?.pushNamed('/create-new-password');
    }
  });

  /// Initialize system ui
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => LanguageProvider()),
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(create: (context) => UsersProvider()),
          ],
          child: const MyMaterialApp(),
        );
      },
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, lang, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            fontFamily: 'ibmPlexSansArabic',
            primaryColor: AppColors.primaryNormal,
            splashColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.white,
            highlightColor: Colors.transparent,
          ),

          debugShowCheckedModeBanner: false,

          routes: {
            '/create-new-password': (context) =>
            const CreateNewPasswordScreen(),
          },

          home: const SplashScreen(),

          locale: Locale(lang.language),

          localizationsDelegates: AppLocalizations.localizationsDelegates,

          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
        );
      },
    );
  }
}