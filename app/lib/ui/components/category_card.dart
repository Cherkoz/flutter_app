import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/ui/components/brand_network_image.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.sizeOf(context).width - 48) / 2;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/category',
        arguments: category,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            BrandNetworkImage(
              src: category.imageUrl,
              width: cardWidth,
              height: cardWidth,
              borderRadius: BorderRadius.circular(12),
            ),
            Container(
              height: cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    BrandColors.totalBlack.withAlpha(50),
                    BrandColors.totalBlack.withAlpha(200),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: SizedBox(
                width: cardWidth - 16,
                child: Text(
                  category.name,
                  style: BrandTypography.titleSmallBold.copyWith(color: BrandColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavouritesCategoryCard extends StatelessWidget {
  const FavouritesCategoryCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/favourites',
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        decoration: BoxDecoration(
          color: BrandColors.fillTertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: BrandColors.white,
              ),
              child: const Icon(
                Icons.favorite,
                color: BrandColors.totalBlack,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Избранное',
              style: BrandTypography.body,
            ),
          ],
        ),
      ),
    );
  }
}
