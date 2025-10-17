import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Главная',
          style: BrandTypography.h4,
        ),
      ),
      body: Center(
        child: Text(
          'Test',
          style: BrandTypography.h1,
        ),
      ),
    );
  }
}
