import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery_delivery/firebase_options.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/bloc/auth/auth_cubit.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/bloc/categories/categories_cubit.dart';
import 'package:grocery_delivery/logic/bloc/favourites_cubit.dart';
import 'package:grocery_delivery/logic/bloc/products/products_cubit.dart';
import 'package:grocery_delivery/logic/get_it/get_it_config.dart';
import 'package:grocery_delivery/logic/navigation/router.dart';
import 'package:grocery_delivery/logic/services/storage_service.dart';
import 'package:grocery_delivery/ui/screens/cart_screen.dart';
import 'package:grocery_delivery/ui/screens/catalog_screen.dart';
import 'package:grocery_delivery/ui/screens/category_screen.dart';
import 'package:grocery_delivery/ui/screens/profile_screen.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await StorageService.init();
      initNavigatorService();
      runApp(MyApp());
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode f = FocusScope.of(context);
        if (!f.hasPrimaryFocus && f.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CartCubit()),
          BlocProvider(
            create: (context) => AuthCubit()..getUser(),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => ProductsCubit()..getAllProducts(),
            lazy: false,
          ),
          BlocProvider(create: (context) => CategoriesCubit()..getAllCategories()),
          BlocProvider(create: (context) => FavouritesCubit()..initFavourites()),
        ],
        child: OverlaySupport.global(
          child: MaterialApp(
            title: 'Доставка продуктов',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              appBarTheme: const AppBarTheme(
                backgroundColor: BrandColors.white,
                surfaceTintColor: BrandColors.white,
                elevation: 0.1,
                shadowColor: BrandColors.totalBlack,
              ),
              scaffoldBackgroundColor: BrandColors.white,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: BrandColors.white,
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: BrandColors.black,
              ),
              progressIndicatorTheme: const ProgressIndicatorThemeData(
                refreshBackgroundColor: BrandColors.white,
              ),
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru'),
            ],
            navigatorKey: getIt<AppRouter>().navigatorKey,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: '/',
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen() : super(key: getIt<AppRouter>().rootTabsKey);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late final TabController tabController = TabController(length: 5, vsync: this)
    ..addListener(() => setState(() {}));

  void changeTab(int tabIndex, {Duration? duration}) {
    tabController.animateTo(tabIndex, duration: duration);
  }

  int get curIndex => tabController.index;

  static final List<Widget> _screens = [
    const SizedBox(),
    CatalogScreen(),
    CartScreen(),
    const FavouritesCategoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: _screens,
      ),
      bottomNavigationBar: BrandBottomNavigationBar(tabController: tabController),
    );
  }
}

class BrandBottomNavigationBar extends StatelessWidget {
  const BrandBottomNavigationBar({required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: BrandColors.totalBlack.withAlpha(50),
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        selectedItemColor: BrandColors.accent,
        unselectedItemColor: BrandColors.textSecondary,
        selectedLabelStyle: BrandTypography.caption,
        unselectedLabelStyle: BrandTypography.caption,
        backgroundColor: BrandColors.white,
        showUnselectedLabels: true,
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Каталог'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
        currentIndex: tabController.index,
        onTap: tabController.animateTo,
      ),
    );
  }
}

class BrandSeparateBottomNavigationBar extends StatelessWidget {
  const BrandSeparateBottomNavigationBar();

  void onChange(int index) {
    getIt<AppRouter>().navigator.popUntil(
          ModalRoute.withName('/'),
        );

    getIt<AppRouter>().changeRootTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: BrandColors.totalBlack.withAlpha(50),
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        selectedItemColor: BrandColors.accent,
        unselectedItemColor: BrandColors.textSecondary,
        selectedLabelStyle: BrandTypography.caption,
        unselectedLabelStyle: BrandTypography.caption,
        backgroundColor: BrandColors.white,
        showUnselectedLabels: true,
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Каталог'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
        currentIndex: getIt<AppRouter>().rootTabsKey.currentState?.curIndex ?? 0,
        onTap: onChange,
      ),
    );
  }
}
