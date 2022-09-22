
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  @override
  void initState() {
    getCartItems(c.refUserId.value).then((value) {
      setState(() {
        data = value;
      });
    });
    super.initState();
  }

  onRefresh() {
    getCartItems(c.refUserId.value).then((value) {
      setState(() {
        data = value;
      });
    }).then((value) => _refreshController.refreshCompleted());
  }

  int index = 0;
  TextEditingController textEditingController =
      TextEditingController(text: '0');
  final Controller c = Get.put(Controller());
  // final Controller c = Get.put(Controller());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
                                isCart: true,
                                isBottomNav: true,
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
                                isCart: true,
                                isBottomNav: true,
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
                                            child: Image.asset(
                                              "assets/AppBarCall.png",
                                              width: wd / 10,
                                              height: 20,
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
                                                index: index,
                                                refresh: () {
                                                  onRefresh();
                                                },
                                                areaFunction: () async {
                                                  await addUnitsDialog(
                                                    '',
                                                          context,
                                                          ht,
                                                          wd,
                                                          textEditingController,
                                                          c,
                                                          setState)
                                                      .then((value) async {
                                                    await addItemToCart(
                                                        c.refUserId.value,
                                                        data['data'][index]
                                                            ['product_id'],
                                                        data['data'][index]
                                                            ['unit_id'],
                                                        qty: c.sqft.value,
                                                        date: null,
                                                        fromTime: null,
                                                        toTime: null);

                                                    setState(() {
                                                      c.sqft.value = '';
                                                    });
                                                  });
                                                  onRefresh();
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
                                                        children: [
                                                          SfDateRangePicker(
                                                            onSelectionChanged:
                                                                (dateRangePickerSelectionChangedArgs) {
                                                              date =
                                                                  dateRangePickerSelectionChangedArgs
                                                                      .value;
                                                            },
                                                          ),
                                                          TimeSlotsSelection(
                                                              slots: value),
                                                          ServiceButton(
                                                            buttonText:
                                                                'Proceed',
                                                            onTap: () async {
                                                            

                                                              await addItemToCart(
                                                                      c
                                                                          .refUserId,
                                                                      data['data']
                                                                              [index]
                                                                          [
                                                                          'product_id'],
                                                                      data['data']
                                                                              [index]
                                                                          [
                                                                          'unit_id'],
                                                                      qty: null,
                                                                      date: date
                                                                          .toString()
                                                                          .split(
                                                                              ' ')
                                                                          .first,
                                                                      fromTime: c
                                                                          .timeSlot
                                                                          .value,
                                                                      toTime:
                                                                          null
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
                                                                if (widget
                                                                        .isBottomNav ==
                                                                    true) {
                                                                  setState(() {
                                                                    c.screenIndex
                                                                        .value = 0;
                                                                  });
                                                                } else {
                                                                  Navigator.pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const HomeScreen()));
                                                                }
                                                              });
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
}

class CartItemListTile extends StatefulWidget {
  const CartItemListTile(
      {required this.data,
      required this.index,
      this.refresh,
      required this.areaFunction,
      required this.scheduleFunction,
      key})
      : super(key: key);
  final dynamic data;
  final int index;
  final dynamic areaFunction;
  final dynamic scheduleFunction;
  final dynamic refresh;
  @override
  State<CartItemListTile> createState() => _CartItemListTileState();
}

class _CartItemListTileState extends State<CartItemListTile> {
  TextEditingController textEditingController =
      TextEditingController(text: '0');
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    // final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
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
                              '₹' +
                                  widget.data['data'][widget.index]['price']
                                      .toString(),
                              style: const TextStyle(
                                  color: Color(0xff38456C),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              onTap: () {
                                widget.areaFunction();
                              },
                              child: CartItemAreawidget(
                                data: widget.data,
                                index: widget.index,
                              )),
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
}

class CartItemAreawidget extends StatelessWidget {
  const CartItemAreawidget({
    required this.data,
    required this.index,
    Key? key,
  }) : super(key: key);
  final dynamic data;
  final dynamic index;
  @override
  Widget build(BuildContext context) {
    // final Controller c = Get.put(Controller());
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff1FD0C2),
          ),
          borderRadius: BorderRadius.circular(10)),
      width: 121,
      height: 38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Sq Feet',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xff5C5C5C)),
          ),
          Text(
              data['data'][index]['quantity'] ?? 'Select area'
              //  c.sqft.value
              ,
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xff7E7D7D),
                  fontWeight: FontWeight.normal)),
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
      width: 121,
      height: 38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
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
