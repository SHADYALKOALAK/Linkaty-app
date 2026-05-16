import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_app_bar.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';
import 'package:linkaty/core/widgets/my_button.dart';
import 'package:linkaty/core/widgets/row_info_profile.dart';
import 'package:linkaty/core/widgets/tap_item.dart';
import 'package:linkaty/features/auth/models/user_model.dart';
import 'package:linkaty/features/main_home/widgets/links_list.dart';
import 'package:linkaty/features/main_home/widgets/location_badge.dart';
import 'package:linkaty/features/main_home/widgets/projects_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicProfileScreen extends StatefulWidget {
  final UserModel user;

  const PublicProfileScreen({super.key, required this.user});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: localizations.user_deletes, isBack: true),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    const CustomHeightSpacer(height: 24),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                        height: 90.w,
                        width: 90.w,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: CachedNetworkImage(
                          imageUrl:
                              widget.user.image ??
                              'https://placehold.net/400x400.png',
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                                  const CircularProgressIndicator(),
                          errorWidget:
                              (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),

                    const CustomHeightSpacer(height: 16),

                    _buildContentProfile(localizations, widget.user),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentProfile(AppLocalizations localizations, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                Text(
                  user.fullName ?? '',
                  style: getBoldStyle(size: 18, color: AppColors.primaryNormal),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                CustomWidthSpacer(width: 8),
                if (user.isVerified ?? false)
                  CustomSvg(
                    path: AssetsApp.verifiedIcon,
                    width: 18.w,
                    height: 18.h,
                  ),
              ],
            ),
            const Spacer(),
            LocationBadge(location: user.location ?? ''),
          ],
        ),

        CustomHeightSpacer(height: 8),

        RowInfoProfile(
          title: user.specialization ?? 'لم تحدد بعد',
          icon: AssetsApp.emploeyBag,
        ),

        CustomHeightSpacer(height: 8),

        RowInfoProfile(
          title: user.typeOfJop ?? 'لم تحدد بعد',
          icon: AssetsApp.clockIcon,
        ),

        CustomHeightSpacer(height: 8),

        Text(
          user.bio ?? 'لا يوجد نبذة تعريفية',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: getRegularStyle(size: 14, color: AppColors.font01),
        ),
        CustomHeightSpacer(height: 16),
        Row(
          children: [
            Expanded(
              child: MyButton(
                bGColor: AppColors.primaryNormal,
                heightButton: 45.h,
                textSize: 14,
                textButton: localizations.send_a_massage,
                onTap: _contactUser,
              ),
            ),
            CustomWidthSpacer(width: 16),
            Expanded(
              child: MyButton(
                bGColor: AppColors.primaryLight,
                heightButton: 45.h,
                textColor: AppColors.primaryNormal,
                textSize: 14,
                textButton: localizations.share_a_user,
                onTap: _shareUser,
              ),
            ),
          ],
        ),

        Divider(
          height: 24.h,
          thickness: 1.h,
          color: AppColors.border01.withOpacity(.5),
        ),

        _buildTabsProfile(localizations),

        CustomHeightSpacer(height: 24),

        selectedTab == 0
            ? ProjectsList(publicUser: widget.user)
            : LinksList(publicUser: widget.user),
      ],
    );
  }

  Widget _buildTabsProfile(AppLocalizations localizations) {
    return Container(
      padding: EdgeInsets.all(6.w),
      width: 200.w,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.gray),
      ),
      child: Row(
        children: [
          Expanded(
            child: TapItem(
              title: localizations.projects,
              isSelected: selectedTab == 0,
              onTap: () => setState(() => selectedTab = 0),
            ),
          ),
          Expanded(
            child: TapItem(
              title: localizations.links,
              isSelected: selectedTab == 1,
              onTap: () => setState(() => selectedTab = 1),
            ),
          ),
        ],
      ),
    );
  }

  void _contactUser() {
    final email = widget.user.email;

    if (email == null || email.isEmpty) return;

    final Uri emailUri = Uri(scheme: 'mailto', path: email);

    launchUrl(emailUri);
  }

  void _shareUser() {
    final name = widget.user.fullName ?? '';
    final email = widget.user.email ?? '';
    final specialization = widget.user.specialization ?? '';
    final bio = widget.user.bio ?? '';

    Share.share(
      '👤 Profile Linkaty\n'
      'Name: $name\n'
      'Email: $email\n'
      'Specialization: $specialization\n'
      'Bio: $bio\n'
      '\n📲 Download Linkaty app',
    );
  }
}
