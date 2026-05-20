import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/helpers/checker_helper.dart';
import 'package:linkaty/core/helpers/chick_data_helper.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/widgets/custom_circular_progress_indicator.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/my_button.dart';
import 'package:linkaty/core/widgets/my_lable_text_fild.dart';
import 'package:linkaty/features/auth/services/auth_service.dart';
import 'package:linkaty/features/auth/widgets/auth_heder_section.dart';
import 'package:linkaty/features/auth/widgets/bg_image_widget.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen>
    with CheckerHelper, ChickData {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          BgImageWidget(),
          AuthHeaderSection(
            title: localizations.create_a_new_password,
            subtitle: localizations.enter_your_new_password_and_confirm_it,
            logoAsset: AssetsApp.logoWhite,
          ),
          resetPasswordContent(localizations),
        ],
      ),
    );
  }

  Widget resetPasswordContent(AppLocalizations localizations) {
    return PositionedDirectional(
      bottom: 0,
      start: 0,
      end: 0,
      top: MediaQuery.of(context).size.height * 0.32,
      child: Container(
        padding: EdgeInsetsDirectional.only(bottom: 32.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.r),
            topRight: Radius.circular(32.r),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16.h,
              children: [
                Container(
                  width: 60.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
                CustomHeightSpacer(height: 8),
                MyTextField(
                  hintText: 'أدخل كلمة المرور الجديدة',
                  controller: _passwordController,
                  label: localizations.new_password,
                  isRequired: true,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: CustomSvg(path: AssetsApp.lock),
                  obscureText: true,
                ),
                MyTextField(
                  hintText: 'أدخل تأكيد كلمة المرور',
                  controller: _confirmPasswordController,
                  label: localizations.confirm_password,
                  isRequired: true,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: CustomSvg(path: AssetsApp.lock),
                  obscureText: true,
                ),
                CustomHeightSpacer(height: 16),
                _isLoading == true
                    ? CustomCircularProgressIndicator()
                    : MyButton(
                      textButton: localizations.save,
                      onTap: () async => await resetPassword(localizations),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _checkDataForm(AppLocalizations localizations) {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty) {
      showSnackBar(
        context,
        localizations.please_enter_your_password,
        AppColors.error,
      );
      return false;
    }

    if (password.length < 6) {
      showSnackBar(
        context,
        localizations
            .the_password_is_weak_it_must_contain_at_least_6_characters,
        AppColors.error,
      );
      return false;
    }
    if (confirmPassword.isEmpty) {
      showSnackBar(
        context,
        localizations.please_confirm_your_password,
        AppColors.error,
      );
      return false;
    }
    if (password != confirmPassword) {
      showSnackBar(
        context,
        localizations.please_enter_the_same_password_in_both_fields,
        AppColors.error,
      );
      return false;
    }

    return true;
  }

  Future<void> resetPassword(AppLocalizations localizations) async {
    final String newPassword = _passwordController.text;
    if (!_checkDataForm(localizations)) return;

    setState(() => _isLoading = true);

    try {
      bool isResetPassword = await AuthService().updatePassword(
        newPassword: newPassword,
      );
      if (isResetPassword) {
        showSnackBar(
          context,
          localizations.password_updated_successfully,
          AppColors.success,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      showSnackBar(context, e.toString(), AppColors.error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
