import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/Screens/add_address_screen.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/add_new_address.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../controllers.dart';
import '../main.dart';
import '../widgets/carousel.dart';
import 'Main Screens/home_page.dart';

class Addresses extends StatefulWidget {
  const Addresses({Key? key}) : super(key: key);

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  dynamic addresseslist;
  final Controller c = Get.put(Controller());
  @override
  void initState() {
    super.initState();
    listUserAddresses(c.refUserId.value,null).then((value) {
      setState(() {
        addresseslist = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
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
        ),
        body: SingleChildScrollView(
          child: Column(
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
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      "Addresses",
                      style: TextStyle(color: Color(0xff5C5C5C), fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: wd / 18.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap:(){
                            c.screenIndex.value = 1;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()
                            )
                            );
                          },
                          child: Image.asset(
                            "assets/icons/icons_png/004-headphones.png",
                            color: const Color(0xff38456C),
                            width: wd / 10,
                            height: 20,
                          ),
                        ),
                        SizedBox(
                          width: wd / 17,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const AddAddress()));
                          },
                          child: Image.asset(
                            "assets/icons/icons_png/064-plus.png",
                            color: const Color(0xff38456C),
                            width: wd / 10,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              addresseslist["status"] == "failure"
                  ? Center(child: Text(
                  'No address found!'
                 )
              )
                  : SizedBox(
                      height: ht / 1.5,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: wd / 15),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: addresseslist["data"].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: AddressesListTile(
                                address:
                                    '${addresseslist["data"][index]['address1']}, ${addresseslist['data'][index]['city_name']}, ${addresseslist['data'][index]['state_name']}, ${addresseslist['data'][index]['pincode']}',
                                addressType: addresseslist["data"][index]
                                    ['address_type_desc'],
                              ),
                            );
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class AddressesListTile extends StatelessWidget {
  const AddressesListTile(
      {required this.address, required this.addressType, Key? key})
      : super(key: key);
  final String address;
  final String addressType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address,
          style: const TextStyle(fontSize: 14, color: Color(0xff5C5C5C)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xff1FD0C2),
              ),
              Text(
                addressType,
                style: const TextStyle(fontSize: 14, color: Color(0xff1FD0C2)),
              )
            ],
          ),
        ),
        const Divider()
      ],
    );
  }
}
