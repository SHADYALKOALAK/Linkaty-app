import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/l10n/app_localizations.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CardProject extends StatelessWidget {
  final String image;
  final String title;
  final String link;
  final bool isEditable;
  final VoidCallback? onTapDelete;
  final VoidCallback? onTapEdit;

  const CardProject({
    super.key,
    required this.image,
    required this.title,
    required this.link,
    this.isEditable = false,
    this.onTapDelete,
    this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border01.withOpacity(.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 95.w,
            height: 95.w,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(color: Colors.grey.shade200),
              errorWidget:
                  (context, url, error) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  ),
            ),
          ),

          CustomWidthSpacer(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(size: 14, color: AppColors.font02),
                ),
                CustomHeightSpacer(height: 6),
                Text(
                  link,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(size: 13, color: AppColors.font01),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColors.gray.withOpacity(.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child:
                isEditable
                    ? PopupMenuButton<String>(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.zero,
                      icon: CustomSvg(path: AssetsApp.menuDots),
                      onSelected: (value) {
                        if (value == "edit") {
                          onTapEdit?.call();
                        } else if (value == "delete") {
                          onTapDelete?.call();
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: "edit",
                              child: Row(
                                children: [
                                  CustomSvg(path: AssetsApp.boxEdit),
                                  SizedBox(width: 8.w),
                                  Text(
                                    localizations.edit,
                                    style: getMediumStyle(
                                      size: 13,
                                      color: AppColors.font02,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Row(
                                children: [
                                  CustomSvg(path: AssetsApp.delete),
                                  SizedBox(width: 8.w),
                                  Text(
                                    localizations.delete,
                                    style: getMediumStyle(
                                      size: 13,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    )
                    : GestureDetector(
                    onTap: () async {
                      if (link.isNotEmpty) {
                        final fixedLink =
                        link.startsWith('http') ? link : 'https://$link';

                        final uri = Uri.parse(fixedLink);

                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: GestureDetector(
                        onTap: () => openLink(link),
                        child: CustomSvg(path: AssetsApp.shareProject))
                ),
          ),
        ],
      ),
    );
  }
  Future<void> openLink(String? link) async {
    if (link == null || link.isEmpty) return;

    final uri = Uri.parse(
      link.startsWith('http') ? link : 'https://$link',
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
