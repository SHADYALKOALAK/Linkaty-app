import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/helpers/checker_helper.dart';
import 'package:linkaty/core/helpers/chick_data_helper.dart';
import 'package:linkaty/core/helpers/image_picker.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/services/suabase/supabase_upload_service.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_app_bar.dart';
import 'package:linkaty/core/widgets/custom_circular_progress_indicator.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/my_button.dart';
import 'package:linkaty/core/widgets/my_lable_text_fild.dart';
import 'package:linkaty/features/auth/providers/auth_provider.dart';
import 'package:linkaty/features/profile/models/project_model.dart';
import 'package:linkaty/features/profile/services/project_service.dart';
import 'package:provider/provider.dart';

class AddEditProjectScreen extends StatefulWidget {
  ProjectModel? model;

  AddEditProjectScreen({super.key, this.model});

  @override
  State<AddEditProjectScreen> createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<AddEditProjectScreen>
    with ImagePikerHelper, ChickData, CheckerHelper {
  late TextEditingController _nameController;
  late TextEditingController _linkProjectController;
  late TextEditingController _descriptionController;

  File? _image;
  bool _isLoading = false;

  bool get isEdit => widget.model != null;
  bool _removeOldImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.model?.name ?? '');
    _linkProjectController = TextEditingController(
      text: widget.model?.link ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.model?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _linkProjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: isEdit ? localizations.edit : localizations.addANew,
              isBack: true,
            ),
            CustomHeightSpacer(height: 24),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                child: ListView(
                  children: [
                    MyTextField(
                      controller: _nameController,
                      label: localizations.nameProject,
                      hintText: 'أدخل اسم المشروع',
                      isRequired: true,
                      keyboardType: TextInputType.name,
                    ),
                    CustomHeightSpacer(height: 16),
                    MyTextField(
                      controller: _linkProjectController,
                      label: localizations.link_project,
                      hintText: 'أدخل رابط المشروع',
                      isRequired: true,
                      keyboardType: TextInputType.url,
                    ),
                    CustomHeightSpacer(height: 16),
                    MyTextField(
                      controller: _descriptionController,
                      label: localizations.description_project,
                      hintText: 'أكتب هنا ...',
                      isRequired: true,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                    ),
                    CustomHeightSpacer(height: 16),

                    (_image != null ||
                            (isEdit &&
                                widget.model?.image != null &&
                                !_removeOldImage))
                        ? Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              height: 150.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child:
                                  _image != null
                                      ? Image.file(_image!, fit: BoxFit.cover)
                                      : Image.network(
                                        widget.model!.image ?? '',
                                        fit: BoxFit.cover,
                                      ),
                            ),

                            PositionedDirectional(
                              top: 12.h,
                              start: 12.w,
                              child: GestureDetector(
                                onTap:
                                    () => setState(() {
                                      _image = null;
                                      _removeOldImage = true;
                                    }),
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomSvg(path: AssetsApp.boxDelete),
                                ),
                              ),
                            ),
                          ],
                        )
                        : Container(
                          width: double.infinity,
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: 12.h,
                            horizontal: 24.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.border01.withOpacity(.5),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.drive_folder_upload_outlined,
                                size: 24.w,
                                color: AppColors.font01,
                              ),

                              CustomHeightSpacer(height: 8),

                              Text(
                                localizations.upload_image_from_here,
                                style: getMediumStyle(
                                  size: 16,
                                  color: AppColors.font01,
                                ),
                              ),

                              CustomHeightSpacer(height: 12),

                              GestureDetector(
                                onTap: () => _picImage(),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsetsDirectional.all(6.w),
                                  height: 40.h,
                                  width: 120.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: AppColors.primaryLight,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    localizations.choose_the_image,
                                    style: getMediumStyle(
                                      size: 14,
                                      color: AppColors.primaryNormal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                    CustomHeightSpacer(height: 24),
                    _isLoading
                        ? const Center(child: CustomCircularProgressIndicator())
                        : MyButton(
                          textButton: localizations.save,
                          onTap:
                              () async =>
                                  isEdit
                                      ? await editProject(localizations)
                                      : await insertProject(localizations),
                        ),
                  ],
                ),
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
        localizations.please_enter_the_project_name,
        AppColors.error,
      );
      return false;
    }

    if (_linkProjectController.text.isEmpty) {
      showSnackBar(
        context,
        localizations.please_enter_the_project_link,
        AppColors.error,
      );
      return false;
    }

    if (!checkUrl(_linkProjectController.text)) {
      showSnackBar(
        context,
        localizations.please_enter_a_valid_link,
        AppColors.error,
      );
      return false;
    }

    if (_descriptionController.text.isEmpty) {
      showSnackBar(
        context,
        localizations.please_enter_a_project_description,
        AppColors.error,
      );
      return false;
    }

    if (!isEdit && _image == null) {
      showSnackBar(
        context,
        localizations.please_upload_the_image,
        AppColors.error,
      );
      return false;
    }

    return true;
  }

  Future<void> insertProject(AppLocalizations localizations) async {
    if (!_checkDataForm(localizations)) return;

    setState(() => _isLoading = true);

    String? userId = Provider.of<AuthProvider>(context, listen: false).user?.id;

    try {
      String? imageUrl;

      if (_image != null) {
        final uploadService = SupabaseUploadService();

        imageUrl = await uploadService.uploadFile(
          file: _image!,
          bucket: "projects",
          folder: "users",
        );
      } else if (isEdit) {
        imageUrl = widget.model?.image;
      }

      if (userId == null) return;

      ProjectModel project = ProjectModel(
        name: _nameController.text,
        link: _linkProjectController.text,
        image: imageUrl,
        description: _descriptionController.text,
        user_id: userId,
      );

      var result = await ProjectService().createProject(project);

      if (result) {
        showSnackBar(
          context,
          localizations.added_successfully,
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

  Future<void> editProject(AppLocalizations localizations) async {
    if (!_checkDataForm(localizations)) return;

    setState(() => _isLoading = true);

    try {
      String? imageUrl = widget.model?.image;

      if (_image != null) {
        final uploadService = SupabaseUploadService();

        imageUrl = await uploadService.uploadFile(
          file: _image!,
          bucket: "projects",
          folder: "users",
        );
      }

      ProjectModel updateProject = ProjectModel(
        id: widget.model?.id ?? '',
        name: _nameController.text,
        link: _linkProjectController.text,
        description: _descriptionController.text,
        user_id: widget.model?.user_id ?? '',
        image: imageUrl,
      );

      var result = await ProjectService().updateProject(updateProject);

      if (result) {
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

  Future<void> uploadImage() async {

  }
}
