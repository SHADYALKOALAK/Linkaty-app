import 'package:flutter/material.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';

class NoData extends StatelessWidget {
  final String title;
  final String suTitle;
  final String image;

  const NoData({
    super.key,
    required this.title,
    required this.suTitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomSvg(path: image),
        CustomHeightSpacer(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: getBoldStyle(size: 16, color: AppColors.font02),
        ),
        CustomHeightSpacer(height: 8),
        Text(
          suTitle,
          textAlign: TextAlign.center,
          style: getRegularStyle(size: 14, color: AppColors.font01),
        ),
      ],
    );
  }
}
