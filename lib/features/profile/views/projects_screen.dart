import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/widgets/custom_app_bar.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/features/main_home/widgets/card_project.dart';
import 'package:linkaty/features/profile/widgets/custom_floating_action_button.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(onTap: () {}),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: localizations.my_projects, isBack: true),

            CustomHeightSpacer(height: 24),

            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                child: ListView.separated(
                  itemCount: 2,
                  separatorBuilder:
                      (context, index) => CustomHeightSpacer(height: 16),
                  itemBuilder: (context, index) {
                    return CardProject(
                      image: '',
                      title: "title",
                      link: 'link',
                      isEditable: true,
                      onTapDelete: () {
                        print('Delete');
                      },
                      onTapEdit: () {
                        print('Edit');
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
