import 'package:flutter/material.dart';
import 'package:grocery_delivery/main.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class PaymentAndDeliveryScreen extends StatelessWidget {
  const PaymentAndDeliveryScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата и доставка'),
      ),
      bottomNavigationBar: const BrandSeparateBottomNavigationBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Никакой предоплаты!',
            style: BrandTypography.bodyBold,
          ),
          const SizedBox(height: 8),
          Text(
            'Оплачиваете курьеру при получении продуктов любым удобным для Вас способом.',
            style: BrandTypography.body,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _price('Таганка', '200₽'),
              _price('Другой район', '500₽'),
              _price('Заказ от 5 000₽', 'Бесплатно'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _price(String text, String price) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: BrandTypography.subheadline,
        ),
        Text(
          price,
          style: BrandTypography.titleMediumBold,
        ),
      ],
    );
  }
}
