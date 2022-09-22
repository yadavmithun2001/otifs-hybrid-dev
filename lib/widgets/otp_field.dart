import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:stellar_track/Screens/add_address_screen.dart';
import 'package:stellar_track/Screens/Main%20Screens/home_page.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/controllers.dart';
import 'package:stellar_track/functions.dart';
import 'package:stellar_track/main.dart';
import 'package:stellar_track/widgets/loader.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';
import 'package:stellar_track/widgets/signup_flow_button.dart';

import '../Screens/signup_screen.dart';

class OtpField extends StatefulWidget {
  OtpField(
      {required this.phone,
      this.onboarding,
      this.color,
      this.textColor,
      this.accountTransfer,
      Key? key})
      : super(key: key);
  String phone;
  bool? onboarding, accountTransfer;

  Color? color;
  Color? textColor;
  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  String otp = "";
  OtpFieldController controller = OtpFieldController();
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();

    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;

    return SizedBox(
      width: wd / 1.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OTPTextField(
            width: wd / 2,
            length: 4,
            fieldWidth: wd / 10,
            controller: controller,
            fieldStyle: FieldStyle.box,
            spaceBetween: wd / 30,
            onChanged: (value) {},
            onCompleted: (value) {
              setState(() {
                otp = value.toString();
              });
            },
            otpFieldStyle: OtpFieldStyle(
                backgroundColor:
                    widget.onboarding == false ? widget.color! : Colors.white,
                borderColor:
                    widget.onboarding == false ? widget.color! : Colors.white,
                enabledBorderColor: Colors.white,
                focusBorderColor: Colors.white),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  c.otpField.value = !c.otpField.value;
                });
              },
              child: Text(
                "Change Mobile number?",
                style: TextStyle(
                    color: widget.onboarding == false
                        ? Colors.black
                        : Colors.white),
              )),
          SignUpFlowButton(
              buttonText: "Confirm OTP",
              textColor: widget.onboarding == false ? Colors.black : null,
              onPressed: () async {
                print("Entered OTP" + otp);
                // bool verifyingOtp = true;
                if (widget.accountTransfer == true) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent.withOpacity(0.5),
                          child: const LocationShimmer(
                              height: 30, width: 100, string: "Validating"),
                        );
                      });
                  confirmAccountTransferOtp(c.refUserId.value, otp)
                      .then((value) {
                    Get.close(2);
                  });
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent.withOpacity(0.5),
                          child: const LocationShimmer(
                              height: 30, width: 100, string: "Validating"),
                        );
                      });
                  validateOTP(c.mobile.value, otp).then((value) async {
                    setState(() {
                      c.refUserId.value = value["data"]["ref_user_id"];
                    });
                    await saveLoginStatus(value["data"]["ref_user_id"])
                        .then((value) {
                      Get.back();
                    });

                    // if (value["response"]["message"].toString() ==
                    //     "Logged in succesfully") {
                    //   if (widget.onboarding == false) {
                    //     await saveLoginStatus(value["data"]["ref_user_id"])
                    //         .then((value) => print("Ref ID Saved"));
                    //   } else {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const AddAddress()));
                    //   }
                    // }
                    value["response"]["message"].toString() ==
                            "Logged in successfully"
                        ? widget.onboarding == false
                            ? Get.close(1)
                            : listUserAddresses(c.refUserId.value,null)
                                .then((value) {
                                if (value['response']['message'] ==
                                    "Data not available") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddAddress()));
                                } else {
                                  Get.to(const HomeScreen());
                                }
                              })
                        : null;
                  }).then((value) async {
                    await getCartCount(c.refUserId.value).then(
                      (value) {
                        setState(() {
                          c.cartCount.value = value['data'][0]['car_count'];
                        });
                      },
                    );
                  });
                }
              }),
        ],
      ),
    );
  }
}
