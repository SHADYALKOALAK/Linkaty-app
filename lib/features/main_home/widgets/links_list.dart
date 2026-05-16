import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/widgets/custom_circular_progress_indicator.dart';
import 'package:linkaty/core/widgets/no_data.dart';
import 'package:linkaty/features/auth/models/user_model.dart';
import 'package:linkaty/features/auth/providers/auth_provider.dart';
import 'package:linkaty/features/main_home/widgets/card_link.dart';
import 'package:linkaty/features/profile/services/link_service.dart';
import 'package:provider/provider.dart';

class LinksList extends StatefulWidget {
  UserModel? publicUser;

  LinksList({super.key, this.publicUser});

  @override
  State<LinksList> createState() => _LinksListState();
}

class _LinksListState extends State<LinksList> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final userId =
        widget.publicUser?.id ?? Provider.of<AuthProvider>(context).user?.id;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: CustomCircularProgressIndicator()),
      );
    }

    return StreamBuilder(
      stream: LinkService().getAllLinksByUserId(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomCircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: NoData(
              heightOfImage: 90,
              widthOfImage: 90,
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
              heightOfImage: 90,
              widthOfImage: 90,
              title: localizations.no_links_have_been_added_yet,
              suTitle:
                  widget.publicUser != null
                      ? localizations.the_user_has_not_added_any_links_yet
                      : localizations
                          .start_by_adding_your_links_to_showcase_your_work_and_boost_your_visibility_in_the_app,
              image: AssetsApp.noData,
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).size.height * 0.18.h,
          ),
          itemCount: links.length,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            return CardLink(
              name: links[index].name ?? '',
              link: links[index].link ?? '',
            );
          },
        );
      },
    );
  }
}
