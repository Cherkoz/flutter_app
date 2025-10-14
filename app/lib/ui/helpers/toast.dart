import 'package:flutter/cupertino.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';
import 'package:overlay_support/overlay_support.dart';

enum ToastPosition {
  top,
  bottom;

  bool get isTop => this == top;
  bool get isBottom => this == bottom;
}

/// Show toast notification
void showToast(
    String text, {
      IconData? prependIcon,
      bool isError = false,
      Duration duration = const Duration(milliseconds: 2000),
      ToastPosition position = ToastPosition.top,
    }) {
  showOverlay(
        (context, t) {
      return Transform.translate(
        offset: Tween<Offset>(
          begin: Offset(0, position.isBottom ? 50 : -50),
          end: const Offset(0, 0),
        ).transform(t),
        child: Opacity(
          opacity: t,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: position.isBottom ? MediaQuery.viewInsetsOf(context).bottom : null,
                  top: position.isTop ? MediaQuery.viewInsetsOf(context).top : null,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                    child: _CustomToast(
                      text: text,
                      isError: isError,
                      prependIcon: prependIcon,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    key: const ValueKey('toastsOverlay'),
    duration: duration,
    animationDuration: const Duration(milliseconds: 200),
    reverseAnimationDuration: const Duration(milliseconds: 300),
  );
}

class _CustomToast extends StatelessWidget {
  const _CustomToast({
    required this.text,
    this.prependIcon,
    this.isError = false,
  });

  final String text;
  final IconData? prependIcon;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isError
            ? BrandColors.systemDestructive.withValues(alpha: 1)
            : BrandColors.totalBlack.withValues(alpha: .8),
      ),
      child: Row(
        children: [
          if (prependIcon != null || isError)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(
                isError ? prependIcon ?? CupertinoIcons.exclamationmark : prependIcon,
                color: BrandColors.white,
              ),
            ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: BrandTypography.caption.copyWith(
                decoration: TextDecoration.none,
                color: BrandColors.white,
              ),
            ),
          ),
          if (prependIcon != null || isError) const SizedBox(width: 30),
        ],
      ),
    );
  }
}
