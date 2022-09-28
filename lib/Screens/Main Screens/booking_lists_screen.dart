
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/Screens/Main%20Screens/home_page.dart';
import 'package:stellar_track/main.dart';
import 'package:stellar_track/widgets/active_bookings.dart';
import 'package:stellar_track/widgets/booking_history.dart';
import 'package:stellar_track/widgets/carousel.dart';

import '../../controllers.dart';
import '../../widgets/trigger_signin.dart';

class BookingListsScreen extends StatefulWidget {
  const BookingListsScreen({Key? key}) : super(key: key);

  @override
  State<BookingListsScreen> createState() => _BookingListsScreenState();
}

class _BookingListsScreenState extends State<BookingListsScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Builder(builder: (context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Obx(
            () => SafeArea(
              child: c.refUserId.value == "" ||
                      getStorage.read('refUserId') == null
                  ? const TriggerSignIn()
                  : SizedBox(
                      height: ht,
                      child: Column(
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
                                  "Bookings",
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                          //CREATE TAB BAR
                          TabBar(
                              onTap: ((value) {
                                setState(() {
                                  index =
                                      DefaultTabController.of(context)!.index;
                                });
                              }),
                              indicatorWeight: 1,
                              indicatorColor: Colors.transparent,
                              unselectedLabelColor: Colors.grey,
                              labelColor: Colors.white,
                              labelPadding: const EdgeInsets.all(0),
                              tabs: [
                                Tab(
                                  child: Container(
                                    margin: const EdgeInsets.all(0),
                                    color: DefaultTabController.of(context)!
                                                .index ==
                                            0
                                        ? const Color(0xff38456C)
                                        : Colors.white,
                                    child: const Center(
                                      child: Text("ACTIVE Bookings"),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    margin: const EdgeInsets.all(0),
                                    color: DefaultTabController.of(context)!
                                                .index ==
                                            1
                                        ? const Color(0xff38456C)
                                        : Colors.white,
                                    child: const Center(
                                      child: Text("Booking HISTORY"),
                                    ),
                                  ),
                                )
                              ]),
                          const Flexible(
                            child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                children: [ActiveBookings(), BookingHistory()]),
                          )
                        ],
                      )),
            ),
          ),
        );
      }),
    );
  }
}
