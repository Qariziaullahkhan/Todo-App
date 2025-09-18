import 'package:flutter/material.dart';
import 'package:todo_ap/constants/resposnive.dart';

class CustomSocialButton extends StatelessWidget {
  final String label;
  final String? assetIcon; // For Image icon
  final IconData? iconData; // For Flutter built-in icons
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const CustomSocialButton({
    super.key,
    required this.label,
    this.assetIcon,
    this.iconData,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 16.h), // 🔥 Same as CustomButton
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r), // 🔥 Same rounded style
          ),
          side: backgroundColor == Colors.white
              ? const BorderSide(color: Colors.grey)
              : BorderSide.none,
        ),
        icon: assetIcon != null
            ? Image.asset(assetIcon!, height: 24.h)
            : Icon(iconData, color: textColor, size: 24.h),
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontFamily: "Lato",
            fontSize: 16.fS,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
