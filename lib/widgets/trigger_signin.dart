import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/widgets/service_button.dart';

import '../controllers.dart';
import '../functions.dart';
import 'mobile_field.dart';
import 'otp_field.dart';

class TriggerSignIn extends StatefulWidget {
  const TriggerSignIn({Key? key}) : super(key: key);

  @override
  State<TriggerSignIn> createState() => _TriggerSignInState();
}

class _TriggerSignInState extends State<TriggerSignIn> {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Please Sign in to continue"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                  height: 30,
                  width: 200,
                  child: ServiceButton(
                    buttonText: "Sign in",
                    onTap: () async {
                      triggerSignInDialog(context, setState).then((value) {
                        c.otpField.value = false;
                      });
                    },
                  )
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text("Sign In"),
                  // ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
