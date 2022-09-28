import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stellar_track/Screens/Main%20Screens/cart_screen.dart';
import 'package:stellar_track/Screens/checkout_page.dart';
import 'package:stellar_track/widgets/loader.dart';
import 'package:stellar_track/widgets/units_values.dart';

import '../api_calls.dart';
import '../controllers.dart';
import '../functions.dart';
import '../main.dart';
import '../widgets/date_slot_selection.dart';
import '../widgets/service_button.dart';
import '../widgets/time_slot_selection.dart';

class SelectTimeandDate extends StatefulWidget {
  const SelectTimeandDate({Key? key,this.isCart,required this.data,required this.slots, this.isBoth}) : super(key: key);
  final bool? isCart;
  final bool? isBoth;
  final dynamic data;
  final dynamic slots;

  @override
  State<SelectTimeandDate> createState() => _SelectTimeandDateState();
}

class _SelectTimeandDateState extends State<SelectTimeandDate> {

  final Controller c = Get.put(Controller());
  late ScrollController _scrollController;
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
    _scrollController = ScrollController();
    getUnitDetails(widget.data["product_id"], widget.data["unit_name"]).then((value) {
      setState(() {
        unit_data = value;
        selected = unit_data["data"][0]["dispval"];
        selected_unit_id = unit_data["data"][0]["unit_values_id"];
        getUpdatedPrice(widget.data["product_id"], selected_unit_id, "1").then((value) {
          setState(() {
            initial_price = value["data"]["total_amount"].toString();
          });
        });
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
    _stateList = unit_data["data"];
    c.sqft.value = '1';
    return Scaffold(

      body: SafeArea(
          child: Stack(
            children: [
              Container(
                    height: ht,
                    width: wd,
                    color: const Color(0xffF7F7F7),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widget.data["images"][0]
                          ["product_image"] == null
                              ? SizedBox(height:150,child: Loader())
                              : SizedBox(
                                height: ht/4,
                                width: wd,
                                child: CarouselSlider.builder(
                                itemCount: widget.data["images"].length,
                                options: CarouselOptions(
                                  enableInfiniteScroll: true,
                                  viewportFraction: 1,
                                  enlargeCenterPage: true),
                            itemBuilder: ((context, index, realIndex) {
                                return Container(
                                  child: Image.network(
                                    widget.data["images"][index]["product_image"],
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: ProfilePageShimmer(),
                                      );
                                    },
                                    fit: BoxFit.contain,
                                  ),
                                );
                            }),
                          ),
                              ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    widget.data["product_name"]
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                
                                GestureDetector(
                                  onTap: (){
                                    _scrollController.animateTo(500,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  },
                                  child: Row(
                                    children:const[
                                      Text("View Details"),
                                      Icon(Icons.arrow_right)
                                    ],
                                  ),
                                ),


                                /* Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
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
                                 const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18.0),
                                      child: Icon(
                                        Icons.bookmark,
                                        size: 20,
                                      ),
                                    ), */
                              ],
                            ),
                          ),
                          Padding(
                            padding:const EdgeInsets.fromLTRB(15, 20, 0, 0),
                            child: Text(
                              updated_price == '' ? "Total Cost:- ₹"+initial_price : "Total Cost:- ₹"+updated_price,
                              style:const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          Obx(
                                () => Padding(
                              padding:
                              const EdgeInsets.fromLTRB(10,10 , 10, 0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
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
                                      width: wd ,
                                      height: ht / 14,
                                      color: const Color(0xffE5E5E5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
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

                                      width: wd,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(15,5, 10, 5),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.data["unit_name"].toString(),
                                                style: const TextStyle(
                                                    color: Color(0xff5C5C5C),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16
                                                ),
                                              ),
                                              GridView.builder(
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    childAspectRatio: 2.8
                                                  ),
                                                  shrinkWrap: true,
                                                  itemCount: _stateList.length,
                                                  itemBuilder: (context,index){
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                                                      child: GestureDetector(
                                                          onTap: (() async {
                                                            setState(() {
                                                              selected_unit_id = _stateList[index]["unit_values_id"];
                                                              c.selected_id.value = selected_unit_id.toString();
                                                              c.selected_quantity.value = c.sqft.value;
                                                              c.sqft.value = textEditingController.text;
                                                              _updatedetails();
                                                            });
                                                          }),
                                                          child: UnitValues(
                                                            index: index,
                                                            selected: selected_unit_id == _stateList[index]["unit_values_id"]
                                                            ? true : false,
                                                            units: _stateList[index]["dispval"],
                                                          )
                                                      ),

                                                    );
                                                  }
                                              ),
                                             /* DropdownButton<String>(
                                                value: selected ,
                                                iconSize: 30,
                                                style: const TextStyle(
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
                                                  return DropdownMenuItem(
                                                    child: Text(item['dispval'].toString()),
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
                                              ), */

                                              GestureDetector(
                                                  onTap: (){

                                                  },
                                                  child: _QunatityItem()
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        /*  const Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              "Select Date and time slot",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff5C5C5C)),
                            ),
                          ), */
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 0, 5),
                                  child: Text(
                                      'Service Date',
                                    style: TextStyle(
                                      color: Color(0xff5C5C5C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                    ),
                                  ),
                                ),
                                DateSlotSelection(),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                               const Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child: Text(
                                      'Preferred Time',
                                    style: TextStyle(
                                        color: Color(0xff5C5C5C),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                                TimeSlotsSelection(slots: widget.slots),
                              ],
                            ),
                          ),

                          //ADD TO CART OR BOOK SERVICE BUTTON
                           widget.isCart == false
                              ? Padding(
                            padding: const EdgeInsets.fromLTRB(8, 15, 8, 40),
                            child: Center(
                              child: ServiceButton(
                                    onTap: () {
                                      if (c.refUserId.value == "" ||
                                          getStorage.read('refUserId') ==
                                              null) {

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
                                        if(c.refUserId.value == ""){
                                          triggerSignInDialog(context, setState);
                                        }else{
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckoutPage(
                                                        data: widget.data,
                                                        unit_values_id: selected_unit_id!,
                                                        isCart: false,
                                                        isBottomNav: false,
                                                        total_amount:updated_price =='' ? initial_price : updated_price,
                                                      )));
                                        }
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
                            ),
                          )
                              : widget.isBoth == true ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 40),
                                    child: ServiceButton(

                                          onTap: () {
                                            if (c.refUserId.value == "" ||
                                                getStorage.read('refUserId') ==
                                                    null) {

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
                                              if(c.refUserId.value == ""){
                                                triggerSignInDialog(context, setState);
                                              }else{
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CheckoutPage(
                                                              data: widget.data,
                                                              unit_values_id: selected_unit_id!,
                                                              isCart: false,
                                                              isBottomNav: false,
                                                              total_amount: updated_price,
                                                            )));
                                              }
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
                                          width: wd / 2.5,
                                          color: const Color(0xff38456C),
                                          fontSize: 14,
                                          buttonText: "Book one time service"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 40),
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
                                                widget.data['product_id'],
                                                selected_unit_id,
                                                qty: textEditingController.text,
                                                date: c
                                                    .dateSelected.value
                                                    .toString(),
                                                fromTime:
                                                c.timeSlot.value,
                                                toTime:
                                                c.timeSlot.value)
                                                .then((value) {
                                              c.cartCount.value = cart_count + 1;
                                              Get.close(1);
                                            });
                                          },
                                          width: wd / 2.5,
                                          color: const Color(0xff38456C),
                                          fontSize: 14,
                                          buttonText: "Add to cart"),
                                  )
                                ],
                              ):
                            Padding(
                            padding: const EdgeInsets.fromLTRB(8, 15, 8, 40),
                            child: Center(
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
                                        widget.data['product_id'],
                                        selected_unit_id,
                                        qty: textEditingController.text,
                                        date: c
                                            .dateSelected.value
                                            .toString(),
                                        fromTime:
                                        c.timeSlot.value,
                                        toTime:
                                        c.timeSlot.value)
                                        .then((value) {
                                      c.cartCount.value = cart_count + 1;
                                      Get.close(1);
                                    });
                                  },
                                  width: wd / 1.8,
                                  color: const Color(0xff38456C),
                                  fontSize: 16,
                                  buttonText: "Add to cart"),
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                            child: Align(
                              alignment: Alignment.topLeft,
                                child: Text(
                                    'Product Description :',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  widget.data["product_summary"].toString(),
                                style: TextStyle(
                                  fontSize: 15
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
              Padding(
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
            ],
          ),
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

  Widget _QunatityItem(){
    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0,0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quantity',
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff5C5C5C),
                fontWeight: FontWeight.bold
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (() {
                    var value =
                        int.parse(textEditingController.text) - 1;
                    c.sqft.value = value.toString();

                    setState(
                          () {
                        textEditingController.text = value.toString();

                        _updatedetails();
                      },
                    );
                  }),
                  child: const Card(
                    shape: CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 15),
                      child: Icon(
                          Icons.minimize_sharp
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: ht / 15,
                    width: wd / 6,
                    child: TextFormField(
                      // initialValue: "0",
                      textAlign: TextAlign.center,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      onEditingComplete: () {
                        setState((() {
                          c.sqft.value = textEditingController
                              .text
                              .toString();
                          _updatedetails();
                        }));
                      },
                    )),
                GestureDetector(
                  onTap: (() {
                    var value =
                        int.parse(textEditingController.text) + 1;
                    c.sqft.value = value.toString();
                    setState(
                          () {
                        textEditingController.text = value.toString();
                        _updatedetails();
                      },
                    );
                  }),
                  child: const Card(
                    shape: CircleBorder(),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                            Icons.add
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


}



