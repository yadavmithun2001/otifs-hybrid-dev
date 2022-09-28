
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stellar_track/Screens/checkout_page.dart';
import 'package:stellar_track/Screens/service_screen.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/add_units_value.dart';
import 'package:stellar_track/widgets/address_widget.dart';
import 'package:stellar_track/widgets/carousel.dart';
import 'package:stellar_track/widgets/service_button.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stellar_track/widgets/time_slot_selection.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../controllers.dart';
import '../../main.dart';
import '../../widgets/date_slot_selection.dart';
import '../../widgets/day_slots.dart';
import '../../widgets/trigger_signin.dart';
import 'home_page.dart';

class CartScreen extends StatefulWidget {
  const CartScreen(
      {required this.isBottomNav,
      this.mainCatId,
      this.subCatId,
      this.mainCatImage,
      Key? key})
      : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
  final bool isBottomNav;
  final dynamic mainCatId;
  final dynamic subCatId;
  final dynamic mainCatImage;
}

class _CartScreenState extends State<CartScreen> {
  dynamic data;
  String? updated_price = '';
  TextEditingController textEditingController =
  TextEditingController(text: '0');
  @override
  void initState() {

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

    getCartItems(c.refUserId.value).then((value) {
      setState(() {
        data = value;
        textEditingController.text = value["data"][0]["quantity"];
      });
    });

    super.initState();
  }

  int index = 0;

