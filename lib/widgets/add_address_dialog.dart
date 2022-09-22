import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/widgets/select_address_type.dart';

import '../api_calls.dart';
import '../controllers.dart';
import '../main.dart';
import 'service_button.dart';

addAddressDialog(context, Map? address) {
  final Controller c = Get.put(Controller());
  var ht = MediaQuery.of(context).size.height;
  var wd = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return SafeArea(
            child: Dialog(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                color: Colors.white,
                height: ht / 2,
                width: wd / 1.25,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: wd / 8),
                          child: const Text(
                            "Tag your Address",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xff5C5C5C),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                  "assets/icons/icons_png/001-pin.png")),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: wd / 30),
                          child: SizedBox(
                            width: wd,
                            child: Text(
                              // add["Address"],
                              address == null
                                  ? "${c.address["Address"]}, ${c.address["Sub_locality"]},${c.address["City"]},${c.address["State"]},${c.address["Country"]},${c.address["Postal_code"]}"
                                  : "${address["address"]}, ${address["city"]}, ${address["state"]}, ${address["pincode"]}, ",
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                              maxLines: 4,
                              // overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: wd / 8),
                          child: SizedBox(
                              width: wd / 1.5,
                              child: const SelectAddressType()),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: wd / 20),
                          child: ServiceButton(
                              onTap: () async {
                                if (address == null) {
                                  await saveUserAddress(
                                    c.refUserId.value,
                                    c.addressType.value,
                                    c.address["State"],
                                    c.address["City"],
                                    c.address["Postal_code"],
                                    c.coordinates["lat"],
                                    c.coordinates["lng"],
                                    c.address["Address"],
                                  ).then((value) {
                                    Get.snackbar(
                                        value['response']['message'],
                                        "Address id:" +
                                            value["data"]["address_id"]
                                                .toString());
                                    setState(() {
                                      c.addressID.value = value['data']
                                              ['address_id']
                                          .toString();
                                    });
                                  });

                                  Get.offAll(const HomeScreen());
                                } else {
                                  setState(
                                    () {
                                      c.address["Address"] = address["address"];
                                      c.address["City"] = address["city"];
                                      c.address["State"] = address["state"];
                                      c.address["Postal_code"] =
                                          address["pincode"];
                                      c.coordinates["lat"] = address["lat"];
                                      c.coordinates["lng"] = address["lng"];
                                    },
                                  );
                                  await saveUserAddress(
                                          c.refUserId.value,
                                          c.addressType.value,
                                          address["state"],
                                          address["city"],
                                          address["pincode"],
                                          address["lat"],
                                          address["lng"],
                                          address["address"])
                                      .then((value) {
                                    setState(() {
                                      c.addressID.value = value['data']
                                              ['address_id']
                                          .toString();
                                    });
                                  });
                                  Get.close(3);
                                }
                              },
                              fontSize: 16,
                              height: 40,
                              width: wd / 4,
                              buttonText: "OK"),
                        )
                      ]),
                ),
              ),
            ),
          );
        });
      });
}
