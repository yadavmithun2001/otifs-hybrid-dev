import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart' as Url_Lanccher;

import '../../controllers.dart';
import '../../main.dart';
import '../../widgets/bottom_nav.dart';

class BookACallPage extends StatefulWidget {
  const BookACallPage({Key? key}) : super(key: key);

  @override
  State<BookACallPage> createState() => _BookACallPageState();
}

class _BookACallPageState extends State<BookACallPage> {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: EdgeInsets.only(left: wd / 60.0),
          child: Container(
            // height: ht / 10,
            child: GestureDetector(
              onTap: () {
                c.screenIndex.value = 0;
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: const Card(
                shape: CircleBorder(),
                elevation: 3,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
          ),
        ),

        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'For offline Bookings please call on ',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Url_Lanccher.launch("tel://+91 7605096831");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Text(
                            'Call +91 7605096831',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
