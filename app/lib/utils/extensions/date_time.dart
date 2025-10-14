import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get dayMonth {
    final DateFormat format = DateFormat('d MMMM', 'ru');
    return format.format(this);
  }

  String get fullDateDelivery {
    final DateFormat format = DateFormat('d MMMM (EEEE) в HH:mm', 'ru');
    return format.format(this);
  }
}