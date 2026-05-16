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
import 'package:linkaty/features/profile/models/link_model.dart';
import 'package:linkaty/features/profile/models/project_model.dart';
import 'package:linkaty/features/profile/services/link_service.dart';
import 'package:linkaty/features/profile/services/project_service.dart';
import 'package:provider/provider.dart';

class AddEditLinkScreen extends StatefulWidget {
  LinkModel? model;

  AddEditLinkScreen({super.key, this.model});

  @override
  State<AddEditLinkScreen> createState() => _AddEditLinkScreenState();
}

class _AddEditLinkScreenState extends State<AddEditLinkScreen>
    with ChickData, CheckerHelper {
  late TextEditingController _nameController;
  late TextEditingController _linkProjectController;

  bool _isLoading = false;

  bool get isEdit => widget.model != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.model?.name ?? '');
    _linkProjectController = TextEditingController(
      text: widget.model?.link ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _linkProjectController.dispose();
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
                      label: localizations.platform_name,
                      hintText: 'أدخل اسم المنصة',
                      isRequired: true,
                      keyboardType: TextInputType.name,
                    ),
                    CustomHeightSpacer(height: 16),
                    MyTextField(
                      controller: _linkProjectController,
                      label: localizations.platform_link,
                      hintText: 'أدخل رابط المنصة',
                      isRequired: true,
                      keyboardType: TextInputType.url,
                    ),
                    CustomHeightSpacer(height: 24),
                    _isLoading
                        ? const Center(child: CustomCircularProgressIndicator())
                        : MyButton(
                          textButton: localizations.save,
                          onTap:
                              () async =>
                                  isEdit
                                      ? await editLink(localizations)
                                      : await insertLink(localizations),
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

  bool _checkDataForm(AppLocalizations localizations) {
    if (_nameController.text.isEmpty) {
      showSnackBar(
        context,
        localizations.please_enter_the_platform_name,
        AppColors.error,
      );
      return false;
    }

    if (_linkProjectController.text.isEmpty) {
      showSnackBar(
        context,
        localizations.please_enter_the_platform_link,
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

    return true;
  }

  Future<void> insertLink(AppLocalizations localizations) async {
    if (!_checkDataForm(localizations)) return;

    setState(() => _isLoading = true);

    String? userId = Provider.of<AuthProvider>(context, listen: false).user?.id;

    try {
      if (userId == null) return;

      LinkModel link = LinkModel(
        name: _nameController.text,
        link: _linkProjectController.text,
        user_id: userId,
      );

      var result = await LinkService().createLink(link);

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

  Future<void> editLink(AppLocalizations localizations) async {
    if (!_checkDataForm(localizations)) return;

    setState(() => _isLoading = true);

    try {
      LinkModel updateLink = LinkModel(
        id: widget.model?.id ?? '',
        name: _nameController.text,
        link: _linkProjectController.text,
        user_id: widget.model?.user_id,
      );

      var result = await LinkService().updateLink(updateLink);

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
}
