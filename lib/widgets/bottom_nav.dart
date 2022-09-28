import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/main.dart';

import '../controllers.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({required this.height, Key? key}) : super(key: key);
  final double height;
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
   Controller c = Get.put(Controller());
  String cart_count = '0';
  @override
  void initState() {
    // TODO: implement initState
    getCartItems(c.refUserId.value).then((value) {
      setState(() {
        c.cartCount.value = value["data"][0]["cart_count"];
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Obx(
        () => Container(
          color: Colors.white,
          height: widget.height,
          width: wd,
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(0),
            color: Colors.transparent,
            child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                iconSize: 18,
                backgroundColor: Colors.white,
                selectedItemColor: const Color(0xff38456C),
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                unselectedItemColor: const Color(0xff7E7D7D),
                selectedFontSize: 11.5,
                unselectedFontSize: 11.5,
                currentIndex: c.screenIndex.value,
                onTap: (value) {
                  setState(() {
                    c.screenIndex.value = value;
                  });

                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => screens[c.screenIndex.value]),
                  //     (route) => false);
                },
                items: [
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Image.asset(
                      "assets/icons/BottomNav/home.png",
                      color: c.screenIndex.value == 0
                          ? const Color(0xff38456C)
                          : const Color(0xff7E7D7D),
                      height: 22,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        "assets/icons/BottomNav/call.png",
                        color: c.screenIndex.value == 1
                            ? const Color(0xff38456C)
                            : const Color(0xff7E7D7D),
                        height: 22,
                      ),
                      label: "Book on call"),
                  BottomNavigationBarItem( 
                      icon: Badge(
                        showBadge: true,
                        ignorePointer: true,
                        badgeColor: Color(0xff1FD0C2),
                        badgeContent: Text(
                         c.cartCount.value.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        child: Image.asset(
                          "assets/icons/BottomNav/cart.png",
                          color: c.screenIndex.value == 2
                              ? const Color(0xff38456C)
                              : const Color(0xff7E7D7D),
                          height: 22,
                        ),
                      ),
                      label: "Service Cart"),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        "assets/icons/BottomNav/bookings.png",
                        color: c.screenIndex.value == 3
                            ? const Color(0xff38456C)
                            : const Color(0xff7E7D7D),
                        height: 22,
                      ),
                      label: "Bookings"),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        "assets/icons/BottomNav/account.png",
                        color: c.screenIndex.value == 4
                            ? const Color(0xff38456C)
                            : const Color(0xff7E7D7D),
                        height: 22,
                      ),
                      label: "Account")
                ]),
          ),
        ),
      ),
    );
  }


}
