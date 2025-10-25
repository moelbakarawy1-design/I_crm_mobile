import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isLoading;
  final Widget? icon;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width ,
    this.height ,
    this.borderRadius = 4,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.isLoading = false,
    this.icon,
    this.isOutlined = false, SizedBox? child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined 
              ? Colors.transparent 
              : (backgroundColor ?? theme.primaryColor),
          foregroundColor: textColor ?? Colors.white,
          elevation: isOutlined ? 0 : 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: isOutlined 
                  ? (borderColor ?? theme.primaryColor)
                  : (borderColor ?? Colors.transparent),
              width: 1,
            ),
          ),
          disabledBackgroundColor: isOutlined 
              ? const Color(0xFF0E87F8) 
              : const Color(0xFF0E87F8),
          disabledForegroundColor: Colors.grey.shade500,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                ),
              )
            : icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon!,
                      const SizedBox(width: 8),
                      Text(
                        text,
                        style: AppTextStyle.setpoppinsWhite(fontSize:14 , fontWeight: fontWeight!)
                      ),
                    ],
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
      ),
    );
  }
}

