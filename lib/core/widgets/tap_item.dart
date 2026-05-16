import 'package:flutter/material.dart';
import 'package:linkaty/core/theme/app_colors.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';

class TapItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  TapItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient:
          isSelected
              ? LinearGradient(
            colors: [
              AppColors.primaryNormal,
              AppColors.secondaryNormal,
            ],
          )
              : null,
        ),
        child: Text(
          title,
          style: getBoldStyle(
            size: 14,
            color: isSelected ? AppColors.white : AppColors.font01,
          ),
        ),
      ),
    );
  }
}
