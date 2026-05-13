import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  final bool isBack;

  const CustomAppBar({super.key, required this.title, required this.isBack});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border01.withOpacity(.6),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => widget.isBack ? Navigator.pop(context) : null,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                color: AppColors.gray,
              ),
              child: Icon(Icons.arrow_back_outlined, color: AppColors.font02),
            ),
          ),

          CustomWidthSpacer(width: 12),

          Text(
            widget.title,
            style: getSemiBoldStyle(size: 16, color: AppColors.font01),
          ),
        ],
      ),
    );
  }
}
