import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers.dart';
import '../models.dart';

class DaySlots extends StatefulWidget {
  const DaySlots(
      {required this.selected,
      required this.date,
      required this.weekday,
      Key? key})
      : super(key: key);
  final bool selected;
  final String date;
  final String weekday;
  @override
  State<DaySlots> createState() => _DaySlotsState();
}

class _DaySlotsState extends State<DaySlots> {
  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 48,
      width: 48,
      child: Container(
          child: Center(
            child: Text(
              "${widget.date}\n ${weekdayMap[widget.weekday]}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xff7E7D7D)),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: widget.selected == true
                    ? const Color(0xff1FD0C2)
                    : const Color(0xffE5E5E5),
              ))),
    );
  }
}
