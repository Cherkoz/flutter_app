import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_delivery/logic/bloc/products/products_cubit.dart';
import 'package:grocery_delivery/logic/models/order.dart';
import 'package:grocery_delivery/logic/models/order_request.dart';
import 'package:grocery_delivery/main.dart';
import 'package:grocery_delivery/ui/components/brand_divider.dart';
import 'package:grocery_delivery/ui/components/brand_network_image.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';
import 'package:grocery_delivery/utils/extensions/date_time.dart';
import 'package:grocery_delivery/utils/extensions/list.dart';

class MyOrderDetailsScreen extends StatelessWidget {
  const MyOrderDetailsScreen({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мой заказ')),
      bottomNavigationBar: const BrandSeparateBottomNavigationBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            order.status.name,
            style: BrandTypography.titleMediumBold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            order.status.description,
            style: BrandTypography.subheadline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Text(
            'Детали заказа',
            style: BrandTypography.titleSmallBold,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BrandColors.fillTertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              spacing: 6,
              children: [
                if (order.deliveryType == DeliveryType.courier)
                  Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        CupertinoIcons.home,
                        size: 17,
                      ),
                      Expanded(
                        child: Text(
                          order.deliveryAddress,
                          style: BrandTypography.subheadlineBold,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        FontAwesomeIcons.shop,
                        size: 17,
                      ),
                      Expanded(
                        child: Text(
                          'Самовывоз',
                          style: BrandTypography.subheadlineBold,
                        ),
                      ),
                    ],
                  ),
                Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      CupertinoIcons.calendar,
                      size: 17,
                    ),
                    Expanded(
                      child: Text(
                        order.deliveryTime.fullDateDelivery,
                        style: BrandTypography.subheadlineBold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (order.comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BrandColors.fillTertiary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Комментарий',
                    style: BrandTypography.subheadlineBold,
                  ),
                  Text(
                    order.comment,
                    style: BrandTypography.footnote.copyWith(color: BrandColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),
          Text(
            'Состав заказа',
            style: BrandTypography.titleSmallBold,
          ),
          const SizedBox(height: 8),
          ...order.items.map((item) => ProductInOrder(item: item)).toList(),
          const SizedBox(height: 32),
          Text(
            'Итого',
            style: BrandTypography.titleSmallBold,
          ),
          const SizedBox(height: 8),
          Text(
            '${order.totalPrice.toInt()} ₽',
            style: BrandTypography.body,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class ProductInOrder extends StatelessWidget {
  const ProductInOrder({required this.item});
  final OrderProduct item;

  @override
  Widget build(BuildContext context) {
    final product = BlocProvider.of<ProductsCubit>(context)
        .products
        .firstWhereOrNull((p) => p.id == item.productId);
    if (product == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          '/product',
          arguments: product,
        ),
        child: Column(
          spacing: 8,
          children: [
            Row(
              spacing: 8,
              children: [
                BrandNetworkImage(
                  src: product.imageUrl,
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(12),
                ),
                Text(
                  product.name,
                  style: BrandTypography.subheadlineBold,
                ),
              ],
            ),
            _infoRow(
              label: 'Цена, ₽',
              trailing: item.price.toInt().toString(),
            ),
            _infoRow(
              label: 'Количество',
              trailing: item.amount.toString(),
            ),
            _infoRow(
              label: 'Стоимость, ₽',
              trailing: (item.amount * item.price.toInt()).toString(),
              boldText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required String label,
    required String trailing,
    bool boldText = false,
  }) {
    return Column(
      spacing: 6,
      children: [
        Row(
          children: [
            Text(
              label,
              style: boldText
                  ? BrandTypography.subheadline
                  : BrandTypography.footnote.copyWith(color: BrandColors.textSecondary),
            ),
            const Spacer(),
            Text(
              trailing,
              style: boldText ? BrandTypography.subheadlineBold : BrandTypography.subheadline,
            ),
          ],
        ),
        const BrandDivider(),
      ],
    );
  }
}
