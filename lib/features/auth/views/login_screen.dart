import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/enums/enums.dart';
import 'package:linkaty/core/helpers/checker_helper.dart';
import 'package:linkaty/core/helpers/chick_data_helper.dart';
import 'package:linkaty/core/helpers/nav_helper.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/services/cache/app_preferences.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_circular_progress_indicator.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';
import 'package:linkaty/core/widgets/my_button.dart';
import 'package:linkaty/core/widgets/my_lable_text_fild.dart';
import 'package:linkaty/features/auth/providers/auth_provider.dart';
import 'package:linkaty/features/auth/services/auth_service.dart';
import 'package:linkaty/features/auth/services/user_service.dart';
import 'package:linkaty/features/auth/views/reset_password_screen.dart';
import 'package:linkaty/features/auth/views/sign_up_screen.dart';
import 'package:linkaty/features/auth/widgets/auth_heder_section.dart';
import 'package:linkaty/features/auth/widgets/bg_image_widget.dart';
import 'package:linkaty/features/main_home/views/main_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with NavHelper, CheckerHelper, ChickData {
  late TextEditingController _emailController;

  late TextEditingController _passwordController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            title: localizations.log_in_to_your_account,
            subtitle: localizations.sup_title_login,
            logoAsset: AssetsApp.logoWhite,
          ),
          loginContent(localizations),
        ],
      ),
    );
  }

  Widget loginContent(AppLocalizations localizations) {
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
                CustomHeightSpacer(height: 12),
                GestureDetector(
                  onTap:
                      () => jump(context, const ResetPasswordScreen(), false),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      localizations.did_you_forget_your_password,
                      textAlign: TextAlign.start,
                      style: getMediumStyle(size: 14, color: AppColors.font02),
                    ),
                  ),
                ),
                CustomHeightSpacer(height: 24),
                _isLoading == true
                    ? CustomCircularProgressIndicator()
                    : MyButton(
                      textButton: localizations.login,
                      onTap: () async => await signIn(localizations),
                    ),
                CustomHeightSpacer(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.create_new_account_qus,
                      style: getMediumStyle(size: 13, color: AppColors.font01),
                    ),
                    CustomWidthSpacer(width: 6),
                    GestureDetector(
                      onTap: () => jump(context, SignUpScreen(), false),
                      child: Text(
                        localizations.register_now,
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
    final email = _emailController.text.trim();
    final password = _passwordController.text;

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

    return true;
  }

  Future<void> signIn(AppLocalizations localizations) async {
    if (!_checkDataForm(localizations)) return;
    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final AuthResponse userResponse = await AuthService()
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userResponse.session == null) {
        throw Exception('Auth Error');
      }

      await AppPreferences().setter(CacheKeys.loggedIn, true);
      await AppPreferences().setter(CacheKeys.email, email);

      //  get full user for provider
      final fullUser = await UserService().getUserByEmail(email: email);

      if (context.mounted) {
        Provider.of<AuthProvider>(
          context,
          listen: false,
        ).setUser(fullUser);
        showSnackBar(
          context,
          localizations.login_success,
          AppColors.success,
        );
        jump(context, MainHomeScreen(), true);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context,
          _mapAuthError(e, localizations),
          AppColors.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _mapAuthError(dynamic e, AppLocalizations localizations) {
    final error = e.toString().toLowerCase();

    if (error.contains('invalid login credentials')) {
      return localizations.invalid_login_credentials;
    }

    if (error.contains('email not confirmed')) {
      return localizations.email_not_confirmed;
    }

    if (error.contains('user not found')) {
      return localizations.user_not_found;
    }

    if (error.contains('network')) {
      return localizations.network_error;
    }

    return localizations.unexpected_error;
  }
}
