import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/Screens/service_screen.dart';
import 'package:stellar_track/widgets/service_list.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../api_calls.dart';
import '../controllers.dart';

class ActiveBookings extends StatefulWidget {
  const ActiveBookings({Key? key}) : super(key: key);

  @override
  State<ActiveBookings> createState() => _ActiveBookingsState();
}

class _ActiveBookingsState extends State<ActiveBookings> {
  // ignore: prefer_typing_uninitialized_variables
  var activeBookingsData;
  final Controller c = Get.put(Controller());
  @override
  void initState() {
    super.initState();
    getActiveBookings(c.refUserId.value).then((value) {
      setState(() {
        activeBookingsData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return activeBookingsData == null
        ? const ShimmerLoader(height: 60, width: 60)
        : activeBookingsData['status'] == 'failure'
            ? const Center(child: Text("No data found"))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: activeBookingsData["data"].length,
                itemBuilder: (context, index) {
                  return ServiceList(
                    data: activeBookingsData,
                    index: index,
                    bookingButton: false,
                    activeBooking: true,
                    bookingScreen: true,
                  );
                });
  }
}
