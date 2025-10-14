import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/models/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> getUser() async {
    final user = await ApiService.getUser();
    if (user != null) {
      emit(Authentificated(user: user));
    } else {
      emit(NotAuthentificated());
    }
  }

  Future<void> logout() async {
    emit(NotAuthentificated());
    await ApiService.logout();
  }
}
