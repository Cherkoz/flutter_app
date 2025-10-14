import 'dart:async';

import 'package:cubit_form/cubit_form.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/utils/helper_functions.dart';

class SignupFormCubit extends FormCubit {
  SignupFormCubit() {
    email = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
        EmailStringValidation('Некорректный формат почты'),
      ],
    );
    phone = FieldCubit<String>(
      initalValue: '',
      validations: [
        PhoneStringValidation(11, 'Некорректно введен номер телефона'),
      ],
    );
    password = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
        MinLengthValidation(8, 'Пароль не должен быть короче 8 символов'),
      ],
    );
    name = FieldCubit<String>(
      initalValue: '',
      validations: [
        RequiredStringValidation('Это поле обязательное'),
      ],
    );
    refKey = FieldCubit<String>(
      initalValue: '',
    );

    addFields([
      email,
      phone,
      password,
      name,
      refKey,
    ]);
  }

  late FieldCubit<String> email;
  late FieldCubit<String> phone;
  late FieldCubit<String> password;
  late FieldCubit<String> name;
  late FieldCubit<String> refKey;

  @override
  FutureOr<bool> asyncValidation() async {
    final res = await ApiService.signup(
      email: email.state.value,
      phone: normalizePhoneNumber(phone.state.value),
      password: password.state.value,
      name: name.state.value,
      refKey: refKey.state.value,
    );
    if (res != null) {}
    return true;
  }

  @override
  FutureOr<void> onSubmit() {}
}
