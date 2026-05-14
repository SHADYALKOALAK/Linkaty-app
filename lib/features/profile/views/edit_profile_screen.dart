import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkaty/core/helpers/chick_data_helper.dart';
import 'package:linkaty/core/helpers/image_picker.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/widgets/custom_app_bar.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/my_button.dart';
import 'package:linkaty/core/widgets/my_lable_text_fild.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with ImagePikerHelper ,ChickData{
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _specializationController;
  late TextEditingController _typeOfJobController;
  late TextEditingController _bioController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _locationController = TextEditingController();
    _specializationController = TextEditingController();
    _typeOfJobController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _specializationController.dispose();
    _typeOfJobController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: localizations.edit_my_data_profile,
              isBack: true,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                children: [
                  CustomHeightSpacer(height: 24),
                  GestureDetector(
                    onTap: () {
                      _picImage();
                    },
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage:
                                  _image != null
                                      ? FileImage(_image!)
                                      : const NetworkImage(
                                        "https://placehold.net/400x400.png",
                                      ),
                            ),
                          ),

                          PositionedDirectional(
                            bottom: -1.h,
                            child: Container(
                              height: 32.h,
                              width: 32.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryNormal,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 18.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomHeightSpacer(height: 24),
                  MyTextField(
                    hintText: 'أدخل اسمك كامل',
                    controller: _nameController,
                    label: localizations.full_name,
                    isRequired: true,
                    keyboardType: TextInputType.name,
                  ),
                  CustomHeightSpacer(height: 16),
                  MyTextField(
                    hintText: 'أدخل الدولة',
                    controller: _locationController,
                    label: localizations.country,
                    isRequired: true,
                    keyboardType: TextInputType.text,
                  ),
                  CustomHeightSpacer(height: 16),
                  MyTextField(
                    hintText: 'أدخل التخصص',
                    controller: _specializationController,
                    label: localizations.specialization,
                    isRequired: true,
                    keyboardType: TextInputType.text,
                  ),
                  CustomHeightSpacer(height: 16),
                  MyTextField(
                    hintText: 'أدخل نوع الدوام',
                    controller: _typeOfJobController,
                    label: localizations.permanent_type,
                    isRequired: true,
                    keyboardType: TextInputType.text,
                  ),
                  CustomHeightSpacer(height: 16),
                  MyTextField(
                    hintText: 'أكتب هنا ...',
                    controller: _bioController,
                    label: localizations.bio,
                    isRequired: true,
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                  ),
                  CustomHeightSpacer(height: 24),
                  MyButton(textButton: localizations.save, onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _picImage() async {
    File? imagePic = await choseImage(ImageSource.gallery);

    if (imagePic != null) {
      setState(() {
        _image = imagePic;
      });
    }
  }

  // bool _checkDataForm(AppLocalizations localizations) {
  //   final fullName = _nameController.text;
  //   final location = _locationController.text;
  //   final specialization = _specializationController.text;
  //   final typeOfJop = _typeOfJobController.text;
  //   final bio = _bioController.text;
  //
  //   if (fullName.isEmpty) {
  //     showSnackBar(
  //       context,
  //       localizations.please_enter_your_full_name,
  //       AppColors.error,
  //     );
  //     return false;
  //   }
  //   if (location.isEmpty) {
  //     showSnackBar(
  //       context,
  //       localizations.please_enter_your_email,
  //       AppColors.error,
  //     );
  //     return false;
  //   }
  //
  //   if (!checkEmail(email)) {
  //     showSnackBar(
  //       context,
  //       localizations.please_enter_your_email_address_correctly,
  //       AppColors.error,
  //     );
  //     return false;
  //   }
  //
  //   if (password.isEmpty) {
  //     showSnackBar(
  //       context,
  //       localizations.please_enter_your_password,
  //       AppColors.error,
  //     );
  //     return false;
  //   }
  //
  //   if (password.length < 6) {
  //     showSnackBar(
  //       context,
  //       localizations
  //           .the_password_is_weak_it_must_contain_at_least_6_characters,
  //       AppColors.error,
  //     );
  //     return false;
  //   }
  //   if (confirmPassword.isEmpty) {
  //     showSnackBar(
  //       context,
  //       localizations.please_confirm_your_password,
  //       AppColors.error,
  //     );
  //     return false;
  //   }
  //   if (password != confirmPassword) {
  //     showSnackBar(
  //       context,
  //       localizations.please_enter_the_same_password_in_both_fields,
  //       AppColors.error,
  //     );
  //     return false;
  //   }
  //
  //   return true;
  // }
  //
  // Future<void> signUp(AppLocalizations localizations) async {
  //   if (!_checkDataForm(localizations)) return;
  //
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     final email = _emailController.text.trim();
  //     final password = _passwordController.text;
  //
  //     final AuthResponse response = await AuthService()
  //         .signUpWithEmailAndPassword(email: email, password: password);
  //
  //     final user = response.user;
  //
  //     if (user != null) {
  //       UserModel newUser = UserModel(
  //         id: user.id,
  //         fullName: _nameController.text,
  //         email: email,
  //       );
  //
  //       bool isCreated = await UserService().createUser(newUser);
  //
  //       if (isCreated && mounted) {
  //         Navigator.pop(context);
  //         showSnackBar(
  //           context,
  //           localizations.signup_success,
  //           AppColors.success,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     showSnackBar(context, e.toString(), AppColors.error);
  //     print(e.toString());
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }
}
