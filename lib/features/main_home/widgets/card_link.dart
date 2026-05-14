import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';

class CardLink extends StatefulWidget {
  final String name;
  final String icon;
  final String link;

  const CardLink({
    super.key,
    required this.name,
    required this.icon,
    required this.link,
  });

  @override
  State<CardLink> createState() => _CardLinkState();
}

class _CardLinkState extends State<CardLink> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border01.withOpacity(.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(12.w),
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border01.withOpacity(.5)),
            ),
            child: CustomSvg(path: widget.icon),
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
                        widget.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          size: 14,
                          color: AppColors.font02,
                        ),
                      ),
                      CustomHeightSpacer(height: 4),
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
