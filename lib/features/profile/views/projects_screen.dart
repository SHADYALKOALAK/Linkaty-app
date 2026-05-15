import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/helpers/nav_helper.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/services/suabase/supabase_upload_service.dart';
import 'package:linkaty/core/widgets/custom_app_bar.dart';
import 'package:linkaty/core/widgets/custom_circular_progress_indicator.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/no_data.dart';
import 'package:linkaty/features/auth/providers/auth_provider.dart';
import 'package:linkaty/features/main_home/widgets/card_project.dart';
import 'package:linkaty/features/profile/services/project_service.dart';
import 'package:linkaty/features/profile/views/add_edit_project_screen.dart';
import 'package:linkaty/features/profile/widgets/custom_floating_action_button.dart';
import 'package:provider/provider.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> with NavHelper {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final userId = Provider.of<AuthProvider>(context).user?.id;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: CustomCircularProgressIndicator()),
      );
    }

    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(
        onTap: () => jump(context, AddEditProjectScreen(), false),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: localizations.my_projects, isBack: true),
            CustomHeightSpacer(height: 24),
            Expanded(
              child: StreamBuilder(
                stream: ProjectService().getAllProjectsByUserId(userId: userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CustomCircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: NoData(
                        title: localizations.network_error,
                        suTitle:
                            localizations
                                .please_check_your_internet_connection_and_try_again,
                        image: AssetsApp.noData,
                      ),
                    );
                  }

                  final projects = snapshot.data ?? [];

                  if (projects.isEmpty) {
                    return Center(
                      child: NoData(
                        title: localizations.no_projects_have_been_added_yet,
                        suTitle:
                            localizations
                                .start_by_adding_your_projects_to_showcase_your_work_and_boost_your_visibility_in_the_app,
                        image: AssetsApp.noData,
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                    child: ListView.separated(
                      itemCount: projects.length,
                      separatorBuilder:
                          (context, index) => CustomHeightSpacer(height: 16),
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return CardProject(
                          image: project.image ?? '',
                          title: project.name ?? '',
                          link: project.link ?? '',
                          isEditable: true,

                          onTapDelete: () async {
                            final imageUrl = project.image;
                            final id = project.id;
                            if (id == null) return;
                            final success = await ProjectService()
                                .deleteProject(id: id);

                            if (success &&
                                imageUrl != null &&
                                imageUrl.isNotEmpty) {
                              final path = SupabaseUploadService()
                                  .extractPathFromUrl(imageUrl, 'projects');
                              if (path.isNotEmpty) {
                                await SupabaseUploadService().deleteFile(
                                  bucket: 'projects',
                                  filePath: path,
                                );
                              }
                            }
                            setState(() {
                              projects.removeWhere((e) => e.id == id);
                            });
                          },
                          onTapEdit: () {
                            jump(
                              context,
                              AddEditProjectScreen(model: project),
                              false,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
