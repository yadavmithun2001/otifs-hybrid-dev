import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:stellar_track/controllers.dart';
import 'package:stellar_track/main.dart';
import 'package:stellar_track/widgets/mobile_field.dart';
import 'package:stellar_track/widgets/otp_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController mobileController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Obx(
          () => Container(
            height: ht,
            color: const Color(0xff38456C),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: SizedBox(
                        height: ht / 1.8,
                        child: Image.asset(
                          "assets/popularServices/bathroomDC.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ht / 60),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Visibility(
                    visible: !c.otpField.value,
                    child: MObileField(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ht / 50),
                    child: Visibility(
                      visible: c.otpField.value,
                      child: OtpField(
                        phone: c.mobile.value,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: wd / 15,
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        child: const Text(
                          "SKIP",
                          style:
                              TextStyle(color: Color(0xff1FD0C2), fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
