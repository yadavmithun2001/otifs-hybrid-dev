import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/controllers.dart';

class TimeSlots extends StatefulWidget {
  const TimeSlots(
      {required this.time,
      required this.selected,
      required this.index,
      Key? key})
      : super(key: key);
  final String time;
  final bool selected;
  final int index;

  @override
  State<TimeSlots> createState() => _TimeSlotsState();
}

class _TimeSlotsState extends State<TimeSlots> {
  @override
  Widget build(BuildContext context) {
    Controller c = Get.put(Controller());

    return SizedBox(
      // height: 48,
      width: 81,
      child: DottedBorder(
        color:  widget.selected == true
            ? const Color(0xff1FD0C2)
            : const Color(0xffE5E5E5),
        strokeWidth: 2,
        dashPattern: widget.selected == true ?
        [10,0] : [10,3],
        radius: Radius.circular(10),
        borderType: BorderType.RRect,
        child: Container(
            child: Center(
              child: Text(
                widget.time.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color(0xff7E7D7D)),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,)
            ),
      ),
    );
  }
}
