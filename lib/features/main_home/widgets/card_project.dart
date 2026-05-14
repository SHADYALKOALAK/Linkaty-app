import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';

class CardProject extends StatefulWidget {
  final String image;
  final String title;
  final String link;

  const CardProject({
    super.key,
    required this.image,
    required this.title,
    required this.link,
  });

  @override
  State<CardProject> createState() => _CardProjectState();
}

class _CardProjectState extends State<CardProject> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border01.withOpacity(.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 95.w,
            height: 95.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.image,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return CachedNetworkImage(
                  imageUrl: 'https://placehold.net/400x400.png',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          CustomWidthSpacer(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          size: 14,
                          color: AppColors.font02,
                        ),
                      ),
                      CustomHeightSpacer(height: 8),
                      Text(
                        widget.link,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          size: 14,
                          color: AppColors.font01,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 8.w),
                  child: Container(
                    padding: EdgeInsetsDirectional.all(8.w),
                    height: 36.h,
                    width: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.gray.withOpacity(.4),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: CustomSvg(path: AssetsApp.shareProject),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
