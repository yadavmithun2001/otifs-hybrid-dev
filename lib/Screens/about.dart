import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../controllers.dart';
import '../main.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/carousel.dart';
import 'Main Screens/home_page.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  dynamic aboutData;
  final Controller c = Get.put(Controller());
  @override
  void initState() {
    super.initState();
    getAboutUsDetails().then((value) {
      setState(() {
        aboutData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold( floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: ht / 14.5,
              child: BottomNavigation(
                height: ht / 14.5,
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
       
        appBar: AppBar(
          elevation: 0,
          leadingWidth: wd / 8,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: ht / 23.8,
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
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        extendBodyBehindAppBar: true,
        body: aboutData == null
            ? Center(child: ShimmerLoader(height: 60, width: wd))
            : Column(
                children: [
                  SizedBox(
                      height: ht / 5,
                      child: RewardCarousel(
                          viewPort: 1.0,
                          height: ht / 4,
                          padEnds: true,
                          data: onGoingOffers)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding:  EdgeInsets.all(18.0),
                        child: Text(
                          "About",
                          style:
                              TextStyle(color: Color(0xff5C5C5C), fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: GestureDetector(
                          onTap: (){
                            c.screenIndex.value = 1;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()
                            )
                            );
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: wd / 8, vertical: 10),
                    child: SizedBox(
                        width: wd,
                        child: Text(
                          aboutData["data"][0]["content"],
                          style:
                              const TextStyle(color: Color(0xff7E7D7D), fontSize: 12),
                        )),
                  )
                ],
              ),
      ),
    );
  }
}
