part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class Authentificated extends AuthState {
  const Authentificated({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

final class NotAuthentificated extends AuthState {}
