import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/helpers/nav_helper.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';
import 'package:linkaty/features/auth/providers/auth_provider.dart';
import 'package:linkaty/features/auth/services/auth_service.dart';
import 'package:linkaty/features/main_home/views/settings_screen.dart';
import 'package:linkaty/features/main_home/widgets/links_list.dart';
import 'package:linkaty/features/main_home/widgets/location_badge.dart';
import 'package:linkaty/features/main_home/widgets/projects_list.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with NavHelper {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                AssetsApp.headerImageProfile,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              PositionedDirectional(
                bottom: -45.w,
                start: 24.w,
                child: Container(
                  height: 90.w,
                  width: 90.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4.w),
                    image: DecorationImage(
                      image: AssetImage(AssetsApp.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              PositionedDirectional(
                top: 70.h,
                end: 24.w,
                child: Row(
                  children: [
                    _buildActionIcon(
                      icon: AssetsApp.settings,
                      onTap: () => jump(context, SettingsScreen(), false),
                    ),
                    CustomWidthSpacer(width: 16),
                    _buildActionIcon(icon: AssetsApp.shareIcon, onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
          Expanded(child: _buildContentProfile(localizations)),
        ],
      ),
    );
  }

  Widget _buildActionIcon({required String icon, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            height: 48.h,
            width: 48.h,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: CustomSvg(path: icon),
          ),
        ),
      ),
    );
  }

  Widget _buildContentProfile(AppLocalizations localizations) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Padding(
          padding: EdgeInsetsDirectional.only(
            top: 45.w + 16.h,
            start: 24.w,
            end: 24.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    auth.user?.fullName ?? '',
                    style: getBoldStyle(
                      size: 18,
                      color: AppColors.primaryNormal,
                    ),
                  ),
                  const Spacer(),
                  LocationBadge(location: auth.user?.location ?? ''),
                ],
              ),

              SizedBox(height: 8.h),

              _buildInfoRow(
                title: auth.user?.specialization ?? 'لم تحدد بعد',
                icon: AssetsApp.emploeyBag,
              ),
              CustomHeightSpacer(height: 8),
              _buildInfoRow(
                title: auth.user?.typeOfJop ?? 'لم تحدد بعد',
                icon: AssetsApp.clockIcon,
              ),
              CustomHeightSpacer(height: 8),
              Text(
                auth.user?.bio ?? 'لا يوجد نبذة تعريفية',
                style: getRegularStyle(size: 14, color: AppColors.font01),
              ),

              Divider(
                height: 24.h,
                thickness: 1.h,
                color: AppColors.border01.withOpacity(.5),
              ),

              _buildTapsProfile(localizations),
              CustomHeightSpacer(height: 24),
              Expanded(
                child:
                    selectedTab == 0 ? const ProjectsList() : const LinksList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({required String title, required String icon}) {
    return Row(
      children: [
        CustomSvg(path: icon),
        CustomWidthSpacer(width: 4),
        Text(title, style: getRegularStyle(size: 14, color: AppColors.font01)),
      ],
    );
  }

  // ================= TABS =================
  Widget _buildTapsProfile(AppLocalizations localizations) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
      width: 200.w,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.gray),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTapItem(
              onTap: () => setState(() => selectedTab = 0),
              isSelectedIndex: selectedTab == 0,
              title: localizations.projects,
            ),
          ),
          Expanded(
            child: _buildTapItem(
              onTap: () => setState(() => selectedTab = 1),
              isSelectedIndex: selectedTab == 1,
              title: localizations.links,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB ITEM =================
  Widget _buildTapItem({
    required String title,
    required Function() onTap,
    required bool isSelectedIndex,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient:
              isSelectedIndex
                  ? LinearGradient(
                    colors: [
                      AppColors.primaryNormal,
                      AppColors.secondaryNormal,
                    ],
                  )
                  : null,
        ),
        child: Text(
          title,
          style: getBoldStyle(
            size: 14,
            color: isSelectedIndex ? AppColors.white : AppColors.font01,
          ),
        ),
      ),
    );
  }
}
