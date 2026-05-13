import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';

class AuthHeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoAsset;

  const AuthHeaderSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: 0,
      end: 0,
      top: 52.h,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(logoAsset),
            Text(title, style: getSemiBoldStyle(size: 18, color: Colors.white)),
            CustomHeightSpacer(height: 16),
            Text(
              subtitle,
              style: getRegularStyle(size: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
