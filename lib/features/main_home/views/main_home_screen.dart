import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';
import 'package:linkaty/features/main_home/views/home_view.dart';
import 'package:linkaty/features/main_home/views/profile_view.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: screens[currentIndex],

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,

      floatingActionButton: Padding(
        padding: EdgeInsetsDirectional.only(
          start: 75.w,
          end: 75.w,
          bottom: 20.h,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 22),
            child: Container(
              height: 85.h,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.30),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.30),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildBottomNavigationBarItem(
                    title: localizations.home,
                    iconPath: AssetsApp.homeSmileOutline,
                    iconSelectedPath: AssetsApp.homeSmileBold,
                    isSelected: currentIndex == 0,
                    onTap: () => setState(() => currentIndex = 0),
                  ),
                  CustomWidthSpacer(width: 16),
                  _buildBottomNavigationBarItem(
                    title: localizations.my_profile,
                    iconPath: AssetsApp.userRoundedOutline,
                    iconSelectedPath: AssetsApp.userRoundedBold,
                    isSelected: currentIndex == 1,
                    onTap: () => setState(() => currentIndex = 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildBottomNavigationBarItem({
  required String title,
  required String iconPath,
  required String iconSelectedPath,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: 75.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryNormal.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSvg(
              path: isSelected ? iconSelectedPath : iconPath,
              height: 24.h,
              width: 24.w,
            ),
            CustomHeightSpacer(height: 4),
            Text(
              title,
              style: getMediumStyle(
                size: 14,
                color: isSelected
                    ? AppColors.primaryNormal
                    : AppColors.font01,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}