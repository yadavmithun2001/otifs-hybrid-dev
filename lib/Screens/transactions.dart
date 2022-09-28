import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/Screens/Main%20Screens/home_page.dart';
import 'package:stellar_track/Screens/screen1.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../controllers.dart';
import '../main.dart';
import '../widgets/active_bookings.dart';
import '../widgets/booking_history.dart';
import '../widgets/carousel.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  void initState() {
    // TODO: implement initState
    getBookingTransactions(c.refUserId.value).then((value) {
      setState(() {
        bookingsData = value;
      });
    });
  }

  dynamic bookingsData;
  int index = 0;
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
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
              automaticallyImplyLeading: false,
            ),
            body: bookingsData == null
                ? Center(child: ShimmerLoader(height: 60, width: wd))
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
                                "Transactions",
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
                                index = DefaultTabController.of(context)!.index;
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
                                  color:
                                      DefaultTabController.of(context)!.index ==
                                              0
                                          ? const Color(0xff38456C)
                                          : Colors.white,
                                  child: const Center(
                                    child: Text("Bookings"),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  margin: const EdgeInsets.all(0),
                                  color:
                                      DefaultTabController.of(context)!.index ==
                                              1
                                          ? const Color(0xff38456C)
                                          : Colors.white,
                                  child: const Center(
                                    child: Text("Refunds"),
                                  ),
                                ),
                              )
                            ]),
                        Flexible(
                          child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                BookingTransactions(
                                    data: bookingsData, index: index),
                                RandomScreen()
                              ]),
                        )
                      ],
                    )),
          ),
        );
      }),
    );
  }
}

class BookingTransactions extends StatelessWidget {
  const BookingTransactions({required this.data, required this.index, Key? key})
      : super(key: key);
  final dynamic data;
  final int index;
  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    return SizedBox(
      height: ht,
      child: ListView.builder(
        itemCount: data['data'].length,
        shrinkWrap: true,
        itemBuilder: (context, index) => SizedBox(
          width: wd,
          // height: ht / 7.45,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: wd / 5,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: data["data"][index]["product_image"] == null
                          ? Container()
                          : Image.network(
                              data["data"][index]["product_image"],
                              fit: BoxFit.fill,
                              // width: wd / 7,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: wd / 1.3,
                    height: ht / 7.44,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: SizedBox(
                                    width: wd / 1.8,
                                    child: Text(
                                      // "",
                                      data["data"][index]["product_name"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['data'][index]['service_date'] +
                                            ' |',
                                        style: const TextStyle(
                                            color: Color(0xffBABABA),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        data['data'][index]['order_status'],
                                        style: const TextStyle(
                                            color: Color(0xff16980B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Job ID:' +
                                      data['data'][index]['order_id']
                                          .toString(),
                                  style: const TextStyle(
                                      color: Color(0xff7E7D7D),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Text(
                              "₹" + data['data'][index]['price'].toString(),
                              style: const TextStyle(
                                  color: Color(0xff38456C),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Text(
                          data['data'][index]['product_summary'],
                          style: const TextStyle(
                              color: Color(0xff7E7D7D),
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                          maxLines: 2,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}
