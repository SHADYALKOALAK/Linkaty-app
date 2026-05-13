import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/theme/app_colors.dart';

class MyButton extends StatefulWidget {
  final Color? bGColor;
  final double heightButton;
  final String? textButton;
  final double textSize;
  final Color textColor;
  final Function()? onTap;

  const MyButton({
    super.key,
    this.bGColor,
    this.heightButton = 52,
    required this.textButton,
    this.textSize = 16,
    required this.onTap,
    this.textColor = Colors.white,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: widget.heightButton.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          color: widget.bGColor,
          gradient:
              widget.bGColor == null
                  ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primaryNormal,
                      AppColors.secondaryNormal,
                    ],
                  )
                  : null,
        ),
        child: Center(
          child: Text(
            widget.textButton!,
            style: TextStyle(
              fontFamily: 'ibmPlexSansArabic',
              fontWeight: FontWeight.w700,
              fontSize: widget.textSize.sp,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
