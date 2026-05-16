import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/helpers/chick_data_helper.dart';
import 'package:linkaty/core/helpers/nav_helper.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_circular_progress_indicator.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';
import 'package:linkaty/core/widgets/no_data.dart';
import 'package:linkaty/features/auth/models/user_model.dart';
import 'package:linkaty/features/auth/providers/auth_provider.dart';
import 'package:linkaty/features/auth/services/user_service.dart';
import 'package:linkaty/features/main_home/providers/users_provider.dart';
import 'package:linkaty/features/main_home/views/profile_view.dart';
import 'package:linkaty/features/main_home/views/public_profile_screen.dart';
import 'package:linkaty/features/main_home/views/search_screen.dart';
import 'package:linkaty/features/main_home/widgets/employee_item_card.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with NavHelper, ChickData {
  @override
  void initState() {
    Future.microtask(() {
      context.read<UsersProvider>().getUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return SafeArea(
      child: Stack(
        children: [
          PositionedDirectional(
            top: -50.h,
            start: 0,
            child: CustomSvg(path: AssetsApp.patternsApp),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Row(
                  children: [
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return Container(
                          height: 55.h,
                          width: 55.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image:
                                  (auth.user?.image != null &&
                                          auth.user!.image!.isNotEmpty)
                                      ? NetworkImage(auth.user!.image!)
                                      : const AssetImage(AssetsApp.profileImage)
                                          as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    CustomWidthSpacer(width: 12),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.we_are_happy_to_have_you_with_us,
                              style: getRegularStyle(
                                size: 14,
                                color: AppColors.font01,
                              ),
                            ),
                            Text(
                              auth.user?.fullName ?? '',
                              style: getBoldStyle(
                                size: 16,
                                color: AppColors.primaryNormal,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    CustomWidthSpacer(width: 12),

                    const Spacer(),

                    GestureDetector(
                      onTap: () => jump(context, const SearchScreen(), false),
                      child: CustomSvg(path: AssetsApp.searchIcon),
                    ),
                  ],
                ),
              ),

              Expanded(child: _buildListExplore(localizations)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListExplore(AppLocalizations localizations) {
    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.users.isEmpty) {
          return Center(child: CustomCircularProgressIndicator());
        }

        if (provider.error != null && provider.users.isEmpty) {
          return NoData(
            title: localizations.something_went_wrong,
            suTitle:
                localizations
                    .please_check_your_internet_connection_and_try_again,
            image: AssetsApp.noData,
          );
        }
        if (provider.users.isEmpty) {
          return NoData(
            title: localizations.no_people_to_show,
            suTitle:
                localizations
                    .user_profiles_will_appear_here_once_they_become_available,
            image: AssetsApp.noData,
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryNormal,
          backgroundColor: AppColors.primaryLight,

          onRefresh: () async {
            await context.read<UsersProvider>().getUsers(refresh: true);
            showSnackBar(
              context,
              localizations.data_updated_successfully,
              AppColors.success,
            );
          },

          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 16.h),

            padding: EdgeInsetsDirectional.only(
              start: 24.w,
              end: 24.h,
              top: 16.h,
              bottom: MediaQuery.of(context).size.height * 0.18,
            ),
            itemCount: provider.users.length,
            itemBuilder: (context, index) {
              final user = provider.users[index];

              return GestureDetector(
                onTap: () => jump(context, PublicProfileScreen(user: user), false),
                child: EmployeeItemCard(
                  employeeImage: user.image ?? '',
                  employeeName: user.fullName ?? '',
                  employeeLocation: user.location ?? '',
                  employeeDescription: user.bio ?? '',
                  employeeJob: user.specialization ?? '',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
