import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/mobile_field.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../controllers.dart';
import '../main.dart';
import '../widgets/carousel.dart';
import 'Main Screens/home_page.dart';

class TransferAccount extends StatefulWidget {
  const TransferAccount({Key? key}) : super(key: key);

  @override
  State<TransferAccount> createState() => _TransferAccountState();
}

class _TransferAccountState extends State<TransferAccount> {
  @override
  void initState() {
    // TODO: implement initState
    getProfileDetails(c.refUserId.value).then((value) {
      setState(() {
        data = value;
      });
    });
    super.initState();
  }

  var data;
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
        body: data == null
            ? Center(child: ShimmerLoader(height: 60, width: wd))
            : Container(
                height: ht,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text(
                            "Transfer Account",
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
                    Text(
                      "Current Number:"
                      '${data['data'][0]['mobile'].toString()}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff38456C),
                          fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                          width: wd,
                          child: const Text(
                            'Enter a new phone number to initiate the transfer of your account to a new number. Please note that account cannot be transferred to existing account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Color(0xff7E7D7D),
                                fontSize: 14),
                          )),
                    ),
                    MObileField(
                      onboarding: false,
                      color: Colors.white,
                      textColor: Colors.black,
                      transfer: true,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
