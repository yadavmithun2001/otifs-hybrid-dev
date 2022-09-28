import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:stellar_track/Screens/Main%20Screens/bookacall.dart';
import 'package:stellar_track/Screens/notifications.dart';
import 'package:stellar_track/main.dart';
import 'package:stellar_track/widgets/select_address_bottomsheet.dart';

import '../Screens/Main Screens/home_page.dart';
import '../api_calls.dart';
import '../controllers.dart';
import '../functions.dart';
import 'address_widget.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {

  Controller c = Get.put(Controller());

  @override
  void initState() {
    // TODO: implement initState
    print(c.addressType.value.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;
    final Controller c = Get.put(Controller());

    return AppBar(
      elevation: 0,
      flexibleSpace: Center(
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if(c.refUserId.value == ""){
                  triggerSignInDialog(context, setState);
                }else{
                  listUserAddresses(c.refUserId.value,null).then((value) =>
                      Get.bottomSheet(SelectAddressBottomSheet(data: value)
                      )
                  );
                }
                // addAddressDialog(context, null);
              },
              child: Container(
                  width: wd / 2,
                  color: Colors.transparent,
                  child: const AddressWidget()),
            ),
            GestureDetector(
              onTap: (){
                c.screenIndex.value = 1;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()
                )
                );
              },
              child: Image.asset(
                "assets/AppBarCall.png",
                width: wd / 10,
                height: 20,
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()
                )
                );
              },
              child: Image.asset(
                "assets/AppBarNotification.png",
                width: wd / 10,
                height: 20,
              ),
            ),
            Image.asset(
              "assets/AppBarOffer.png",
              width: wd / 4,
            ),
          ],
        ),
      ),
    );
  }
}
