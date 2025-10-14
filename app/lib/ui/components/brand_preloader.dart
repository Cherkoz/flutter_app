import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class BrandPreloader extends StatelessWidget {
  const BrandPreloader({
    this.size = 60,
    this.padding = EdgeInsets.zero,
    this.strokeWidth = 3,
    this.alignment = Alignment.center,
  });

  final double size;
  final double strokeWidth;
  final EdgeInsets padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: const AlwaysStoppedAnimation<Color>(BrandColors.accent),
          ),
        ),
      ),
    );
  }
}
