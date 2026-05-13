import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/constants/assets_app.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import 'package:linkaty/core/widgets/custom_height_spacer.dart';
import 'package:linkaty/core/widgets/custom_svg.dart';
import 'package:linkaty/core/widgets/custom_width_spacer.dart';
import 'package:linkaty/features/main_home/widgets/location_badge.dart';

class EmployeeItemCard extends StatefulWidget {
  final String employeeImage;
  final String employeeName;
  final String employeeLocation;
  final String employeeJob;
  final String employeeDescription;

  const EmployeeItemCard({
    super.key,
    required this.employeeImage,
    required this.employeeName,
    required this.employeeLocation,
    required this.employeeJob,
    required this.employeeDescription,
  });

  @override
  State<EmployeeItemCard> createState() => _EmployeeItemCardState();
}

class _EmployeeItemCardState extends State<EmployeeItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 12.w,
        vertical: 16.h,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.5),
        border: Border.all(color: AppColors.border01.withOpacity(.5)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50.h,
            width: 50.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(widget.employeeImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          CustomWidthSpacer(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.employeeName,
                        style: getMediumStyle(
                          size: 16,
                          color: AppColors.font02,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    LocationBadge(location: widget.employeeLocation),
                  ],
                ),
                CustomHeightSpacer(height: 4),
                Row(
                  children: [
                    CustomSvg(
                      path: AssetsApp.emploeyBag,
                      width: 18.w,
                      height: 18.h,
                    ),

                    CustomWidthSpacer(width: 4),

                    Text(
                      widget.employeeJob,
                      style: getRegularStyle(size: 13, color: AppColors.font01),
                    ),
                  ],
                ),
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  widget.employeeDescription,
                  style: getMediumStyle(size: 14, color: AppColors.font01),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
