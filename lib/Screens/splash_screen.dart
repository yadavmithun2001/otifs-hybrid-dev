
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/Screens/signup_screen.dart';
import 'package:stellar_track/widgets/logo.dart';

import '../controllers.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    getStorage.read('refUserId') != null
        ? saveRefId(getStorage.read('refUserId'))
        : saveRefId('');
  }

  saveRefId(id) {
    c.refUserId.value = id;
  }

  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;

    return AnimatedSplashScreen(
      backgroundColor: const Color(0xff38456C),
      duration: 2500,
      splashIconSize: ht/8,
      splash: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Logo(ht: ht)
      ),
      nextScreen: getStorage.read('refUserId') == null
          ? const SignUpScreen()
          : const SafeArea(child: HomeScreen()),
    );
  }
}
