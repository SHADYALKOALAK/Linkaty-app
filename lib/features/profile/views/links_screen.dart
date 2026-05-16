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
import 'package:linkaty/features/main_home/widgets/card_link.dart';
import 'package:linkaty/features/main_home/widgets/card_project.dart';
import 'package:linkaty/features/profile/services/link_service.dart';
import 'package:linkaty/features/profile/services/project_service.dart';
import 'package:linkaty/features/profile/views/add_edit_link_screen.dart';
import 'package:linkaty/features/profile/views/add_edit_project_screen.dart';
import 'package:linkaty/features/profile/widgets/custom_floating_action_button.dart';
import 'package:provider/provider.dart';

class LinksScreen extends StatefulWidget {
  const LinksScreen({super.key});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> with NavHelper {
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
        onTap: () => jump(context, AddEditLinkScreen(), false),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: localizations.my_links, isBack: true),
            CustomHeightSpacer(height: 24),
            Expanded(
              child: StreamBuilder(
                stream: LinkService().getAllLinksByUserId(userId: userId),
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

                  final links = snapshot.data ?? [];

                  if (links.isEmpty) {
                    return Center(
                      child: NoData(
                        title: localizations.no_links_have_been_added_yet,
                        suTitle:
                            localizations
                                .start_by_adding_your_links_to_showcase_your_work_and_boost_your_visibility_in_the_app,
                        image: AssetsApp.noData,
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                    child: ListView.separated(
                      itemCount: links.length,
                      separatorBuilder:
                          (context, index) => CustomHeightSpacer(height: 16),
                      itemBuilder: (context, index) {
                        final link = links[index];
                        return CardLink(
                          name: link.name ?? '',
                          link: link.link ?? '',
                          isEditable: true,

                          onTapDelete: () async {
                            final id = link.id;
                            if (id == null) return;
                            await LinkService().deleteLink(id: id);
                            setState(() {
                              links.removeWhere((e) => e.id == id);
                            });
                          },
                          onTapEdit: () {
                            jump(
                              context,
                              AddEditLinkScreen(model: link),
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
