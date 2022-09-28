import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  const Logo({required this.ht, Key? key}) : super(key: key);
  final double ht;

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: widget.ht / 4,
          width: widget.ht / 8,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const Center(
            child: Text(
              "OTIFS",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xff38456C)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text("Happy to Serve,\nAlways",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.white)
            ),
        ),


      ],
    );
  }
}
