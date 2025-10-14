import 'package:flutter/cupertino.dart';
import 'package:grocery_delivery/ui/components/brand_button.dart';
import 'package:grocery_delivery/ui/components/brand_preloader.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class BrandLoadingStateWidget extends StatelessWidget {
  const BrandLoadingStateWidget({
    required this.isLoading,
    required this.isLoadingFailed,
    required this.errorText,
    required this.onRetry,
    this.showErrorIcon = true,
    this.loadingPadding = 64,
  });

  final bool isLoading;
  final bool isLoadingFailed;
  final String errorText;
  final VoidCallback? onRetry;
  final bool showErrorIcon;
  final double loadingPadding;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return BrandPreloader(
        padding: EdgeInsets.only(top: loadingPadding),
      );
    }

    if (isLoadingFailed) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 36),
            if (showErrorIcon) ...[
              const Icon(
                CupertinoIcons.exclamationmark,
                color: BrandColors.systemDestructive,
                size: 20,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              errorText,
              textAlign: TextAlign.center,
              style: BrandTypography.subheadline.copyWith(
                color: BrandColors.systemDestructive,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              BrandButton(
                label: 'Повторить',
                labelColor: BrandColors.white,
                onTap: onRetry,
              ),
            ],
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
