import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/helpers/checker_helper.dart';
import 'package:linkaty/core/helpers/chick_data_helper.dart';
import 'package:linkaty/core/helpers/nav_helper.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_circular_progress_indicator.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';
import 'package:linkaty/core/widgets/my_button.dart';
import 'package:linkaty/core/widgets/my_lable_text_fild.dart';
import 'package:linkaty/features/auth/models/user_model.dart';
import 'package:linkaty/features/auth/services/auth_service.dart';
import 'package:linkaty/features/auth/services/user_service.dart';
import 'package:linkaty/features/auth/widgets/auth_heder_section.dart';
import 'package:linkaty/features/auth/widgets/bg_image_widget.dart';
import 'package:supabase/supabase.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with NavHelper, CheckerHelper, ChickData {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
            title: localizations.create_new_account,
            subtitle: localizations.sup_title_sgin_up,
            logoAsset: AssetsApp.logoWhite,
          ),
          signUpContent(localizations),
        ],
      ),
    );
  }

  Widget signUpContent(AppLocalizations localizations) {
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
              children: [
                CustomHeightSpacer(height: 12),
                Container(
                  width: 60.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
                CustomHeightSpacer(height: 24),
                MyTextField(
                  hintText: 'أدخل اسمك كامل',
                  controller: _nameController,
                  label: localizations.full_name,
                  isRequired: true,
                  keyboardType: TextInputType.name,
                  prefixIcon: CustomSvg(path: AssetsApp.userCircle),
                ),
                CustomHeightSpacer(height: 16),
                MyTextField(
                  hintText: 'أدخل بريدك الإلكتروني',
                  controller: _emailController,
                  label: localizations.email,
                  isRequired: true,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: CustomSvg(path: AssetsApp.email),
                ),
                CustomHeightSpacer(height: 16),
                MyTextField(
                  hintText: 'أدخل كلمة المرور الخاصة بك',
                  controller: _passwordController,
                  label: localizations.password,
                  isRequired: true,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: CustomSvg(path: AssetsApp.lock),
                  obscureText: true,
                ),
                CustomHeightSpacer(height: 16),
                MyTextField(
                  hintText: 'أدخل تأكيد كلمة المرور',
                  controller: _confirmPasswordController,
                  label: localizations.confirm_password,
                  isRequired: true,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: CustomSvg(path: AssetsApp.lock),
                  obscureText: true,
                ),
                CustomHeightSpacer(height: 24),
                _isLoading == true
                    ? const CustomCircularProgressIndicator()
                    : MyButton(
                      textButton: localizations.create_new_account,
                      onTap: () async => await signUp(localizations),
                    ),
                CustomHeightSpacer(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.have_you_had_an_account_before_qus,
                      style: getMediumStyle(size: 13, color: AppColors.font01),
                    ),
                    CustomWidthSpacer(width: 6),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        localizations.login,
                        style: getSemiBoldStyle(
                          size: 14,
                          color: AppColors.primaryNormal,
                        ).copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _checkDataForm(AppLocalizations localizations) {
    final fullName = _nameController.text;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty) {
      showSnackBar(
        context,
        localizations.please_enter_your_full_name,
        AppColors.error,
      );
      return false;
    }
    if (email.isEmpty) {
      showSnackBar(
        context,
        localizations.please_enter_your_email,
        AppColors.error,
      );
      return false;
    }

    if (!checkEmail(email)) {
      showSnackBar(
        context,
        localizations.please_enter_your_email_address_correctly,
        AppColors.error,
      );
      return false;
    }

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

  Future<void> signUp(AppLocalizations localizations) async {
    if (!_checkDataForm(localizations)) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final AuthResponse response = await AuthService()
          .signUpWithEmailAndPassword(email: email, password: password);

      final user = response.user;

      if (user != null) {
        UserModel newUser = UserModel(
          id: user.id,
          fullName: _nameController.text,
          email: email,
          is_profile_active: false,
          isVerified: false,
        );

        bool isCreated = await UserService().createUser(newUser);

        if (isCreated && mounted) {
          Navigator.pop(context);
          showSnackBar(
            context,
            localizations.signup_success,
            AppColors.success,
          );
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString(), AppColors.error);
      print(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
