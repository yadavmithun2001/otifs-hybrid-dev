import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/Screens/transactions.dart';
import 'package:stellar_track/Screens/transfer_account.dart';
import 'package:stellar_track/main.dart';
import 'package:stellar_track/widgets/trigger_signin.dart';

import '../../controllers.dart';
import '../../widgets/account_screen_item_tile.dart';
import '../../widgets/carousel.dart';
import '../about.dart';
import '../addresses.dart';
import 'home_page.dart';
import '../notifications.dart';

class AccountSectionScreen extends StatefulWidget {
  const AccountSectionScreen({Key? key}) : super(key: key);

  @override
  State<AccountSectionScreen> createState() => _AccountSectionScreenState();
}

class _AccountSectionScreenState extends State<AccountSectionScreen> {
  final Controller c = Get.put(Controller());
  List<dynamic> items = [
    [const Transactions(), 'Transactions'],
    // [const Rewards(), 'Rewards'],
    [const TransferAccount(), 'Transfer Account'],
    [const About(), 'About'],
    // [const Preferences(), 'Preferences'],
    [const Notifications(), 'Notifications'],
    [const Addresses(), 'Addresses'],
  ];
  List<String> images = [
    "https://otifs.com/public/images/icons/my-account/transaction.png",
    "https://otifs.com/public/images/icons/my-account/transfer-account.png",
    "https://otifs.com/public/images/icons/my-account/about.png",
    "https://otifs.com/public/images/icons/my-account/notifications.png",
    "https://otifs.com/public/images/icons/my-account/addresses.png"
  ];

  List<String> descs = [
    "It contains the orders amount which has been placed",
    "Transfer account from one mobile number to another mobile by verifying otp",
    "Manage passwords and profile details",
    "It contains all the notifications which it got generated",
    "Manage address for placing the orders"
  ];

  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Obx(
            () => SizedBox(
              height: ht,
              child: c.refUserId.value == "" ||
                      getStorage.read('refUserId') == null
                  ? const TriggerSignIn()
                  : SingleChildScrollView(
                      child: Column(children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: ht / 5,
                              child: RewardCarousel(
                                  viewPort: 1.0,
                                  height: ht / 4,
                                  padEnds: true,
                                  data: onGoingOffers),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "Account",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff5C5C5C),
                                        fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: GestureDetector(
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
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ht / 1.6,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: items.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(items[index][0]);
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          width: wd,
                                          // height: ht / 11.4,
                                          child: AcccountItemsTile(
                                            title: items[index][1],
                                            images: images[index],
                                            descs: descs[index],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        )
                      ]),
                    ),
            ),
          )),
    );
  }
}
