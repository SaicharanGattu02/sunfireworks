import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/AppTextStyles.dart';
import '../theme/app_colors.dart';

class CustomAppButton extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color? color;
  final double? width;
  final double? height;
  final Color? textcolor;
  final VoidCallback? onPlusTap;
  final bool isLoading;
  CustomAppButton({
    Key? key,
    required this.text,
    required this.onPlusTap,
    this.color,
    this.textcolor,
    this.height,
    this.width,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width ?? w,
      height: height ?? 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: isLoading ? null : onPlusTap,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: AppTextStyles.titleSmall(Colors.black).copyWith(
                  color: textcolor ?? AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}

class CustomAppButton1 extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color? color;
  final double? width;
  final double? height;
  final Color? textcolor;
  final VoidCallback? onPlusTap;
  final bool isLoading;
  final Gradient? gradient;

  const CustomAppButton1({
    Key? key,
    required this.text,
    required this.onPlusTap,
    this.color,
    this.textcolor,
    this.height,
    this.width,
    this.isLoading = false,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = width ?? MediaQuery.of(context).size.width;

    return SizedBox(
      width: buttonWidth,
      height: height ?? 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: isLoading ? null : onPlusTap,
        child: Ink(
          decoration: BoxDecoration(
            color: gradient == null ? (color ?? Colors.blue) : null,
            gradient: gradient ??
                const LinearGradient(
                  colors: [
                    Color(0xFFFF8181),
                    Color.fromRGBO(255, 15, 15, 0.8),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: isLoading
                ?  SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 1,
              ),
            )
                : Text(
              text,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textcolor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

