import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_delivery/main.dart';
import 'package:grocery_delivery/ui/components/brand_button.dart';
import 'package:grocery_delivery/ui/components/icon_button.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Контакты'),
      ),
      bottomNavigationBar: const BrandSeparateBottomNavigationBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BrandButton(
            onTap: () {
              launchUrlString('tel: +7 (925) 575-38-92');
            },
            label: '+7 (925) 575-38-92',
            labelColor: BrandColors.white,
            buttonColor: BrandColors.totalBlack,
            height: 48,
          ),
          const SizedBox(height: 16),
          BrandButton(
            onTap: () {
              launchUrlString('mailto: myasnoemesto@yandex.ru');
            },
            label: 'myasnoemesto@yandex.ru',
            buttonColor: BrandColors.grey200,
            height: 48,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              const Icon(
                Icons.map_outlined,
                size: 20,
                color: BrandColors.accent,
              ),
              Text(
                'Москва, Таганская ул., 31/22\nЕжедневно: 9:00 — 21:00',
                style: BrandTypography.body,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            spacing: 16,
            children: [
              BrandIconButton(
                onTap: () {
                  launchUrlString('https://t.me/myasnoe_mesto');
                },
                color: BrandColors.grey600,
                iconData: FontAwesomeIcons.telegram,
              ),
              BrandIconButton(
                onTap: () {
                  launchUrlString('https://chat.whatsapp.com/Edc6ImePTmvFuzNkn4rBQA');
                },
                color: BrandColors.grey600,
                iconData: FontAwesomeIcons.whatsapp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
