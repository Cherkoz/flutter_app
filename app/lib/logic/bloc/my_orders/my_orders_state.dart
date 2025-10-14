part of 'my_orders_cubit.dart';

sealed class MyOrdersState extends Equatable {
  const MyOrdersState();

  @override
  List<Object> get props => [];
}

final class MyOrdersInitial extends MyOrdersState {}

final class MyOrdersLoading extends MyOrdersState {}

final class MyOrdersError extends MyOrdersState {}

final class MyOrdersLoaded extends MyOrdersState {
  const MyOrdersLoaded({required this.orders});

  final List<Order> orders;
  @override
  List<Object> get props => [orders];
}
