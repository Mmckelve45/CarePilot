import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;
  final double? width;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBg = backgroundColor ?? Theme.of(context).colorScheme.primary;
    final defaultText = textColor ?? Colors.white;

    return SizedBox(
      width: width,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: defaultBg, width: 2),
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(text, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: defaultBg)),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultBg,
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(text, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: defaultText)),
            ),
    );
  }
}
