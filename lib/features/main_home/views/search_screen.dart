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
import 'package:linkaty/core/widgets/my_lable_text_fild.dart';
import 'package:linkaty/features/main_home/models/category_tap_model.dart';
import 'package:linkaty/features/main_home/widgets/employee_item_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchEditingController;
  int selectedTag = 0;

  List<CategoryTapModel> taps = [
    CategoryTapModel(id: '1', nameCategory: 'UX / UI Designer'),
    CategoryTapModel(id: '2',nameCategory: 'Flutter Dev'),
    CategoryTapModel(id: '3',nameCategory: 'Testing'),
    CategoryTapModel(id: '4',nameCategory: 'Mobile App'),
    CategoryTapModel(id: '5',nameCategory: 'Social Media'),
  ];

  @override
  void initState() {
    super.initState();
    _searchEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: localizations.search_and_filter, isBack: true),

            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                child: Column(
                  children: [
                    MyTextField(
                      hintText: localizations.search_hint,
                      controller: _searchEditingController,
                      showLabel: false,
                      keyboardType: TextInputType.webSearch,
                      prefixIcon: CustomSvg(path: AssetsApp.search),
                    ),
                    CustomHeightSpacer(height: 16),
                    SizedBox(
                      height: 32.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: taps.length,
                        separatorBuilder:
                            (context, index) => CustomWidthSpacer(width: 8),
                        itemBuilder: (context, index) {
                          final title =
                              index == 0
                                  ? localizations.all
                                  : taps[index].nameCategory;
                          return GestureDetector(
                            onTap: () => setState(() => selectedTag = index),
                            child: _buildTag(
                              index,
                              title: title,
                              selectedTag: selectedTag,
                            ),
                          );
                        },
                      ),
                    ),
                    CustomHeightSpacer(height: 16),
                    Expanded(child: _buildListSearch()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTag(int index, {required String title, required int selectedTag}) {
  return Container(
    padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 4.h),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.r),
      border: Border.all(color: Colors.grey.withOpacity(.2)),
      gradient:
          index == selectedTag
              ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryNormal, AppColors.secondaryNormal],
              )
              : LinearGradient(
                colors: [
                  Colors.grey.withOpacity(.1),
                  Colors.grey.withOpacity(.1),
                ],
              ),
    ),
    child: Text(
      title,
      style:
          index == selectedTag
              ? getBoldStyle(size: 14, color: AppColors.white)
              : getRegularStyle(size: 14, color: AppColors.font01),
    ),
  );
}

Widget _buildListSearch() {
  return ListView.separated(
    padding: EdgeInsetsDirectional.symmetric(vertical: 16.h),
    itemCount: 2,
    separatorBuilder: (context, index) => SizedBox(height: 16.h),
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
  );
}
