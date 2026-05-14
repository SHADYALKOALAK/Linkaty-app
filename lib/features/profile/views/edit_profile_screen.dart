import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkaty/core/helpers/chick_data_helper.dart';
import 'package:linkaty/core/helpers/image_picker.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/services/suabase/supabase_upload_service.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/widgets/custom_app_bar.dart';
import 'package:linkaty/core/widgets/custom_circular_progress_indicator.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/my_button.dart';
import 'package:linkaty/core/widgets/my_lable_text_fild.dart';
import 'package:linkaty/features/auth/models/user_model.dart';
import 'package:linkaty/features/auth/providers/auth_provider.dart';
import 'package:linkaty/features/auth/services/user_service.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with ImagePikerHelper, ChickData {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _specializationController;
  late TextEditingController _typeOfJobController;
  late TextEditingController _bioController;

  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _locationController = TextEditingController();
    _specializationController = TextEditingController();
    _typeOfJobController = TextEditingController();
    _bioController = TextEditingController();

    Future.microtask(() {
      final user = Provider.of<AuthProvider>(context, listen: false).user;

      if (user != null) {
        _nameController.text = user.fullName ?? '';
        _locationController.text = user.location ?? '';
        _specializationController.text = user.specialization ?? '';
        _typeOfJobController.text = user.typeOfJop ?? '';
        _bioController.text = user.bio ?? '';
      }
    });
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
    final user = Provider.of<AuthProvider>(context).user;

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
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                children: [
                  SizedBox(height: 24),

                  GestureDetector(
                    onTap: _picImage,
                    child: Center(
                      child: Stack(
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
                                      : (user?.image != null &&
                                              user!.image!.isNotEmpty
                                          ? NetworkImage(user.image!)
                                          : const NetworkImage(
                                            "https://placehold.net/400x400.png",
                                          )),
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
                    controller: _nameController,
                    label: localizations.full_name,
                    hintText: 'أدخل اسمك كامل',
                  ),
                  CustomHeightSpacer(height: 16),

                  MyTextField(
                    controller: _locationController,
                    label: localizations.country,
                    hintText: 'أدخل الدولة',
                  ),
                  CustomHeightSpacer(height: 16),

                  MyTextField(
                    controller: _specializationController,
                    label: localizations.specialization,
                    hintText: 'أدخل التخصص',
                  ),
                  CustomHeightSpacer(height: 16),

                  MyTextField(
                    controller: _typeOfJobController,
                    label: localizations.permanent_type,
                    hintText: 'أدخل نوع الدوام',
                  ),
                  CustomHeightSpacer(height: 16),

                  MyTextField(
                    controller: _bioController,
                    label: localizations.bio,
                    hintText: 'أكتب هنا ...',
                    maxLines: 3,
                  ),
                  CustomHeightSpacer(height: 24),
                  _isLoading
                      ? const Center(child: CustomCircularProgressIndicator())
                      : MyButton(
                        textButton: localizations.save,
                        onTap: () async => await updateProfile(localizations),
                      ),
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

  bool _checkDataForm(AppLocalizations localizations) {
    if (_nameController.text.isEmpty) {
      showSnackBar(
        context,
        localizations.please_enter_your_full_name,
        AppColors.error,
      );
      return false;
    }

    if (_locationController.text.isEmpty) {
      showSnackBar(
        context,
        localizations.enter_the_your_contry,
        AppColors.error,
      );
      return false;
    }

    if (_specializationController.text.isEmpty) {
      showSnackBar(
        context,
        localizations.enter_the_your_specialization,
        AppColors.error,
      );
      return false;
    }

    if (_typeOfJobController.text.isEmpty) {
      showSnackBar(
        context,
        localizations.please_enter_your_work_type,
        AppColors.error,
      );
      return false;
    }

    if (_bioController.text.isEmpty) {
      showSnackBar(
        context,
        localizations.please_enter_your_bio,
        AppColors.error,
      );
      return false;
    }

    return true;
  }

  Future<void> updateProfile(AppLocalizations localizations) async {
    if (!_checkDataForm(localizations)) return;

    setState(() => _isLoading = true);

    try {
      final user = Provider.of<AuthProvider>(context, listen: false).user;

      String? imageUrl;

      if (_image != null) {
        final uploadService = SupabaseUploadService();

        imageUrl = await uploadService.uploadFile(
          file: _image!,
          bucket: "profiles",
          folder: "users",
        );
      }
      final updatedUser = UserModel(
        id: user?.id,
        fullName: _nameController.text,
        location: _locationController.text,
        specialization: _specializationController.text,
        typeOfJop: _typeOfJobController.text,
        bio: _bioController.text,
        email: user?.email ?? '',
        image: imageUrl ?? user?.image,
      );
      bool isUpdated = await UserService().updateUser(updatedUser);

      if (isUpdated && mounted) {
        Provider.of<AuthProvider>(
          context,
          listen: false,
        ).setUser(updatedUser);
        showSnackBar(
          context,
          localizations.data_updated_successfully,
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
