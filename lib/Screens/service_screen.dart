
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stellar_track/Screens/Main%20Screens/cart_screen.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/main.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../controllers.dart';
import '../widgets/service_list.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen(
      {required this.mainCatID,
      required this.subCatID,
      required this.mainCatImage,
      Key? key})
      : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();

  final dynamic mainCatID;
  final dynamic subCatID;
  final dynamic mainCatImage;
}

class _ServiceScreenState extends State<ServiceScreen> {
  final Controller c = Get.put(Controller());
   dynamic servicesData;
  @override
  void initState() {
    super.initState();
    getServices(getStorage.read('refUserId'), widget.mainCatID, widget.subCatID)
        .then((value) {
      setState(() {
        servicesData = value;
      });
    });
  }

  onRefresh() {
   
    getServices(getStorage.read('refUserId'), widget.mainCatID, widget.subCatID)
        .then((value) {
      setState(() {
        servicesData = value;
      });
    }).then((value) => refreshController.refreshCompleted());
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
   

    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Obx(
        () => Scaffold(
          // bottomNavigationBar: SizedBox(
          //     height: wd / 4.8,
          //     child: BottomNavigation(
          //       height: wd / 4.8,
          //     )),
          // resizeToAvoidBottomInset: false,
          // floatingActionButton: BottomNavigation(),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            leadingWidth: 40,
            leading: Container(
              height: 5,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  c.screenIndex.value = 2;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()
                  ));
                },
                child: Padding(
                  padding: EdgeInsets.all(wd / 20),
                  child: Badge(
                    showBadge: true,
                    ignorePointer: true,
                    badgeColor: const Color(0xff1FD0C2),
                    badgeContent: Text(
                      c.cartCount.value.toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    child: Image.asset(
                      "assets/icons/BottomNav/cart.png",
                      color: const Color(0xff38456C),
                      height: 22,
                    ),
                  ),
                ),
              )
            ],
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
          body: servicesData == null
              ? Center(
                  child: ShimmerLoader(
                  width: wd,
                  height: 50,
                ))
              : servicesData['response']['message'] == 'Data not available'
                  ? const Center(child: Text('No Services available'))
                  : SizedBox(
                      height: ht,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: wd / 2,
                              width: wd,
                              child: Image.network(
                                widget.mainCatImage,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                fit: BoxFit.contain,
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 30),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    servicesData["data"][0]["category_name"]
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
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
                               /* const Padding(
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
                          Expanded(
                            // height: ht / 1.7,
                            child: ListView.builder(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                itemCount: servicesData["data"].length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  var added = servicesData["data"][index]
                                              ["added_cart"] ==
                                          '1'
                                      ? true
                                      : false;
                                  return ServiceList(
                                    data: servicesData,
                                    index: index,
                                    added: added,
                                    refreshFunction: () {
                                      onRefresh();
                                    },
                                  );
                                })),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
