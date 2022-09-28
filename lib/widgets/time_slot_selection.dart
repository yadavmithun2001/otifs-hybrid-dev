import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers.dart';
import 'time_slots.dart';



class TimeSlotsSelection extends StatefulWidget {
  const TimeSlotsSelection({required this.slots, Key? key}) : super(key: key);
  final dynamic slots;
  @override
  State<TimeSlotsSelection> createState() => _TimeSlotsSelectionState();
}

class _TimeSlotsSelectionState extends State<TimeSlotsSelection> {
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    c.currentTimeSelected.value = '0';
    c.timeSlot.value =
        widget.slots["data"][0]["start"].toString();
    c.totime.value = widget.slots["data"][0]["end"].toString();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 37,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.slots.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(
                  () => GestureDetector(
                    onTap: () {
                      c.timeSlot.value =
                          widget.slots["data"][index]["start"].toString();
                      c.totime.value = widget.slots["data"][index]["end"].toString();
                      c.currentTimeSelected.value = index.toString();
                      print(c.timeSlot.value);
                      print(index);
                      print(c.currentTimeSelected.value);
                    },
                    child: TimeSlots(
                      index: index,
                      selected: c.currentTimeSelected.value == index.toString()
                          ? true
                          : false,
                      time: widget.slots["data"][index]["start"].toString(),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
