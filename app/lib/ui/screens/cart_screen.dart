import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/bloc/auth/auth_cubit.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/get_it/get_it_config.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/logic/navigation/router.dart';
import 'package:grocery_delivery/ui/components/brand_button.dart';
import 'package:grocery_delivery/ui/components/product_card_cart.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: BlocBuilder<CartCubit, Map<Product, int>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return const Center(child: Text('Корзина пуста'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems.entries.toList()[index].key;
                    return ProductCardCart(product: product);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: BrandButton(
                  onTap: () {
                    if (BlocProvider.of<AuthCubit>(context).state is Authentificated) {
                      Navigator.pushNamed(context, '/checkout');
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: BrandColors.white,
                          title: Text(
                            'Для оформления заказа необходимо авторизоваться в приложении',
                            style: BrandTypography.body,
                          ),
                          actions: [
                            BrandButton(
                              onTap: () {
                                Navigator.of(context).pop();
                                getIt<AppRouter>().changeRootTab(2);
                              },
                              label: 'Ок',
                              labelColor: BrandColors.white,
                            ),
                            const SizedBox(height: 8),
                            BrandButton(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              label: 'Отмена',
                              labelColor: BrandColors.white,
                              buttonColor: BrandColors.systemDestructive,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  height: 45,
                  label: 'Оформить заказ на ${BlocProvider.of<CartCubit>(context).totalPrice} ₽',
                  labelColor: BrandColors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
