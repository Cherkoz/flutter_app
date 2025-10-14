import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_delivery/logic/bloc/my_orders/my_orders_cubit.dart';
import 'package:grocery_delivery/logic/bloc/products/products_cubit.dart';
import 'package:grocery_delivery/logic/models/order.dart';
import 'package:grocery_delivery/logic/models/order_request.dart';
import 'package:grocery_delivery/main.dart';
import 'package:grocery_delivery/ui/components/brand_divider.dart';
import 'package:grocery_delivery/ui/components/brand_loading_state_widget.dart';
import 'package:grocery_delivery/ui/components/brand_network_image.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';
import 'package:grocery_delivery/utils/extensions/date_time.dart';
import 'package:grocery_delivery/utils/extensions/list.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyOrdersCubit()..getOrders(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Мои заказы'),
            ),
            bottomNavigationBar: const BrandSeparateBottomNavigationBar(),
            body: BlocBuilder<MyOrdersCubit, MyOrdersState>(
              builder: (context, state) {
                if (state is MyOrdersLoaded) {
                  return ListView(
                    children: state.orders.map((order) => OrderWidget(order: order)).toList(),
                  );
                }
                return BrandLoadingStateWidget(
                  isLoading: state is MyOrdersLoading,
                  isLoadingFailed: state is MyOrdersError,
                  errorText: 'При загрузке заказов произошла ошибка',
                  onRetry: () {
                    BlocProvider.of<MyOrdersCubit>(context).getOrders();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class OrderWidget extends StatelessWidget {
  const OrderWidget({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/my_order_details',
          arguments: order,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          spacing: 8,
          children: [
            Row(
              spacing: 8,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: BrandColors.fillTertiary,
                  ),
                  child: Icon(
                    order.deliveryType == DeliveryType.courier
                        ? CupertinoIcons.home
                        : FontAwesomeIcons.shop,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      order.status.name,
                      style: BrandTypography.bodyBold,
                    ),
                    Text(
                      '${order.deliveryType.name} ${order.deliveryTime.dayMonth}',
                      style: BrandTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '+ ${order.bonusReward} бонусов',
                  style: BrandTypography.footnote.copyWith(color: BrandColors.textSecondary),
                ),
                const Spacer(),
                Text(
                  '${order.totalPrice.toInt()} ₽',
                  style: BrandTypography.bodyBold,
                ),
              ],
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: order.items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: BrandNetworkImage(
                          src: BlocProvider.of<ProductsCubit>(context)
                              .products
                              .firstWhereOrNull((p) => p.id == item.productId)
                              ?.imageUrl,
                          height: 40,
                          width: 40,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const BrandDivider(),
          ],
        ),
      ),
    );
  }
}
