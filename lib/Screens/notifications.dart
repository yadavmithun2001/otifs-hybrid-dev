import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../controllers.dart';
import '../main.dart';
import '../widgets/carousel.dart';
import '../widgets/notification_list_tile.dart';
import 'Main Screens/home_page.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  dynamic data;
  final Controller c = Get.put(Controller());
  @override
  void initState() {
    super.initState();
    getNotificationScreenData(c.refUserId.value).then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: wd / 8,
          leading: Padding(
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
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: SizedBox(
        //       height: ht / 14.5,
        //       child: BottomNavigation(
        //         height: ht / 14.5,
        //       )),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: data == null
            ? Center(child: ShimmerLoader(height: 60, width: wd))
            : data["data"] == null
                ? const Text("No Notifications availale")
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: ht / 5.2,
                              width: wd,
                              child: RewardCarousel(
                                  viewPort: 1.0,
                                  height: ht / 4,
                                  padEnds: true,
                                  data: onGoingOffers),
                            ),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(18.0),
                                    child: Text(
                                      "Notification",
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()
                                        )
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/icons/icons_png/004-headphones.png",
                                        color: const Color(0xff38456C),
                                        width: wd / 10,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: wd,
                              child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  itemCount: data["data"].length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return NotificationListItem(
                                      height: ht / 40.4,
                                      width: wd / 20.6,
                                      data: data,
                                      index: index,
                                    );
                                  }),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
