import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_delivery/ui/helpers/toast.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';
import 'package:intl/intl.dart';

String uniteAddress({
  required String street,
  required String building,
  required String entrance,
  required String floor,
  required String apartment,
}) {
  String address = '';
  if (street.isEmpty || building.isEmpty) {
    return '';
  }
  address += street;
  address += ', дом $building';
  if (entrance.isNotEmpty) {
    address += ', подъезд $entrance';
  }
  if (floor.isNotEmpty) {
    address += ', этаж $floor';
  }
  if (apartment.isNotEmpty) {
    address += ', квартира $apartment';
  }
  return address;
}

String uniteTime({
  required DateTime date,
  required TimeOfDay time,
}) {
  final format = DateFormat('yyyy-MM-dd');
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final format24 = DateFormat.Hm();
  final deliveryTime = '${format.format(date)}T${format24.format(dt)}:00';
  return deliveryTime;
}

void showSnackBar({
  required String text,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: BrandTypography.subheadline.copyWith(color: BrandColors.white),
      ),
    ),
  );
}

void copyToClipboard({
  required String text,
  required BuildContext context,
  String? toastText,
}) {
  Clipboard.setData(ClipboardData(text: text));
  if (toastText != null) {
    showToast(
      toastText,
      prependIcon: CupertinoIcons.doc_on_doc,
      duration: const Duration(milliseconds: 800),
    );
  }
}

String normalizePhoneNumber(String phoneNumber) {
  // Use a regular expression to match any non-digit character (represented by \D)
  // and replace it with an empty string.
  return phoneNumber.replaceAll(RegExp(r'\D'), '');
}
