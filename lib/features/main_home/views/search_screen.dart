import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/helpers/nav_helper.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_app_bar.dart';
import 'package:linkaty/core/widgets/custom_circular_progress_indicator.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/my_lable_text_fild.dart';
import 'package:linkaty/core/widgets/no_data.dart';
import 'package:linkaty/features/auth/models/user_model.dart';
import 'package:linkaty/features/auth/services/user_service.dart';
import 'package:linkaty/features/main_home/views/public_profile_screen.dart';
import 'package:linkaty/features/main_home/widgets/employee_item_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with NavHelper {
  late TextEditingController _searchController;

  final UserService _userService = UserService();

  List<UserModel> users = [];

  bool isLoading = false;
  bool hasSearched = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _search(String value) async {
    if (value.trim().isEmpty) {
      setState(() {
        users.clear();
        hasSearched = false;
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
        hasSearched = true;
      });

      final result = await _userService.searchUsers(value.trim());

      setState(() {
        users = result;
      });
    } catch (e) {
      debugPrint("SEARCH ERROR: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: localizations.search_and_filter, isBack: true),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                children: [
                  MyTextField(
                    hintText: localizations.search_hint,
                    controller: _searchController,
                    showLabel: false,
                    prefixIcon: CustomSvg(path: AssetsApp.search),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) {
                        _debounce!.cancel();
                      }
                      _debounce = Timer(
                        const Duration(milliseconds: 500),
                        () => _search(value),
                      );
                    },
                  ),
                  CustomHeightSpacer(height: 16),
                ],
              ),
            ),

            Expanded(child: _buildResults(localizations)),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(AppLocalizations localizations) {
    if (isLoading) {
      return const Center(child: CustomCircularProgressIndicator());
    }

    if (!hasSearched) {
      return const SizedBox.shrink();
    }

    if (users.isEmpty) {
      return Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
        child: Center(
          child: NoData(
            title: localizations.no_results_found,
            suTitle: localizations.we_couldnt_find_it,
            image: AssetsApp.noData,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      itemCount: users.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final user = users[index];

        return GestureDetector(
          onTap: () => jump(context, PublicProfileScreen(user: user), false),
          child: EmployeeItemCard(
            employeeImage: user.image ?? 'https://placehold.net/400x400.png',
            employeeName: user.fullName ?? '',
            employeeLocation: user.location ?? '',
            employeeDescription: user.bio ?? '',
            employeeJob: user.specialization ?? '',
          ),
        );
      },
    );
  }
}
