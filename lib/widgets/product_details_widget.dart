import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stellar_track/Screens/select_time_date.dart';
import 'package:stellar_track/widgets/time_slot_selection.dart';
import 'package:stellar_track/widgets/trigger_signin.dart';

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
      {Key? key, required this.data, required this.slots, this.isCart, this.isBoth})
      : super(key: key);
  final bool? isCart;
  final bool? isBoth;
  final dynamic data;
  final dynamic slots;
  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final Controller c = Get.put(Controller());
  dynamic unit_data;
  String? selected = "";
  int? selected_unit_id = 0;
  TextEditingController textEditingController = TextEditingController(text: '1');
  List _stateList = [];
  dynamic product_price;

  String updated_price='';
  String initial_price='';
  int cart_count = 0;

  @override
  void initState() {
    getUnitDetails(widget.data["product_id"], widget.data["unit_name"]).then((value) {
      setState(() {
        unit_data = value;
        selected = unit_data["data"][0]["dispval"];
        selected_unit_id = unit_data["data"][0]["unit_values_id"];
      });
    });

    getCartCount(c.refUserId.value.toString()).then((value) {
      setState(() {
        cart_count = value["data"][0]["car_count"];
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
    return SizedBox(
      height: ht/1.75,
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
                child: GestureDetector(
                  onTap: (){
                    c.screenIndex.value = 1;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()
                    )
                    );
                  },
                  child: Image.asset(
                    "assets/AppBarCall.png",
                    width: 20,
                  ),
                ),
              ),
              /* const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Icon(
                  Icons.bookmark,
                  size: 20,
                ),
              ), */
            ],
          ),
          SizedBox(
            height: ht / 3,
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
                                              MainAxisAlignment.end,
                                          children: [

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
                                                    '₹'+widget.data['sell_price'].toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
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
          Row(
            mainAxisAlignment:MainAxisAlignment.center ,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: SizedBox(
                  width: wd / 2.5,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(
                          color: Colors.white, fontSize: 16),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                        side: MaterialStateProperty.all(
                            const BorderSide(color: Colors.red, width: 2)),
                        backgroundColor: MaterialStateProperty.all(Colors.red)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ServiceButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                          => SelectTimeandDate(data: widget.data, slots: widget.slots,
                            isCart: widget.isCart,isBoth: widget.isBoth,
                          )
                      ));
                    },
                    width: wd / 2.5,
                    color: const Color(0xff38456C),
                    fontSize: 16,
                    buttonText: "PROCEED"),
              ),
            ],
          ),

        ],
      ),
    );
  }

}


