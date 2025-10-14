import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/bloc/auth/auth_cubit.dart';
import 'package:grocery_delivery/logic/forms/signup_form_cubit.dart';
import 'package:grocery_delivery/ui/components/brand_button.dart';
import 'package:grocery_delivery/ui/components/brand_text_field.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/utils/helper_functions.dart';
import 'package:ru_phone_formatter/ru_phone_formatter.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupFormCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Регистрация'),
        ),
        body: Builder(
          builder: (context) {
            final signupCubit = context.watch<SignupFormCubit>();
            return BlocListener<SignupFormCubit, FormCubitState>(
              listener: (context, state) async {
                if (state.isSubmitted) {
                  showSnackBar(
                    text: 'Ваш аккаунт успешно зарегистрирован',
                    context: context,
                  );
                  final authRes = await ApiService.authenticate(
                    signupCubit.email.state.value,
                    signupCubit.password.state.value,
                  );
                  if (authRes) {
                    await BlocProvider.of<AuthCubit>(context).getUser();
                    Navigator.of(context).pop();
                  }
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 8,
                    children: [
                      BrandTextField(
                        formFieldCubit: signupCubit.email,
                        decoration: const InputDecoration(labelText: 'Электронная почта'),
                      ),
                      BrandTextField(
                        formFieldCubit: signupCubit.phone,
                        decoration: const InputDecoration(labelText: 'Телефон'),
                        inputFormatters: [RuPhoneInputFormatter()],
                      ),
                      BrandTextField(
                        formFieldCubit: signupCubit.password,
                        decoration: const InputDecoration(labelText: 'Пароль'),
                        obscureText: true,
                      ),
                      BrandTextField(
                        formFieldCubit: signupCubit.name,
                        decoration: const InputDecoration(labelText: 'Имя'),
                      ),
                      BrandTextField(
                        formFieldCubit: signupCubit.refKey,
                        decoration: const InputDecoration(labelText: 'Реферальный ключ'),
                      ),
                      const SizedBox(height: 4),
                      BrandButton(
                        onTap: signupCubit.trySubmit,
                        label: 'Зарегистрироваться',
                        labelColor: BrandColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
