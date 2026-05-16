import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/enums/enums.dart';
import 'package:linkaty/core/helpers/nav_helper.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/services/cache/app_preferences.dart';
import 'package:linkaty/core/services/providers/language_provider.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_app_bar.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';
import 'package:linkaty/features/auth/providers/auth_provider.dart';
import 'package:linkaty/features/auth/views/login_screen.dart';
import 'package:linkaty/features/profile/views/edit_profile_screen.dart';
import 'package:linkaty/features/profile/views/links_screen.dart';
import 'package:linkaty/features/profile/views/projects_screen.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with NavHelper {
  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: localizations.account_settings, isBack: true),
            CustomHeightSpacer(height: 24),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  _buildTextHeader(title: localizations.account),
                  _buildRowAction(
                    title: localizations.edit_my_data_profile,
                    icon: AssetsApp.userProfile,
                    onTap: () => jump(context, EditProfileScreen(), false),
                  ),
                  _buildTextHeader(title: localizations.my_posts),
                  _buildRowAction(
                    title: localizations.my_projects,
                    icon: AssetsApp.grid,
                    onTap: () => jump(context, ProjectsScreen(), false),
                  ),
                  _buildRowAction(
                    title: localizations.my_links,
                    icon: AssetsApp.links,
                    onTap: () => jump(context, LinksScreen(), false),
                  ),
                  _buildTextHeader(title: localizations.language),
                  _buildRowAction(
                    title: localizations.language,
                    icon: AssetsApp.language,
                    onTap:
                        () =>
                            Provider.of<LanguageProvider>(
                              context,
                              listen: false,
                            ).changeLanguage(),
                  ),
                  _buildTextHeader(title: localizations.account_settings),
                  _buildRowAction(
                    title: localizations.logout,
                    icon: AssetsApp.logout,
                    isDanger: true,
                    onTap: () => _showLogoutDialog(localizations),
                  ),
                  _buildRowAction(
                    title: localizations.delete_account,
                    icon: AssetsApp.delete,
                    isDanger: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextHeader({required String title}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 12.h),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: getRegularStyle(size: 14, color: AppColors.font01),
        ),
      ),
    );
  }

  Widget _buildRowAction({
    required String title,
    required String icon,
    required Function() onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsetsDirectional.only(bottom: 16.h),
        child: Container(
          padding: EdgeInsetsDirectional.all(12.w),
          width: double.infinity,
          height: 54.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color:
                isDanger ? AppColors.error.withOpacity(0.05) : AppColors.white,
            border: Border.all(
              color:
                  isDanger
                      ? AppColors.error.withOpacity(0.06)
                      : AppColors.border01.withOpacity(.5),
            ),
          ),
          child: Row(
            children: [
              CustomSvg(path: icon),
              CustomWidthSpacer(width: 8),
              Text(
                title,
                style: getMediumStyle(
                  size: 16,
                  color: isDanger ? AppColors.error : AppColors.font02,
                ),
              ),
              Spacer(),
              isDanger
                  ? SizedBox.shrink()
                  : Icon(
                    Icons.arrow_forward_ios,
                    size: 16.w,
                    color: AppColors.font01,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(AppLocalizations localizations) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetAnimationDuration: const Duration(milliseconds: 100),
          insetAnimationCurve: Curves.easeInOut,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSvg(path: AssetsApp.logout, width: 40.w, height: 40.h),
                CustomHeightSpacer(height: 12),
                Text(
                  localizations.logout,
                  style: getBoldStyle(size: 16, color: AppColors.font02),
                ),
                CustomHeightSpacer(height: 8),
                Text(
                  localizations.logout_confirmation,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(size: 14, color: AppColors.font01),
                ),
                CustomHeightSpacer(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: AppColors.border01),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          localizations.cancel,
                          style: getRegularStyle(
                            size: 14,
                            color: AppColors.font01,
                          ),
                        ),
                      ),
                    ),
                    CustomWidthSpacer(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          localizations.exit,
                          style: getMediumStyle(
                            size: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _logout() {
    context.read<AuthProvider>().clearUser();
    AppPreferences().setter(CacheKeys.loggedIn, false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
