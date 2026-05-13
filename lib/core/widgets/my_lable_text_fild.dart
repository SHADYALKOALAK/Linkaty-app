import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkaty/core/theme/app_text_styles.dart';
import '../theme/app_colors.dart';

class MyTextField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final String hintText;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final bool showLabel;

  const MyTextField({
    super.key,
    this.label = '',
    this.isRequired = false,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.showLabel = true,
    this.maxLines = 1,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: getMediumStyle(size: 14),
              ),
              if (widget.isRequired)
                Text(
                  " *",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.error,
                  ),
                ),
            ],
          ),

        SizedBox(height: 12.h),

        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black10,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: AppColors.hint,
            ),

            filled: true,
            fillColor: AppColors.white,

            prefixIcon: widget.prefixIcon != null
                ? Padding(
              padding: EdgeInsetsDirectional.only(
                start: 12.w,
                top: 16.h,
                bottom: 16.h,
              ),
              child: widget.prefixIcon,
            )
                : null,

            prefixIconConstraints: BoxConstraints(
              minWidth: 20.w,
              minHeight: 20.h,
            ),

            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.suffixIcon != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 12.w),
                    child: widget.suffixIcon!,
                  ),

                if (widget.obscureText)
                  IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.hint,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  ),
              ],
            ),

            suffixIconConstraints: BoxConstraints(
              minWidth: 20.w,
              minHeight: 20.h,
            ),

            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 16.h,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.border01,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.primaryNormal,
                width: 1.w,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.error,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}