import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stellar_track/main.dart';
import 'package:stellar_track/widgets/add_to_cart_button.dart';
import 'package:stellar_track/widgets/product_details_bottom_sheet.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';
import 'package:get/get.dart';
import '../api_calls.dart';
import '../controllers.dart';
import 'loader.dart';

class ServiceList extends StatefulWidget {
  ServiceList(
      {required this.data,
      required this.index,
      this.added,
      this.bookingButton,
      this.activeBooking,
      this.bookingScreen,
      this.color,
      this.refreshFunction,
      Key? key})
      : super(key: key);

  @override
  State<ServiceList> createState() => _ServiceListState();
  var data;
  int index;
  bool? bookingButton;
  bool? activeBooking;
  bool? bookingScreen;
  bool? added;
  var color;
  var mainCatId, subCatId;
  var refreshFunction;
}

class _ServiceListState extends State<ServiceList> {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    return widget.data == null
        ? Center(child: ShimmerLoader(height: 50, width: wd))
        : GestureDetector(
          onTap: (() async {
            var slots;
            var value;
            var units;
            Get.dialog(Center(child: const Loader()));
            await getProductDetails(
                widget.data["data"][widget.index]
                ["product_id"])
                .then(
                  (item) {
                setState(() {
                  value = item;
                });
              },
            );
            await getUnitDetails(widget.data["product_id"], widget.data["unit_name"]).then((value) {
              setState(() {
                units = value;
              });
            });

            await getTimeSlots(widget.data["data"]
            [widget.index]["product_id"])
                .then((value) {
              setState(() {
                slots = value;
              });
              Get.close(1);
            });
            bottomSheet(
                context, value["data"][0], slots,
                isBoth: true,
            );
          }),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.data["data"][widget.index]["product_image"] == "")
                      Container(
                        width: wd / 7,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Container(
                          width: wd / 7,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: widget.data["data"][widget.index]
                                      ["product_image"] ==
                                  null
                              ? Container()
                              : Image.network(
                                  widget.data["data"][widget.index]
                                      ["product_image"],
                                  fit: BoxFit.fill,
                                  // width: wd / 7,
                                ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: wd / 1.25,
                            child: Row(
                              // mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: SizedBox(
                                    width: widget.activeBooking == true
                                        ? wd / 1.5
                                        : wd / 1.8,
                                    child: Text(
                                      // "",
                                      widget.data["data"][widget.index]
                                          ["product_name"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Visibility(
                                    visible: widget.activeBooking == true
                                        ? false
                                        : true,
                                    child: GestureDetector(
                                      onTap: () async {
                                        // getProductDetails(widget.data['data']
                                        //     [widget.index]['product_id']);
                                      },
                                      child: AddToCartButton(
                                        added: widget.added ?? false,
                                        data: widget.data,
                                        index: widget.index,
                                        function: () {
                                          print("Called on Service List");
                                          widget.refreshFunction();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_right)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: wd / 1.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data["data"][widget.index]
                                        ['product_summary']
                                    .toString(),
                                maxLines: 2,
                                // widget.activeBooking == true ? 2 : 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: wd / 1.3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: wd / 2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/money.png",
                                              width: wd / 12,
                                            ),
                                            Visibility(
                                              visible:
                                                  widget.bookingScreen == true
                                                      ? false
                                                      : true,
                                              child: Text(widget.data["data"][widget.index]["price"]!=widget.data["data"][widget.index]["sell_price"] ?
                                                "₹${widget.data["data"][widget.index]["price"].toString()}-${widget.data["data"][widget.index]["sell_price"].toString()}"
                                                  : "₹${widget.data["data"][widget.index]["price"].toString()}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff38456C),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  widget.bookingScreen ?? false,
                                              child: Text(
                                                "₹${widget.data["data"][widget.index]["price"].toString()} ",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff38456C),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: widget.bookingButton == false
                                      ? false
                                      : true,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 0.0, left: 0),
                                    child: GestureDetector(
                                      onTap: (() async {
                                        var slots;
                                        var value;
                                        Get.dialog(Center(child: const Loader()));
                                        await getProductDetails(
                                                widget.data["data"][widget.index]
                                                    ["product_id"])
                                            .then(
                                          (item) {
                                            setState(() {
                                              value = item;
                                            });
                                          },
                                        );
                                        await getTimeSlots(widget.data["data"]
                                                [widget.index]["product_id"])
                                            .then((value) {
                                          setState(() {
                                            slots = value;
                                          });
                                          Get.close(1);
                                        });
                                        bottomSheet(
                                            context, value["data"][0], slots,isCart: false
                                        );
                                      }),
                                      child: const Text(
                                        "BOOK",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.cyan),
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Visibility(
                                      visible: widget.activeBooking == true
                                          ? true
                                          : false,
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_pin),
                                          widget.data["data"][widget.index]
                                                      ["address_type_desc"] !=
                                                  null
                                              ? Text(widget.data["data"]
                                                      [widget.index]
                                                  ["address_type_desc"])
                                              : const Text("")
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Visibility(
                                  visible:
                                  widget.bookingScreen ?? false,
                                  child: Text(
                                    "${widget.data["data"][widget.index]["unit_name"].toString()}- ${widget.data["data"][widget.index]["dispval"].toString()} ",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff38456C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                              Visibility(
                                visible: widget.activeBooking == true ? true : false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 5),
                                  child: Text(
                                    widget.data["data"][widget.index]["service_date"]
                                        .toString(),
                                    style: TextStyle(
                                        color:
                                        widget.color ?? const Color(0xff1FD0C2),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),



                        ],
                      ),
                    )
                  ],
                ),
                const Divider(
                  thickness: 2,
                )
              ],
            ),
        );
  }
}
