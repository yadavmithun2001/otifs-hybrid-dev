import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stellar_track/widgets/time_slot_selection.dart';

import '../Screens/checkout_page.dart';
import '../api_calls.dart';
import '../controllers.dart';
import '../functions.dart';
import '../main.dart';
import 'add_units_value.dart';
import 'date_slot_selection.dart';
import 'select_address_bottomsheet.dart';
import 'service_button.dart';

class ProductDetailsWidget extends StatefulWidget {
  const ProductDetailsWidget(
      {Key? key, required this.data, required this.slots, this.isCart})
      : super(key: key);
  final bool? isCart;
  final dynamic data;
  final dynamic slots;
  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final Controller c = Get.put(Controller());
  dynamic unit_data;
  String? selected = "";
  int? selected_unit_id=0;
  TextEditingController textEditingController = TextEditingController(text: '1');
  List _stateList = [];
  dynamic product_price;

  String updated_price='';
  String initial_price='';

  @override
  void initState() {
    getUnitDetails(widget.data["product_id"], widget.data["unit_name"]).then((value) {
      setState(() {
        unit_data = value;
        selected = unit_data["data"][0]["dispval"];
        selected_unit_id = unit_data["data"][0]["unit_values_id"];
      });
    });

    setState(() {
      c.currentDateSelected.value = '';
      c.currentTimeSelected.value = '';
      c.sqft.value = '1';
      c.updated_price.value = '';

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;
    _stateList = unit_data["data"];
    c.sqft.value = '1';
    getUpdatedPrice(widget.data["product_id"], unit_data["data"][0]["unit_values_id"], "1").then((value) {
      setState(() {
        initial_price = value["data"]["total_amount"].toString();
      });
    });
    return SizedBox(
      height: ht / 1.2,
      width: wd,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      // height: 30,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            elevation: MaterialStateProperty.all(5)),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Image.asset(
                  "assets/AppBarCall.png",
                  width: 20,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Icon(
                  Icons.bookmark,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: ht / 2.25,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Card(
                        shape: const CircleBorder(),
                        elevation: 10,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          width: ht / 7,
                          child: Image.network(
                            widget.data["product_image"],
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data["product_name"],
                                  style: const TextStyle(
                                      color: Color(0xff5C5C5C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: wd / 50),
                                  child: Text(widget.data["product_summary"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Color(0xff7E7D7D),
                                          fontSize: 12)),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: wd / 50),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: wd / 1.75,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/time.png",
                                                    width: wd / 12,
                                                  ),
                                                  Text(
                                                    widget.data["service_time"],
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff38456C),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: wd / 80),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/money.png",
                                                    width: wd / 10,
                                                  ),
                                                  Text(
                                                    updated_price == '' ? initial_price
                                                    :updated_price,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff38456C),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                               /* Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: wd / 50),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: const [
                                          Text(
                                            "3400",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff38456C),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 2.0),
                                            child: Text(
                                              "bookings",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff7E7D7D),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Image.asset(
                                        "assets/RatingImage.jpeg",
                                        height: ht / 20,
                                        width: wd / 3.5,
                                      )
                                    ],
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: wd / 5,
                  width: wd / 1.2,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data["images"].length,
                      shrinkWrap: true,
                      itemExtent: wd / 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.hardEdge,
                            child: Container(
                              height: wd / 5,
                              width: wd / 5,
                              color: Colors.black12,
                              child: widget.data["images"][index]
                                          ["product_image"] !=
                                      null
                                  ? Image.network(
                                      widget.data["images"][index]
                                          ["product_image"],
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: SizedBox(
                    width: wd,
                    child: Text(widget.data["product_summary"],
                        // maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color(0xff7E7D7D), fontSize: 12)),
                  ),
                ),
              ],
            )),
          ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 12.0,
                    ),
                  ],
                ),
                child: Card(
                  elevation: 20,
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    width: wd,
                    color: const Color(0xffF7F7F7),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Select Date and time slot",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff5C5C5C)),
                            ),
                          ),
                          Obx(
                            () => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      null;
                                      // listUserAddresses(c.refUserId.value).then(
                                      //     (value) => Get.bottomSheet(
                                      //         SelectAddressBottomSheet(
                                      //             data: value)));
                                    },
                                    child: Container(
                                      width: wd / 1.2,
                                      height: ht / 14,
                                      color: const Color(0xffE5E5E5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: SizedBox(
                                                      height: ht / 50,
                                                      width: 20,
                                                      child: Image.asset(
                                                          "assets/icons/icons_png/001-pin.png")),
                                                ),
                                                Text(
                                                  c.addressType.value == "H"
                                                      ? "Home"
                                                      : c.addressType.value ==
                                                              "O"
                                                          ? "Office"
                                                          : "Custom",
                                                  style: const TextStyle(
                                                      color: Color(0xff5C5C5C),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "${c.address["Address"]}, ${c.address["Sub_locality"]},${c.address["City"]},${c.address["State"]},${c.address["Country"]},${c.address["Postal_code"]}",
                                              style: const TextStyle(
                                                  color: Color(0xff5C5C5C),
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Enter unit Values Widget
                                  GestureDetector(
                                    onTap: () async {

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(color: const Color(0xffE5E5E5),
                                          border: Border.all(color: Colors.grey,width: 0.5)
                                      ),
                                      width: wd / 1.2,
                                      height: ht / 15,

                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  widget.data["unit_name"].toString()+"  ",
                                                  maxLines: 10,
                                                  style: TextStyle(
                                                      color: Color(0xff5C5C5C),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                 DropdownButton<String>(
                                                  value: selected ,
                                                  iconSize: 30,
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                  ),
                                                  hint: Text(selected!),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selected = newValue!;
                                                    });
                                                  },
                                                  items: _stateList.map((item) {
                                                    return new DropdownMenuItem(
                                                      child: new Text(item['dispval'].toString()),
                                                      value: item['dispval'].toString(),
                                                      onTap: (){
                                                        setState(() {
                                                          selected_unit_id = item["unit_values_id"];
                                                          c.selected_id.value = selected_unit_id.toString();
                                                          c.selected_quantity.value = c.sqft.value;
                                                          _updatedetails();
                                                        });
                                                      },

                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                            Obx(
                                                  () => GestureDetector(
                                                    onTap: (){
                                                      addUnitsDialog(widget.data["unit_name"],
                                                          context, ht, wd, textEditingController, c, setState);
                                                    },
                                                    child: Text(
                                                c.sqft.value != '' ? textEditingController.text + ' Quantity' : 'Enter Quantity',
                                                style: const TextStyle(
                                                      color: Color(0xff5C5C5C),
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14),
                                              ),
                                                  ),
                                            )
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DateSlotSelection(),

                          TimeSlotsSelection(slots: widget.slots),

                          //ADD TO CART OR BOOK SERVICE BUTTON

                          widget.isCart == null || widget.isCart == false
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ServiceButton(
                                      onTap: () {
                                        if (c.refUserId.value == "" ||
                                            getStorage.read('refUserId') ==
                                                null) {
                                          triggerSignInDialog(
                                              context, setState);
                                        }
                                        if (c.sqft.value == '' ||
                                            c.dateSelected.value == '' ||
                                            c.timeSlot.value == '' ||
                                            c.address[""] == "") {
                                          Get.showSnackbar(GetSnackBar(
                                            duration: Duration(seconds: 2),
                                            message:
                                                "Please Enter a value for "+widget.data["unit_name"],
                                          ));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckoutPage(
                                                        data: widget.data,
                                                        isCart: false,
                                                        isBottomNav: false,
                                                      )));

                                          // Get.to(CheckoutPage(
                                          //   data: widget.data,
                                          // ));
                                        }

                                        // c.refUserId.value == "" ||
                                        //         getStorage.read('refUserId') ==
                                        //             null
                                        //     ? triggerSignInDialog(
                                        //         context, setState)
                                        //     : c.sqft.value == '' ||
                                        //             c.dateSelected.value ==
                                        //                 '' ||
                                        //             c.timeSlot.value == '' ||
                                        //             c.address[""] == ""
                                        //         ?
                                        // Get.showSnackbar(
                                        //             const GetSnackBar(
                                        //             duration:
                                        //                 Duration(seconds: 2),
                                        //             message:
                                        //                 "Please fill all the fields",
                                        //           ))
                                        //         :
                                        // Get.to(CheckoutPage(
                                        //             data: widget.data,
                                        //           ));
                                      },
                                      width: wd / 1.8,
                                      color: const Color(0xff38456C),
                                      fontSize: 16,
                                      buttonText: "Book one time service"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ServiceButton(
                                      onTap: () {
                                        c.refUserId.value == "" ||
                                                getStorage.read('refUserId') ==
                                                    null
                                            ? triggerSignInDialog(
                                                context, setState)
                                            : c.sqft.value == '' ||
                                                    c.dateSelected.value ==
                                                        '' ||
                                                    c.timeSlot.value == '' ||
                                                    c.address[""] == ""
                                                ? Get.showSnackbar(
                                                    const GetSnackBar(
                                                      duration:
                                                          Duration(seconds: 2),
                                                      message:
                                                          "Please fill all the fields",
                                                    ),
                                                  )
                                                : addItemToCart(
                                                        c.refUserId,
                                                        widget
                                                            .data['product_id'],
                                                        widget.data[
                                                            'unit_values_id'],
                                                        qty: c.sqft.value,
                                                        date: c
                                                            .dateSelected.value
                                                            .toString(),
                                                        fromTime:
                                                            c.timeSlot.value,
                                                        toTime:
                                                            c.timeSlot.value)
                                                    .then((value) {
                                                    Get.close(1);
                                                  });
                                      },
                                      width: wd / 1.8,
                                      color: const Color(0xff38456C),
                                      fontSize: 16,
                                      buttonText: "Add to cart"),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          )
        ],
      ),
    );
  }

  _updatedetails(){
    getUpdatedPrice(widget.data["product_id"], selected_unit_id,c.sqft.value).then((value) {
      setState(() {
        updated_price = value["data"]["total_amount"].toString();
      });
    });
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
                        _updatedetails();
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

}


