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

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with CheckerHelper, ChickData {
  late TextEditingController _emailController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
            title: localizations.forgot_password,
            subtitle:
                localizations
                    .enter_your_email_address_and_we_will_send_you_a_link_to_reset_your_password,
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
                _isLoading == true
                    ? CustomCircularProgressIndicator()
                    : MyButton(
                      textButton: localizations.send_link,
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
    final email = _emailController.text.trim();

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
    return true;
  }

  Future<void> resetPassword(AppLocalizations localizations) async {
    final String email = _emailController.text.trim();
    if (!_checkDataForm(localizations)) return;

    setState(() => _isLoading = true);

    try {
      bool isResetPassword = await AuthService().resetPassword(emil: email);
      if (isResetPassword) {
        showSnackBar(
          context,
          localizations.a_password_reset_link_has_been_sent_to_your_email_successfully,
          AppColors.success,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      showSnackBar(context, _mapAuthError(e, localizations), AppColors.error);
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