  final Controller c = Get.put(Controller());
  String updated_qunatity = "1";
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  onRefresh() {
    getCartItems(c.refUserId.value).then((value) {
      setState(() {
        data = value;
      });
    }).then((value) => _refreshController.refreshCompleted());
  }
  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: data == null
            ? ShimmerLoader(height: ht, width: wd)
            : Scaffold(
                floatingActionButton: Padding(
                  padding: EdgeInsets.all(ht / 30.0),
                  child: ServiceButton(
                    onTap: () {
                      if (widget.isBottomNav == false) {
                        data['response']['message'] == 'Data not available'
                            ? Get.back()

                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ServiceScreen(
                            //             mainCatID: widget.mainCatId,
                            //             subCatID: widget.subCatId,
                            //             mainCatImage: widget.mainCatImage)))
                            : Get.to(CheckoutPage(
                                data: data,
                                unit_values_id: data[""],
                                isCart: true,
                                isBottomNav: true,
                               total_amount: "0",
                              ));
                      } else {
                        data['response']['message'] == 'Data not available'
                            ? setState(
                                () {
                                  c.screenIndex.value = 0;
                                },
                              )
                            : Get.to(CheckoutPage(
                                data: data,
                                unit_values_id: 0,
                                isCart: true,
                                isBottomNav: true,
                                total_amount: "0",
                              ));
                      }
                    },
                    buttonText:
                        data['response']['message'] == 'Data not available'
                            ? "Back"
                            : "Proceed",
                    height: 35,
                    width: wd / 3,
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  elevation: 0,
                  leadingWidth: 40,
                  backgroundColor: Colors.transparent,
                  leading: widget.isBottomNav == false
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Get.close(1);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ServiceScreen(
                                        mainCatID: widget.mainCatId,
                                        subCatID: widget.subCatId,
                                        mainCatImage: widget.mainCatImage)));
                          },
                        )
                      : null,
                  // leading: ,
                  //
                  automaticallyImplyLeading: widget.isBottomNav,
                ),
                body: Obx(() => c.refUserId.value == "" ||
                        getStorage.read('refUserId') == null
                    ? const TriggerSignIn()
                    : data == null
                        ? Center(child: ShimmerLoader(height: 60, width: wd))
                        : data['response']['message'] == 'Data not available'
                            ? const Center(
                                child: Text('No items in cart'),
                              )
                            : SizedBox(
                                height: ht,
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: ht / 5,
                                        child: RewardCarousel(
                                            viewPort: 1.0,
                                            height: ht / 4,
                                            padEnds: true,
                                            data: onGoingOffers),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Text(
                                              "Cart",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff5C5C5C),
                                                  fontSize: 18),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: GestureDetector(
                                              onTap: (){
                                                c.screenIndex.value = 1;
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                                              },
                                              child: Image.asset(
                                                "assets/AppBarCall.png",
                                                width: wd / 10,
                                                height: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          color: const Color(0xffE5E5E5),
                                          child: const AddressWidget()),
                                      Padding(
                                        padding: EdgeInsets.only(top: ht / 40),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (widget.isBottomNav == true) {
                                              setState(() {
                                                c.screenIndex.value = 0;
                                              });
                                            } else {
                                              Get.close(3);
                                            }
                                          },
                                          child: const Text(
                                            "Add more services/products",
                                            style: TextStyle(
                                                color: Color(0xff38456C),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        // height: ht / 2.3,
                                        child: ListView.builder(
                                            padding:
                                                EdgeInsets.only(top: ht / 50),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: data['data'].length,
                                            itemBuilder: (context, index) {
                                              return CartItemListTile(
                                                data: data,
                                                updated_price: updated_price!,
                                                index: index,
                                                refresh: () {
                                                  onRefresh();
                                                },
                                                areaFunction: () async {
                                                  data == null;
                                                  updateCart(index,
                                                      '', context,
                                                      ht,
                                                      wd,
                                                      textEditingController,
                                                      setState)
                                                      .then((value) async {
                                                    await addItemToCart(
                                                        c.refUserId.value,
                                                        data['data'][index]
                                                        ['product_id'],
                                                        data['data'][index]
                                                        ['unit_id'],
                                                        qty: textEditingController.text.toString(),
                                                        date: null,
                                                        fromTime: null,
                                                        toTime: null);
                                                    setState(() {
                                                      c.sqft.value = '';
                                                    });
                                                   onRefresh();
                                                 });
                                                },
                                                scheduleFunction: () async {
                                                  await getTimeSlots(
                                                          data['data'][index]
                                                              ['product_id'])
                                                      .then((value) {
                                                    Get.bottomSheet(BottomSheet(
                                                        onClosing: () {
                                                      setState(() {
                                                        c.timeSlot.value = '';
                                                        c.currentTimeSelected
                                                            .value = '';
                                                      });
                                                    }, builder: (context) {
                                                      dynamic date;
                                                      return Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                           Row(
                                                             mainAxisAlignment: MainAxisAlignment.start,

                                                             children: [
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
                                                            SizedBox(height: 50),
                                                          _dateSelection(),
                                                          SizedBox(height: 20),
                                                          TimeSlotsSelection(
                                                              slots: value),
                                                          SizedBox(height: 20),
                                                          ServiceButton(
                                                            buttonText:
                                                                'Proceed',
                                                            onTap: () async {

                                                              await addItemToCart(
                                                                      c.refUserId,
                                                                      data['data']
                                                                              [index]
                                                                          [
                                                                          'product_id'],
                                                                      data['data']
                                                                              [index]
                                                                          [
                                                                          'unit_id'],
                                                                      qty: null,
                                                                      date: c.dateSelected.value,
                                                                      fromTime: c
                                                                          .timeSlot
                                                                          .value,
                                                                      toTime:
                                                                          c.totime.value
                                                                      // null,
                                                                      // date
                                                                      //     .toString()
                                                                      //     .split(
                                                                      //         ' ')
                                                                      //     .first,
                                                                      // c.timeSlot
                                                                      //     .value,
                                                                      // null
                                                                      )
                                                                  .then(
                                                                      (value) {

                                                                  c.screenIndex.value ==2;
                                                                  Navigator.pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => HomeScreen()));

                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            color: const Color
                                                                    .fromARGB(
                                                                255, 121, 6, 6),
                                                          )
                                                        ],
                                                      );
                                                    })).then((value) {

                                                      setState(() {
                                                        c.timeSlot.value = '';
                                                        c.currentTimeSelected
                                                            .value = '';

                                                      });
                                                      onRefresh();
                                                    });
                                                  });

                                                },
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ))),
      ),
    );
  }

  updatedetails(int index){

    getCartItems(c.refUserId.value).then((value) {
      setState(() {
        data = value;
      });
    });

  }

  updateCart(int index,String unit,
      context, ht, wd,textEditingController, setState) async {
    Controller c = Get.put(Controller());
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
                      "Enter Quantity",
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
                                 onChanged: (value){
                                  setState((){
                                   textEditingController.text = value.toString();
                                  });
                                 },
                                 onEditingComplete: () {
                                   setState((() {
                                     c.sqft.value = textEditingController
                                         .text
                                         .toString();
                                   }));
                                 },
                              )),
                          GestureDetector(
                            onTap: (() {
                              var value = int.parse(textEditingController.text) - 1;
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
                      onTap: () {
                         setState(() {
                           c.sqft.value = textEditingController.text.toString();
                           getCartItems(c.refUserId.value).then((value) {
                             setState(() {
                               data = value;
                               updatedetails(index);
                               Get.back();
                             });
                           });
                         });
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

  Widget _dateSelection(){
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

class CartItemListTile extends StatefulWidget {
  const CartItemListTile(
      {required this.data,
      required this.index,
      this.refresh,
      required this.areaFunction,
      required this.scheduleFunction,
      key, required this.updated_price})
      : super(key: key);
  final dynamic data;
  final int index;
  final String updated_price;
  final dynamic areaFunction;
  final dynamic scheduleFunction;
  final dynamic refresh;

  @override
  State<CartItemListTile> createState() => _CartItemListTileState();
}

class _CartItemListTileState extends State<CartItemListTile> {
  TextEditingController textEditingController =
      TextEditingController(text: '1');
  final Controller c = Get.put(Controller());
  String initial_price = '';
  dynamic data;

  @override
  void initState() {
    // TODO: implement initState
    textEditingController.text = widget.data["data"][widget.index]['quantity'];
    getUpdatedPrice(widget.data["data"][widget.index]['product_id'],widget.data["data"][widget.index]['unit_id'],widget.data["data"][widget.index]['quantity']).then((value) {
      setState(() {
        initial_price = value["data"]["total_amount"].toString();
      });
    });
    super.initState();
  }

  updatedetails(int index){
    getCartItems(c.refUserId.value).then((value) {
      setState(() {
        data = value;
        getUpdatedPrice(widget.data["data"][widget.index]['product_id'],widget.data["data"][widget.index]['unit_id'],textEditingController.text.toString()).then((value) {
          setState(() {
            initial_price = value["data"]["total_amount"].toString();

          });
        });

        addItemToCart(
            c.refUserId,
            widget.data["data"][widget.index]['product_id'],
            widget.data["data"][widget.index]['unit_id'],
            qty: textEditingController.text)
            .then((value) {

        });

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    final double ht = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: wd / 6,
                  child: Padding(
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
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Row(
                          // mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: SizedBox(
                                width: wd / 1.5,
                                child: Text(
                                  // "",
                                  widget.data["data"][widget.index]
                                      ["product_name"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Color(0xff5C5C5C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.asset(
                                  'assets/icons/icons_png/066-delete.png',
                                  height: 15,
                                  width: 15,
                                ),
                              ),
                              onTap: () async {
                                await removeCartItem(
                                        c.refUserId.value,
                                        widget.data['data'][widget.index]
                                                ['cart_id']
                                            .toString())
                                    .then((value) {
                                  widget.refresh();
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: wd / 1.8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data["data"][widget.index]
                                        ['product_summary']
                                    .toString(),
                                style: const TextStyle(
                                    color: Color(0xff7E7D7D),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                                maxLines: 3,
                                // widget.activeBooking == true ? 2 : 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              '₹'+ initial_price,
                              style: const TextStyle(
                                  color: Color(0xff38456C),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff5C5C5C),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: (() {
                                    var value =
                                        int.parse(textEditingController.text) - 1;
                                    setState(
                                          () {
                                        textEditingController.text = value.toString();
                                        c.sqft.value = value.toString();
                                        updatedetails(widget.index);
                                        _updatedetails(widget.index);
                                      },
                                    );
                                  }),
                                  child: const Card(
                                    shape: CircleBorder(),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      child: Icon(
                                          Icons.minimize_sharp
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: ht / 16,
                                    width: wd / 8,
                                    child: TextFormField(
                                      // initialValue: "0",
                                      textAlign: TextAlign.center,
                                      controller: textEditingController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none
                                      ),
                                      onEditingComplete: () {
                                        setState((() {
                                          c.sqft.value = textEditingController
                                              .text
                                              .toString();
                                          updatedetails(widget.index);

                                        }));
                                      },
                                    )),
                                GestureDetector(
                                  onTap: (() {
                                    var value =
                                        int.parse(textEditingController.text) + 1;
                                    setState(
                                          () {
                                        textEditingController.text = value.toString();
                                        c.sqft.value = value.toString();
                                        updatedetails(widget.index);
                                        _updatedetails(widget.index);
                                      },
                                    );
                                  }),
                                  child: const Card(
                                    shape: CircleBorder(),
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff1FD0C2),
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                width: 120,
                                height: 41,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.data['data'][widget.index]['unit_name'].toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xff5C5C5C)),
                                    ),
                                    Text(
                                      widget.data['data'][widget.index]['dispval'].toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xff5C5C5C)),
                                    ),
                                   /* Text(
                                        "Quantity - "+widget.data['data'][widget.index]['quantity']
                                        //  c.sqft.value
                                        ,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff7E7D7D),
                                            fontWeight: FontWeight.normal)
                                    ), */
                                  ],
                                ),
                              )
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              onTap: () {
                                widget.scheduleFunction();
                              },
                              child: CartItemScheduleWidget(
                                data: widget.data,
                                index: widget.index,
                              ))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Divider()
          ],
        ),
      ),
    );
  }

  _updatedetails(int index){
    getUpdatedPrice(widget.data["product_id"], widget.data['data'][index]['unit_id'].toString(),textEditingController.text.toString()).then((value) {
      setState(() {
        initial_price = value["data"]["total_amount"].toString();
      });
    });
  }
}

class CartItemAreawidget extends StatefulWidget {
  const CartItemAreawidget({
    required this.data,
    required this.index,
    Key? key,
  }) : super(key: key);
  final dynamic data;
  final dynamic index;

  @override
  State<CartItemAreawidget> createState() => _CartItemAreawidgetState();
}

class _CartItemAreawidgetState extends State<CartItemAreawidget> {

  TextEditingController textEditingController = TextEditingController(text: '1');
  final Controller c = Get.put(Controller());

  dynamic data;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff1FD0C2),
          ),
          borderRadius: BorderRadius.circular(10)),
      width: 150,
      height: 41,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
             widget.data['data'][widget.index]['unit_name'].toString()+" - "+widget.data['data'][widget.index]['dispval'].toString(),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color(0xff5C5C5C)),
          ),
          Text(
              "Quantity - "+widget.data['data'][widget.index]['quantity']
              //  c.sqft.value
              ,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff7E7D7D),
                  fontWeight: FontWeight.normal)
          ),
        ],
      ),
    );
  }


}

class CartItemScheduleWidget extends StatelessWidget {
  const CartItemScheduleWidget(
      {required this.data, required this.index, Key? key})
      : super(key: key);
  final dynamic data;
  final dynamic index;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff1FD0C2),
          ),
          borderRadius: BorderRadius.circular(10)),
      width: 130,
      height: 41,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Schedule',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xff5C5C5C)),
          ),
          Text(data['data'][index]['service_date'] ?? 'Schedule Service',
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xff7E7D7D),
                  fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}


