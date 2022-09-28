import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/functions.dart';
import 'package:stellar_track/main.dart';
import 'package:stellar_track/widgets/add_new_address.dart';
import 'package:stellar_track/widgets/add_units_value.dart';
import 'package:stellar_track/widgets/confirm_booking_dialog.dart';
import 'package:stellar_track/widgets/day_slots.dart';
import 'package:stellar_track/widgets/product_details_widget.dart';
import 'package:stellar_track/widgets/select_address_bottomsheet.dart';
import 'package:stellar_track/widgets/service_button.dart';
import 'package:stellar_track/widgets/time_slots.dart';

import '../Screens/addresses.dart';
import '../Screens/checkout_page.dart';
import '../controllers.dart';
import 'date_slot_selection.dart';
import 'time_slot_selection.dart';
import 'trigger_signin.dart';

Future bottomSheet(context, data, slots, {bool? isCart,isBoth}) {
  final Controller c = Get.put(Controller());
  var wd = MediaQuery.of(context).size.width;
  var ht = MediaQuery.of(context).size.height;
  slots["data"].forEach((item) {});

  return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      context: context,
      builder: (context) {
        return ProductDetailsWidget(
          data: data,
          slots: slots,
          isCart: isCart,
          isBoth: isBoth
        );
      }).whenComplete(() {
    c.sqft.value = '';
    c.dateSelected.value = '';
    c.timeSlot.value = '';
    c.currentTimeSelected.value = '';
    c.currentDateSelected.value = '';
  });
}
