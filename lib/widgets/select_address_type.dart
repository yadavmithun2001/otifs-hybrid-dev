import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers.dart';
import 'address_type_button.dart';

class SelectAddressType extends StatefulWidget {
  const SelectAddressType({Key? key}) : super(key: key);

  @override
  State<SelectAddressType> createState() => _SelectAddressTypeState();
}

class _SelectAddressTypeState extends State<SelectAddressType> {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AddressTypeButton(
            onTap: () {
              setState(() {
                c.addressType.value = "H";
              });
            },
            title: "Home",
            selected: c.addressType.value == "H" ? true : false,
          ),
          AddressTypeButton(
              onTap: () {
                setState(() {
                  c.addressType.value = "O";
                });
              },
              title: "Office",
              selected: c.addressType.value == "O" ? true : false),
          AddressTypeButton(
              onTap: () {
                setState(() {
                  c.addressType.value = "C";
                });
              },
              title: "Custom",
              selected: c.addressType.value == "C" ? true : false),
        ],
      ),
    );
  }
}
