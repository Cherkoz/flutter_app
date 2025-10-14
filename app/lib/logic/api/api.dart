import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:grocery_delivery/logic/api/api_client.dart';
import 'package:grocery_delivery/logic/models/category.dart';
import 'package:grocery_delivery/logic/models/order.dart';
import 'package:grocery_delivery/logic/models/order_request.dart';
import 'package:grocery_delivery/logic/models/product.dart';
import 'package:grocery_delivery/logic/models/user.dart';
import 'package:grocery_delivery/logic/services/storage_service.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class ApiService {
  static Dio getClient() {
    final _token = StorageService.getString(key: StorageConsts.accessToken.txt);
    final options = BaseOptions(
      baseUrl: baseUrl,
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
    );
    final dio = Dio(options);
    dio.interceptors.add(
      TalkerDioLogger(
        talker: Talker(
          settings: TalkerSettings(
            enabled: true,
            maxHistoryItems: 100000,
            useConsoleLogs: true,
            useHistory: true,
          ),
          filter: CustomTalkerFilter(),
          logger: TalkerLogger(
            output: (String message) {
              final StringBuffer buffer = StringBuffer();
              final lines = message.split('\n');
              lines.forEach(buffer.writeln);
              Platform.isIOS ? lines.forEach(print) : log(buffer.toString());
            },
          ),
        ),
        settings: const TalkerDioLoggerSettings(
          printResponseData: true,
          printRequestData: true,
          printResponseHeaders: true,
          printRequestHeaders: true,
          printResponseMessage: true,
        ),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (err, handler) {
          if (err.response?.statusCode == HttpStatus.unauthorized) {
            StorageService.removeValue(key: StorageConsts.accessToken.txt);
          }
          return handler.next(err);
        },
      ),
    );
    return dio;
  }

  static Future<List<Product>> fetchAllProducts() async {
    final client = getClient();
    final res = await client.get('/products');
    final products = Product.parseListFromJson(res.data);

    return products;
  }

  static Future<List<Category>> fetchCategories() async {
    try {
      final client = getClient();
      final res = await client.get('/categories');
      final categories = Category.parseListFromJson(res.data);

      return categories;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<bool> createOrder(OrderRequest order) async {
    final client = getClient();
    final res = await client.post(
      '/orders/',
      data: order.toJson(),
    );
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> authenticate(String emailOrPhone, String password) async {
    final client = getClient();
    try {
      final res = await client.post(
        '/auth/jwt/login',
        data: {
          'username': emailOrPhone,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (res.statusCode == HttpStatus.ok) {
        await StorageService.setString(
          key: StorageConsts.accessToken.txt,
          value: res.data['access_token']!,
        );
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  static Future<bool> logout() async {
    final client = getClient();
    final res = await client.post('/auth/jwt/logout');
    if (res.statusCode == HttpStatus.ok || res.statusCode == 204) {
      await StorageService.removeValue(
        key: StorageConsts.accessToken.txt,
      );
      return true;
    }
    return false;
  }

  static Future<User?> signup({
    required String email,
    required String phone,
    required String password,
    required String name,
    required String refKey,
  }) async {
    final client = getClient();
    final res = await client.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'phone_number': phone,
        'name': name,
        if (refKey.isNotEmpty) 'refered_by': refKey,
      },
    );
    if (res.statusCode == HttpStatus.created) {
      return User.fromJson(res.data);
    }
    return null;
  }

  static Future<User?> getUser() async {
    final client = getClient();
    if (client.options.headers.isEmpty) {
      return null;
    }
    final res = await client.get('/users/me');
    if (res.statusCode == HttpStatus.ok) {
      return User.fromJson(res.data);
    }
    return null;
  }

  static Future<List<Order>?> getMyOrders() async {
    final client = getClient();
    final res = await client.get('/orders/my_orders');
    if (res.statusCode == HttpStatus.ok) {
      try {
        return Order.parseListFromJson(res.data);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

class CustomTalkerFilter extends TalkerFilter {
  static const List<String> ignoredMessages = [];

  @override
  bool filter(TalkerData item) => !ignoredMessages.any((e) => item.message?.contains(e) == true);
}
