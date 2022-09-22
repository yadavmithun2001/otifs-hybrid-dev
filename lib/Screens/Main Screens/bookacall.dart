import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as Url_Lanccher;

class BookACallPage extends StatefulWidget {
  const BookACallPage({Key? key}) : super(key: key);

  @override
  State<BookACallPage> createState() => _BookACallPageState();
}

class _BookACallPageState extends State<BookACallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
