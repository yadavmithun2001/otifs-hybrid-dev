import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/service_button.dart';
import 'dart:math' as math; // import this

import '../controllers.dart';

class AddUnitsValue extends StatefulWidget {
  const AddUnitsValue({required this.ht, required this.wd, Key? key, required this.units, required this.product_id, this.unit_data, required this.selected, required this.unit_value_id})
      : super(key: key);
  final int product_id;
  final dynamic unit_data;
  final String units;
  final String selected;
  final int unit_value_id;
  final double ht;
  final double wd;
  @override
  State<AddUnitsValue> createState() => _AddUnitsValueState();
}

class _AddUnitsValueState extends State<AddUnitsValue> {
  final Controller c = Get.put(Controller());
  TextEditingController textEditingController = TextEditingController(text: '1');
  List _stateList = [];
  String? _selected;
  int? _selected_unit_id;
  dynamic product_price;





  @override
  Widget build(BuildContext context) {
    _stateList = widget.unit_data["data"];
    c.sqft.value = '1';
    return GestureDetector(
      onTap: () async {
        addUnitsDialog(widget.units,
            context, widget.ht, widget.wd, textEditingController, c, setState);
      },
      child: Container(
        decoration: BoxDecoration(color: const Color(0xffE5E5E5),
          border: Border.all(color: Colors.grey,width: 0.5)
        ),
        width: widget.wd / 1.2,
        height: widget.ht / 15,

        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Row(
                 children: [
                   Text(
                    widget.units+"  ",
                    maxLines: 10,
                    style: TextStyle(
                        color: Color(0xff5C5C5C),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                   ),
                    DropdownButton<String>(
                     value: _selected ,
                     iconSize: 30,
                     style: const TextStyle(
                       color: Colors.black54,
                       fontSize: 16,
                     ),
                     hint: Text(widget.selected),
                     onChanged: (newValue) {
                       setState(() {
                         _selected = newValue!;
                       });
                     },
                     items: _stateList.map((item) {
                       return DropdownMenuItem(
                         child: Text(item['dispval'].toString()),
                         value: item['dispval'].toString(),
                         onTap: (){
                           setState(() {
                             _selected_unit_id = item["unit_values_id"];
                             c.selected_id.value = _selected_unit_id.toString();
                             c.selected_quantity.value = c.sqft.value;
                           });
                         },

                       );
                     }).toList(),
                   ),
                 ],
               ),
              Obx(
                () => Text(
                  c.sqft.value != '' ? c.sqft.value + ' Quantity' : 'Enter Quantity',
                  style: const TextStyle(
                      color: Color(0xff5C5C5C),
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),
              )
            ]),
      ),
    );
  }
}

Future addUnitsDialog(String unit,
    context, ht, wd, textEditingController, c, setState) async {
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Dialog(
            child: Container(
              height: ht / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter total Quantity",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: wd,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (() {
                            var value =
                                int.parse(textEditingController.text) + 1;
                            setState(
                              () {
                                textEditingController.text = value.toString();
                              },
                            );
                          }),
                          child: Card(
                            shape: const CircleBorder(),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/icons/icons_png/027-arrow.png",
                                  height: 12,
                                  width: 12,
                                  fit: BoxFit.cover,
                                  color: const Color(0xff1FD0C2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: ht / 12,
                            width: wd / 3,
                            child: TextFormField(
                              // initialValue: "0",
                              textAlign: TextAlign.center,
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              // onEditingComplete: () {
                              //   setState((() {
                              //     c.sqft.value = textEditingController
                              //         .text
                              //         .toString();
                              //   }));
                              // },
                            )),
                        GestureDetector(
                          onTap: (() {
                            var value =
                                int.parse(textEditingController.text) - 1;
                            setState(
                              () {
                                textEditingController.text = value.toString();
                              },
                            );
                          }),
                          child: Card(
                            shape: const CircleBorder(),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/icons/icons_png/027-arrow.png",
                                  height: 12,
                                  width: 12,
                                  fit: BoxFit.cover,
                                  color: const Color(0xff1FD0C2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ServiceButton(
                    buttonText: "OK",
                    width: wd / 4,
                    height: ht / 20,
                    fontSize: 14,
                    onTap: () async {
                      c.sqft.value = await textEditingController.text;
                      Get.back();
                      // setState(() {
                      //   c.sqft.value =
                      //       textEditingController.text.toString();
                      // });
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }).then((value) {
    setState() {
      c.sqft.value = '1';
    }

    ;
  });
}
