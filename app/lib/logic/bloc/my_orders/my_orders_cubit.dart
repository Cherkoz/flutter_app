import 'package:cubit_form/cubit_form.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/models/order.dart';

part 'my_orders_state.dart';

class MyOrdersCubit extends Cubit<MyOrdersState> {
  MyOrdersCubit() : super(MyOrdersInitial());

  Future<void> getOrders() async {
    emit(MyOrdersLoading());
    final res = await ApiService.getMyOrders();
    if (res == null) {
      emit(MyOrdersError());
    } else {
      emit(MyOrdersLoaded(orders: res));
    }
  }
}
