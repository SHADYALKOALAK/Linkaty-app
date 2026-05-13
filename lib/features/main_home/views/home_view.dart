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
import 'package:linkaty/features/main_home/views/search_screen.dart';
import 'package:linkaty/features/main_home/widgets/employee_item_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with NavHelper {
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
                    Container(
                      height: 55.h,
                      width: 55.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage(AssetsApp.profileImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    CustomWidthSpacer(width: 12),
                    Column(
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
                          'فهد بن نواف',
                          style: getBoldStyle(
                            size: 16,
                            color: AppColors.primaryNormal,
                          ),
                        ),
                      ],
                    ),
                    CustomWidthSpacer(width: 12),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => jump(context, SearchScreen(), false),
                      child: CustomSvg(path: AssetsApp.searchIcon),
                    ),
                  ],
                ),
              ),
              _buildListExplore(),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildListExplore() {
  return Expanded(
    child: ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      padding: EdgeInsetsDirectional.only(
        start: 24.w,
        end: 24.w,
        top: 16.h,
        bottom: 80.h,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return EmployeeItemCard(
          employeeImage: AssetsApp.avatar,
          employeeName: 'سعيد بن محمد ال راشد',
          employeeLocation: 'السعودية',
          employeeDescription:
              'مصمم واجهات مستخدم أعمل على تصميم تجارب رقمية عصرية وسهلة الاستخدام.',
          employeeJob: 'UX/UI Designer',
        );
      },
    ),
  );
}
