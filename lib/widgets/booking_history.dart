import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/service_list.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../controllers.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({Key? key}) : super(key: key);

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  var bookingHistoryData;
  final Controller c = Get.put(Controller());
  @override
  void initState() {
    super.initState();
    getBookingHistory(c.refUserId.value).then((value) {
      setState(() {
        bookingHistoryData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return bookingHistoryData == null
        ? const ShimmerLoader(height: 60, width: 60)
        : bookingHistoryData["status"] == "failure"
            ? const Center(child: Text("No data found"))
            : ListView.builder(
                itemCount: bookingHistoryData["data"].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ServiceList(
                   
                    data: bookingHistoryData,
                    index: index,
                    bookingButton: false,
                    activeBooking: true,
                    bookingScreen: true,
                    color: Color(0xff7E7D7D),
                  );
                });
  }
}
