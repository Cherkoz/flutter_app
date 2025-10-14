import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_delivery/logic/bloc/auth/auth_cubit.dart';
import 'package:grocery_delivery/logic/forms/auth_form_cubit.dart';
import 'package:grocery_delivery/logic/models/user.dart';
import 'package:grocery_delivery/ui/components/brand_button.dart';
import 'package:grocery_delivery/ui/components/brand_divider.dart';
import 'package:grocery_delivery/ui/components/brand_text_field.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';
import 'package:grocery_delivery/utils/helper_functions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is! Authentificated) {
            return const AuthForm();
          }
          return AuthedForm(user: state.user);
        },
      ),
    );
  }
}

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthFormCubit(),
      child: BlocListener<AuthFormCubit, FormCubitState>(
        listener: (context, state) {
          if (state.isSubmitted) {
            BlocProvider.of<AuthCubit>(context).getUser();
          }
        },
        child: Builder(
          builder: (context) {
            final authFormCubit = context.watch<AuthFormCubit>();
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  BrandTextField(
                    formFieldCubit: authFormCubit.login,
                    decoration: const InputDecoration(labelText: 'Email или телефон'),
                  ),
                  const SizedBox(height: 20),
                  BrandTextField(
                    formFieldCubit: authFormCubit.password,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  BrandButton(
                    onTap: authFormCubit.trySubmit,
                    label: 'Войти',
                    labelColor: BrandColors.white,
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'У вас нет аккаунта? ',
                          style: BrandTypography.subheadline,
                        ),
                        TextSpan(
                          text: 'Зарегистрироваться и получать бонусы',
                          style:
                              BrandTypography.subheadline.copyWith(color: BrandColors.systemLink),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).pushNamed('/signup'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class AuthedForm extends StatelessWidget {
  const AuthedForm({required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: BrandColors.accent,
      onRefresh: () async {
        await BlocProvider.of<AuthCubit>(context).getUser();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              _infoRow(
                leadingIcon: CupertinoIcons.person,
                leadingText: 'Имя',
                text: user.name,
              ),
              _infoRow(
                leadingIcon: CupertinoIcons.phone,
                leadingText: 'Телефон',
                text: user.phoneNumber,
              ),
              _infoRow(
                leadingIcon: CupertinoIcons.mail,
                leadingText: 'Почта',
                text: user.email,
              ),
              _infoRow(
                leadingIcon: FontAwesomeIcons.coins,
                leadingText: 'Бонусы',
                text: user.bonuses.toString(),
              ),
              _infoRow(
                leadingIcon: FontAwesomeIcons.key,
                leadingText: 'Реферальный ключ',
                text: '',
                onTap: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    expand: false,
                    builder: (context) => Material(
                      color: BrandColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Реферальный ключ',
                              style: BrandTypography.titleSmallBold,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Пригласи друга в приложение. При регистрации он должен указать твой реферальный ключ. После первого успешного заказа друга, вы оба получите по 500 бонусов, которые можно будет потратить на следующие заказы.',
                              style: BrandTypography.body,
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                copyToClipboard(
                                  text: user.referalCode,
                                  context: context,
                                  toastText: 'Реферальный ключ скопирован',
                                );
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: BrandColors.fillTertiary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        user.referalCode,
                                        style: BrandTypography.bodyBold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(CupertinoIcons.doc_on_doc),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              _infoRow(
                leadingIcon: CupertinoIcons.doc_plaintext,
                leadingText: 'Мои заказы',
                text: '',
                onTap: () {
                  Navigator.of(context).pushNamed('/my_orders');
                },
              ),
              _infoRow(
                leadingIcon: CupertinoIcons.money_rubl_circle,
                leadingText: 'Оплата и доставка',
                text: '',
                onTap: () {
                  Navigator.of(context).pushNamed('/payment_and_delivery');
                },
              ),
              _infoRow(
                leadingIcon: CupertinoIcons.phone,
                leadingText: 'Контакты',
                text: '',
                onTap: () {
                  Navigator.of(context).pushNamed('/contacts');
                },
              ),
              BrandButton(
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).logout();
                },
                buttonColor: BrandColors.systemDestructive,
                label: 'Выйти из профиля',
                labelColor: BrandColors.white,
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData leadingIcon,
    required String leadingText,
    required String text,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: [
              Icon(
                leadingIcon,
                size: 17,
              ),
              const SizedBox(width: 8),
              Text(
                leadingText,
                style: BrandTypography.body,
              ),
              const Spacer(),
              Text(
                text,
                style: BrandTypography.body.copyWith(
                  color: BrandColors.textSecondary,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                const Icon(
                  CupertinoIcons.chevron_forward,
                  size: 20,
                  color: BrandColors.textTertiary,
                ),
              ],
            ],
          ),
          const BrandDivider(),
        ],
      ),
    );
  }
}
