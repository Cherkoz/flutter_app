import 'package:equatable/equatable.dart';
import 'package:grocery_delivery/logic/models/order_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Order extends Equatable {
  const Order({
    required this.id,
    required this.userPhone,
    required this.deliveryAddress,
    required this.deliveryTime,
    required this.createdAt,
    required this.items,
    required this.paymentType,
    required this.deliveryType,
    required this.status,
    required this.fio,
    required this.comment,
    required this.totalPrice,
    required this.bonusesSpent,
    required this.bonusReward,
  });

  factory Order.fromJson(json) {
    return _$OrderFromJson(json);
  }

  final String id;
  final String userPhone;
  final String deliveryAddress;
  final DateTime deliveryTime;
  final DateTime createdAt;
  @JsonKey(fromJson: OrderProduct.parseListFromJson)
  final List<OrderProduct> items;
  final PaymentType paymentType;
  final DeliveryType deliveryType;
  final OrderStatus status;
  final String fio;
  final String comment;
  final double totalPrice;
  final int bonusesSpent;
  final int bonusReward;

  static List<Order> parseListFromJson(dynamic json) {
    return json.map(Order.fromJson).toList().cast<Order>();
  }

  @override
  List<Object?> get props => [];
}

enum OrderStatus {
  created,
  paid,
  processing,
  delivering,
  delivered,
  cancelled;

  String get name {
    switch (this) {
      case OrderStatus.created:
        return 'Создан';
      case OrderStatus.paid:
        return 'Оплачен';
      case OrderStatus.processing:
        return 'В процессе';
      case OrderStatus.delivering:
        return 'Доставляется';
      case OrderStatus.delivered:
        return 'Доставлен';
      case OrderStatus.cancelled:
        return 'Отменен';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.created:
        return 'Ваш заказ создан и скоро будет обработан';
      case OrderStatus.paid:
        return 'Заказ оплачен и готов к сборке';
      case OrderStatus.processing:
        return 'Ваш заказ собирается';
      case OrderStatus.delivering:
        return 'Передали Ваш заказ курьеру';
      case OrderStatus.delivered:
        return 'Заказ уже у Вас)';
      case OrderStatus.cancelled:
        return 'Заказ был отменен';
    }
  }
}
