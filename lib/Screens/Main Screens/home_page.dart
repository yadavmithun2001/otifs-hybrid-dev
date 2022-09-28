import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/functions.dart';
import 'package:stellar_track/widgets/app_bar.dart';
import 'package:stellar_track/widgets/carousel.dart';
import 'package:stellar_track/widgets/home_and_personal_service.dart';
import 'package:stellar_track/widgets/home_top_banner.dart';
import 'package:stellar_track/widgets/loader.dart';
import 'package:stellar_track/widgets/main_categories_list.dart';
import 'package:stellar_track/widgets/popular_services.dart';
import 'package:stellar_track/widgets/searchServices.dart';
import 'package:stellar_track/widgets/service_button.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../../api_calls.dart';
import '../../controllers.dart';

dynamic mainCatData;
dynamic mainAndSubCategories;
dynamic popularServices;
dynamic banners;
dynamic summerSpecial;
dynamic onGoingOffers;
dynamic currentLocation;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();
// add default select address
    if (c.defaultAddressId.value != "") {
      listUserAddresses(c.refUserId.value, c.defaultAddressId.value)
          .then((value) {
        selectExistingAddress(c, value, 0, setState);
      });
    }
    if (c.address[""] == "") {
      try {
        saveAddress(setState).then((value) {
          setState(() {
            c.address.value = value;
          });
        });
      } catch (e) {
        log(e.toString());
      }
    } else {
      null;
    }

    updateCartCount(setState, c);

    getSeasonalOffers().then((value) {
      setState(() {
        summerSpecial = value;
      });
    });

    getOngoingOffers().then((value) {
      setState(() {
        onGoingOffers = value;
      });
    });

    getHomeBanners().then(((value) {
      setState(() {
        banners = value;
      });
    }));
    getMainCategories().then((value) {
      setState(() {
        mainCatData = value;
      });
    });
    getPopularServices().then((value) {
      setState(() {
        popularServices = value;
      });
    });

    getMainAndSubCategories().then((value) {
      setState(() {
        mainAndSubCategories = value;
      });
    });

    getDateTime().then((value) {
      setState(() {
        c.date.value = value.toString().substring(0, 10);
        c.weekday.value = value.weekday.toString();
        c.month.value = (value.month - 1).toString();
      });
    });

    getPaymentMethods().then((paymentModes) {
      List<String> modes = [];
      List<String> modeCodes = [];
      for (int index = 0; index < paymentModes['data'].length; index++) {
        modes.add(paymentModes['data'][index]['payment_mode_desc'].toString());
        modeCodes
            .add(paymentModes['data'][index]['payment_mode_code'].toString());
        setState(() {
          c.paymentMethods.value = modes;
          c.paymentMethodCodes.value = modeCodes;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: const AppBarWidget(),
          preferredSize: Size(wd, ht / 16),
        ),
        body: mainCatData == null ||
                mainAndSubCategories == null ||
                popularServices == null ||
                banners == null ||
                summerSpecial == null ||
                onGoingOffers == null
            ? Center(
                child: SizedBox(
                  height: ht / 4,
                  width: wd / 2,
                  child: ShimmerLoader(height: ht / 4, width: wd / 2),
                ),
              )
            : SizedBox(
                height: ht,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image.asset("assets/HomeBanner.png"),
                        HomeBanner(data: banners),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 10, bottom: 10),
                          child: Text(
                            "What services you need?",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        MainCategoriesList(
                          data: mainCatData,
                        ),
                        // SEARCH BAR
                        GestureDetector(
                          onTap: () {
                            showSearch(
                                context: context, delegate: SearchServices());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 20, bottom: 0),
                            child: Container(
                              height: 43,
                              decoration: BoxDecoration(
                                  color: const Color(0xffE5E5E5),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(children: const [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Icon(
                                    Icons.search_outlined,
                                    color: Color(0xff38456C),
                                  ),
                                ),
                                Text(
                                  "Search",
                                  style: TextStyle(color: Color(0xff7E7D7D)),
                                )
                              ]),
                            ),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 8.0, top: 20, right: 8.0),
                          child: Text(
                            "Popular services",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        //popular services
                        popularServices == null
                            ? const Center(child: Loader())
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child:
                                    PopularServicesHome(data: popularServices),
                              ),

                        //Popular Service BUtton
                        /* const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.0),
                          child: ServiceButton(
                            buttonText: "View all popular Services",
                          ),
                        ), */

                        //Ongoing Offers
                        onGoingOffers == null
                            ? SizedBox(height:150,child: const Loader())
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 28.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Text(
                                        "Ongoing Offers",
                                        style: TextStyle(
                                            color: Color(0xff5C5C5C),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    RewardCarousel(
                                      data: onGoingOffers,
                                    ),
                                  ],
                                ),
                              ),

                        //HOME SERVICE
                        mainAndSubCategories == null
                            ? const Loader()
                            : Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: HomeAndPersonalService(
                                  data: mainAndSubCategories,
                                  color: const Color(0xffF7F7F7),
                                  title: "Home Service",
                                ),
                              ),
                        summerSpecial['data'] == null
                            ? const Loader()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 28.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 10),
                                      child: Text(
                                        summerSpecial["data"][0]
                                            ["offer_type_name"],
                                        style: const TextStyle(
                                            color: Color(0xff5C5C5C),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    SeasonalOffersCarousel(
                                      data: summerSpecial,
                                    ),
                                  ],
                                ),
                              ),

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //   child: Container(
                        //     color: Colors.black12,
                        //     child: const OtifsProducts(
                        //       color: Colors.white70,
                        //       title: "OTIFS Products",
                        //     ),
                        //   ),
                        // ),

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //   child: Container(
                        //     color: Colors.black12,
                        //     child: const OtifsProducts(
                        //       color: Colors.white70,
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //   child: Column(
                        //     children: [
                        //       OtifsProducts(color: Colors.black.withOpacity(0.05)),
                        //       Container(
                        //           color: Colors.black.withOpacity(0.05),
                        //           child: const Padding(
                        //             padding: EdgeInsets.all(8.0),
                        //             child:
                        //                 ServiceButton(buttonText: "Check our products"),
                        //           ))
                        //     ],
                        //   ),
                        // ),
                        //Service Guarantee

                        Image.asset("assets/Service Guarantee.png"),
                        //
                        Image.asset(
                          "assets/addingHappiness.png",
                          fit: BoxFit.fill,
                          width: wd,
                        ),
                        SizedBox(
                          height: wd / 4,
                        ),

                        //
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
