import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/models.dart';

import '../controllers.dart';
import 'day_slots.dart';

class DateSlotSelection extends StatefulWidget {
  const DateSlotSelection({Key? key}) : super(key: key);

  @override
  State<DateSlotSelection> createState() => _DateSlotSelectionState();
}

class _DateSlotSelectionState extends State<DateSlotSelection> {
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    // TODO: implement initState
    c.currentDateSelected.value = '0';
    c.dateSelected.value = (DateTime.parse(c.date.value)
        .add(Duration(days: 0))
        .toString()
        .split('-')[0] +
        '-' +
        DateTime.parse(c.date.value)
            .add(Duration(days: 0))
            .toString()
            .split('-')[1] +
        '-' +
        DateTime.parse(c.date.value)
            .add(Duration(days: 0))
            .toString()
            .split('-')[2]
            .split(' ')
            .first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 4,
          // itemExtent: 40,
          itemBuilder: (context, index) {
            
            var weekday = int.parse(DateTime.parse(c.date.value)
                .add(Duration(days: index))
                .weekday
                .toString());

            var day;

            if (weekday <= 6) {
              day = int.parse(DateTime.parse(c.date.value)
                  .add(Duration(days: index))
                  .weekday
                  .toString());
            } else {
              day = 0;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(
                () => GestureDetector(
                    onTap: (() async {
                      List<String> date;
                      String dateSelected;
                      c.currentDateSelected.value = index.toString();
                      date = c.date.value.toString().split('-');

                      dateSelected = (DateTime.parse(c.date.value)
                              .add(Duration(days: index))
                              .toString()
                              .split('-')[0] +
                          '-' +
                          DateTime.parse(c.date.value)
                              .add(Duration(days: index))
                              .toString()
                              .split('-')[1] +
                          '-' +
                          DateTime.parse(c.date.value)
                              .add(Duration(days: index))
                              .toString()
                              .split('-')[2]
                              .split(' ')
                              .first);
                      setState(() {
                        c.dateSelected.value = dateSelected;
                      });
                   
                  
                    }),
                    child: DaySlots(
                      weekday: day.toString(),
                      date: DateTime.parse(c.date.value)
                          .add(Duration(days: index))
                          .toString()
                          .split('-')[2]
                          .split(' ')
                          .first,
                      selected: c.currentDateSelected.value == index.toString()
                          ? true
                          : false,
                    )
                ),
              ),
            );
          }),
    );
  }
}
