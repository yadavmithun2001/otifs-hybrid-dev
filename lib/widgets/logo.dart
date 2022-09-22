import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({required this.ht, Key? key}) : super(key: key);
  final double ht;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: ht / 4,
          width: ht / 8,
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
        const SizedBox(
          child: Text("Happy to Serve,\nAlways",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white)),
        )
      ],
    );
  }
}
