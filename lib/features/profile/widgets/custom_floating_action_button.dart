import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/theme/app_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Function() onTap;

  const CustomFloatingActionButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55.w,
        height: 55.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            colors: [AppColors.primaryNormal, AppColors.secondaryNormal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
