import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/navigation/router.dart';
import 'package:grocery_delivery/utils/helper_functions.dart';

class AuthFormCubit extends FormCubit {
  AuthFormCubit() {
    login = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
      ],
    );
    password = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
      ],
    );

    addFields([login, password]);
  }

  late FieldCubit<String> login;
  late FieldCubit<String> password;

  @override
  FutureOr<bool> asyncValidation() async {
    final res = await ApiService.authenticate(
      login.state.value,
      password.state.value,
    );

    if (!res) {
      showSnackBar(
        text: 'Неверный логин или пароль',
        context: AppRouter().navigator.context,
      );
    }

    return res;
  }

  @override
  FutureOr<void> onSubmit() {}
}
