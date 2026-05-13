import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';

class LocationBadge extends StatefulWidget {
  final String location;

  const LocationBadge({super.key, required this.location});

  @override
  State<LocationBadge> createState() => _LocationBadgeState();
}

class _LocationBadgeState extends State<LocationBadge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      padding: EdgeInsetsDirectional.symmetric(vertical: 4.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: AppColors.primaryLight.withOpacity(.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSvg(path: AssetsApp.map),

          CustomWidthSpacer(width: 4),

          Text(
            widget.location,
            style: getMediumStyle(size: 14, color: AppColors.primaryNormal),
          ),
        ],
      ),
    );
  }
}
