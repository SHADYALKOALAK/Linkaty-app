import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/helpers/nav_helper.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/my_button.dart';
import 'package:linkaty/features/auth/views/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with NavHelper {
  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AssetsApp.welcome, fit: BoxFit.cover),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 24.w,
                vertical: 52.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizations.welcome_title,
                    style: getBoldStyle(size: 20, color: Colors.white),
                  ),
                  CustomHeightSpacer(height: 16),
                  Text(
                    localizations.welcome_sup_title,
                    style: getRegularStyle(size: 14, color: AppColors.gray),
                  ),
                  CustomHeightSpacer(height: 24),
                  MyButton(
                    textButton: localizations.get_started,
                    onTap: () => jump(context, LoginScreen(), true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
