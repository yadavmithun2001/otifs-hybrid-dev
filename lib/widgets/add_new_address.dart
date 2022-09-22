import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/widgets/add_address_dialog.dart';

import '../functions.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({Key? key}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  Map<String, String> addressMap = {
    "address": "",
    "city": "",
    "state": "",
    "pincode": "",
    "lat": "",
    "lng": ""
  };
  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;

    return Dialog(
      child: SizedBox(
        height: ht / 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: wd / 8.0),
          child: SizedBox(
            height: ht,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                decoration: const InputDecoration(labelText: "Address"),
                controller: addressController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "City"),
                controller: cityController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "State"),
                controller: stateController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Pincode"),
                controller: pincodeController,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (addressController.text == '' ||
                        cityController.text == '' ||
                        stateController.text == '' ||
                        pincodeController.text == '') {
                      Get.showSnackbar(const GetSnackBar(
                        message: "Please fill all fields",
                      ));
                    } else {
                      setState(() {
                        addressMap["address"] = addressController.text;
                        addressMap["city"] = cityController.text;
                        addressMap["state"] = stateController.text;
                        addressMap["pincode"] = pincodeController.text;
                      });

                      getCoordinatesFromLocation(
                              "${addressMap["address"]},${addressMap["city"]},${addressMap["state"]},${addressMap["pincode"]}")
                          .then((coordinates) {
                        print(coordinates[0]
                            .toString()
                            .split(",")[1]
                            .split(":")
                            .last);

                        setState(() {
                          addressMap["lat"] = coordinates[0]
                              .toString()
                              .split(",")[0]
                              .split(":")
                              .last;
                          addressMap["lng"] = coordinates[0]
                              .toString()
                              .split(",")[1]
                              .split(":")
                              .last;
                        });

                        Get.dialog(addAddressDialog(context, addressMap));
                      });
                    }
                  },
                  child: const Text("Proceed"))
            ]),
          ),
        ),
      ),
    );
  }
}
