
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/controllers.dart';

class UnitValues extends StatefulWidget {
  const UnitValues(
      {required this.units,
        required this.selected,
        required this.index,
        Key? key})
      : super(key: key);
  final String units;
  final bool selected;
  final int index;

  @override
  State<UnitValues> createState() => _UnitValuesState();
}

class _UnitValuesState extends State<UnitValues> {
  @override
  Widget build(BuildContext context) {
    Controller c = Get.put(Controller());

    return SizedBox(
      height: 25,
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  widget.units.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Color(0xff7E7D7D)),
                ),
              ),
            ),

          // ButtonStyle(
          //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10))),
          //     side: MaterialStateProperty.all(BorderSide(
          //         color: widget.selected == true
          //             ? const Color(0xff1FD0C2)
          //             : const Color(0xffE5E5E5),
          //         width: 2)),
          //     backgroundColor: MaterialStateProperty.all(Colors.white)),

      ),
    );
  }
}
