import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/api_calls.dart';

import '../controllers.dart';
import '../main.dart';
import 'loader.dart';
import 'product_details_bottom_sheet.dart';

class AddToCartButton extends StatefulWidget {
  AddToCartButton(
      {required this.added,
      required this.data,
      required this.index,
      required this.function,
      Key? key})
      : super(key: key);
  var prodId, unitId;
  var data;
  int index;
  var function;
  // qty, date, fromTime, toTime;
  bool added;
  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var slots;
        var value;
        Get.dialog(const Loader());
        await getProductDetails(widget.data["data"][widget.index]["product_id"])
            .then(
          (item) {
            setState(() {
              value = item;
            });
          },
        );
        await getTimeSlots(widget.data["data"][widget.index]["product_id"])
            .then((value) {
          setState(() {
            slots = value;
          });
          Get.close(1);
        });
        await bottomSheet(context, value["data"][0], slots,
          isCart: true,
        );
        widget.function();
      },
      child: Text(
        widget.added == false ? "ADD" : "ADDED",
        style: TextStyle(
            color: widget.added == false ? Colors.black26 : Color(0xff1FD0C2),
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
