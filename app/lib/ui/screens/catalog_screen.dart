import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/bloc/categories/categories_cubit.dart';
import 'package:grocery_delivery/logic/bloc/products/products_cubit.dart';
import 'package:grocery_delivery/ui/components/category_card.dart';
import 'package:grocery_delivery/ui/components/search.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class CatalogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Каталог')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Search(
              hintText: 'Поиск категорий',
              onChanged: BlocProvider.of<CategoriesCubit>(context).searchCategories,
            ),
          ),
          Expanded(
            child: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state is! CategoriesLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }
                return RefreshIndicator(
                  color: BrandColors.accent,
                  onRefresh: () async {
                    await BlocProvider.of<CategoriesCubit>(context).getAllCategories();
                    await BlocProvider.of<ProductsCubit>(context).getAllProducts();
                  },
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    children: state.categories
                        .map((category) => CategoryCard(category: category))
                        .toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
