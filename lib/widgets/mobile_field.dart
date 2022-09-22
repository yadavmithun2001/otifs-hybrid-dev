import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/widgets/otp_field.dart';
import 'package:stellar_track/widgets/service_button.dart';
import 'package:stellar_track/widgets/signup_flow_button.dart';

import '../Screens/signup_screen.dart';
import '../api_calls.dart';
import '../controllers.dart';

class MObileField extends StatefulWidget {
  MObileField(
      {this.onboarding, this.color, this.textColor, this.transfer, Key? key})
      : super(key: key);
  bool? onboarding;
  bool? transfer;
  Color? color;
  Color? textColor;
  @override
  State<MObileField> createState() => _MObileFieldState();
}

class _MObileFieldState extends State<MObileField> {
  final Controller c = Get.find();
  TextEditingController mobileController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;

    Future transferAccountFunctions(mobile) async {
      return Get.dialog(Dialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            height: ht / 3.5,
            color: Color(0xffF7F7F7),
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: ht / 23.8,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ),
                    c.otpField.value == false
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Once you proceed your new number will receive all your settings, bookings and addresses. Your current account will be reset to default. All the further notifications will come to the new number',
                              style: TextStyle(
                                  color: Color(0xff7E7D7D), fontSize: 14),
                            ),
                          )
                        : Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  'Enter OTP recieved in the new number to proceed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xff7E7D7D)),
                                ),
                              ),
                              OtpField(
                                accountTransfer: true,
                                phone: mobile,
                                onboarding: false,
                                textColor: Colors.black,
                                color: Colors.cyan[50],
                              ),
                            ],
                          ),
                    Visibility(
                      visible: !c.otpField.value,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ServiceButton(
                            buttonText: 'Proceed',
                            fontSize: 16,
                            height: ht / 20,
                            width: wd / 2.2,
                            onTap: () {
                              initiateAccountTransfer(c.refUserId.value, mobile)
                                  .then((value) {
                                setState(() {
                                  c.otpField.value = !c.otpField.value;
                                });
                                Get.showSnackbar(GetSnackBar(
                                  duration: Duration(seconds: 2),
                                  message: value["data"]["otp"].toString(),
                                ));
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      )).then((value) {
        setState(() {
          c.otpField.value = false;
        });
      });
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: ht / 50, horizontal: ht / 60),
          child: Card(
            elevation: widget.onboarding == false ? 5 : 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.onboarding == false ? widget.color : Colors.white,
              ),
              child: TextFormField(
                textAlign: TextAlign.center,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                controller: mobileController,
                cursorColor: const Color(0xff38456C),
                decoration: const InputDecoration(
                    hintText: "Enter mobile number",
                    counterText: "",
                    border: InputBorder.none,
                    iconColor: Colors.white,
                    focusColor: Colors.white,
                    fillColor: Colors.white),
              ),
            ),
          ),
        ),
        SignUpFlowButton(
          buttonText:
              widget.transfer == true ? 'Initiate Transfer' : "Proceed for OTP",
          textColor: widget.textColor,
          onPressed: () {
            if (mobileController.text == "" ||
                mobileController.text.length < 10) {
              Get.showSnackbar(GetSnackBar(
                title: "Field Missing",
                message: "Please enter mobile number",
                duration: Duration(seconds: 2),
              ));
            } else {
              if (widget.transfer == true) {
                transferAccountFunctions(mobileController.text.toString());
              } else {
                if (mobileController.text.length == 10) {
                  print("Success");
                  setState(() {
                    c.otpField.value = !c.otpField.value;
                    c.mobile.value = mobileController.text.toString();
                  });
                  getOtp(mobileController.text.toString());
                }
              }
            }
          },
        ),
      ],
    );
  }
}
