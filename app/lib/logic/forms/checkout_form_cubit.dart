import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/bloc/auth/auth_cubit.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/models/order_request.dart';
import 'package:grocery_delivery/logic/models/user.dart';
import 'package:grocery_delivery/ui/helpers/toast.dart';
import 'package:grocery_delivery/utils/helper_functions.dart';

class CheckoutFormCubit extends FormCubit {
  CheckoutFormCubit(this.cartCubit, this.authCubit) {
    User? user;
    int? initialBonuses;
    const double maxBonusPercent = 0.1;
    if (authCubit.state is Authentificated) {
      user = (authCubit.state as Authentificated).user;
      final maxBonuses = (cartCubit.totalPrice * maxBonusPercent).floor();
      initialBonuses = user.bonuses >= maxBonuses ? maxBonuses : user.bonuses;
    }
    fio = FieldCubit<String>(
      initalValue: user?.name ?? '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
        MinLengthValidation(
          5,
          'ФИО не может быть короче 5 символов',
        ),
      ],
    );
    phone = FieldCubit<String>(
      initalValue: user?.phoneNumber ?? '',
      validations: [
        PhoneStringValidation(11, 'Некорректно введен номер телефона'),
      ],
    );
    street = FieldCubit<String>(
      initalValue: '',
    );
    building = FieldCubit<String>(
      initalValue: '',
    );
    entrance = FieldCubit<String>(initalValue: '');
    floor = FieldCubit<String>(initalValue: '');
    apartment = FieldCubit<String>(initalValue: '');
    dateCubit = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
      ],
    );
    date = FieldCubit<DateTime?>(initalValue: null);
    timeCubit = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
      ],
    );
    time = FieldCubit<TimeOfDay?>(initalValue: null);
    comment = FieldCubit<String>(initalValue: '');
    deliveryType = FieldCubit<DeliveryType?>(
      initalValue: null,
      validations: [
        RequiredNotNullValidation('Это поле обязательное'),
      ],
    );
    paymentType = FieldCubit<PaymentType?>(
      initalValue: null,
      validations: [
        RequiredNotNullValidation('Это поле обязательное'),
      ],
    );
    bonuses = FieldCubit<String>(initalValue: initialBonuses?.toString() ?? '0');

    addFields([
      fio,
      phone,
      street,
      building,
      entrance,
      floor,
      apartment,
      dateCubit,
      timeCubit,
      comment,
      deliveryType,
      paymentType,
      bonuses,
    ]);
  }

  final CartCubit cartCubit;
  final AuthCubit authCubit;

  late FieldCubit<String> fio;
  late FieldCubit<String> phone;
  late FieldCubit<String> street;
  late FieldCubit<String> building;
  late FieldCubit<String> entrance;
  late FieldCubit<String> floor;
  late FieldCubit<String> apartment;
  late FieldCubit<String> dateCubit;
  late FieldCubit<DateTime?> date;
  late FieldCubit<String> timeCubit;
  late FieldCubit<TimeOfDay?> time;
  late FieldCubit<String> comment;
  late FieldCubit<DeliveryType?> deliveryType;
  late FieldCubit<PaymentType?> paymentType;
  late FieldCubit<String> bonuses;

  @override
  FutureOr<bool> asyncValidation() async {
    final deliveryTime = uniteTime(date: date.state.value!, time: time.state.value!);
    if (deliveryType.state.value == DeliveryType.courier) {
      if (street.state.value.isEmpty) {
        street.setError('Это поле обязательно');
        return false;
      }

      if (building.state.value.isEmpty) {
        building.setError('Это поле обязательно');
        return false;
      }
    }
    final address = uniteAddress(
      street: street.state.value,
      building: building.state.value,
      entrance: entrance.state.value,
      floor: floor.state.value,
      apartment: apartment.state.value,
    );
    final orderRequest = OrderRequest(
      userPhone: phone.state.value,
      deliveryAddress: address,
      deliveryTime: deliveryTime,
      items: cartCubit.state.entries
          .map(
            (entry) => OrderProduct(
              productId: entry.key.id,
              amount: entry.value,
              price: entry.key.price,
            ),
          )
          .toList(),
      paymentType: paymentType.state.value!,
      deliveryType: deliveryType.state.value!,
      fio: fio.state.value,
      comment: comment.state.value,
      useBonuses: bonuses.state.value.isNotEmpty ? bonuses.state.value : '0',
    );
    final res = await ApiService.createOrder(orderRequest);
    if (!res) {
      showToast(
        'При создании заказа произошла ошибка, попробуйте позже',
        isError: true,
      );
    }
    return res;
  }

  @override
  FutureOr<void> onSubmit() {}
}
