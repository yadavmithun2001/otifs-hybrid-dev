import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stellar_track/widgets/logo.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({required this.height, required this.width, Key? key})
      : super(key: key);
  final double height, width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: width,
        child: const Shimmer(
            child: Center(
              child: Center(
                child: Text(
                  "OTIFS",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Colors.white),
                ),
              ),
            ),
            gradient: LinearGradient(colors: [
              Color(0xff38456C),
              Colors.white,
            ])));
  }
}

class LocationShimmer extends StatelessWidget {
  const LocationShimmer({required this.height, required this.width,required this.string, Key? key})
      : super(key: key);
  final double height, width;
  final String string;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child:  Shimmer(
            direction: ShimmerDirection.ltr,
            period:const Duration(milliseconds: 800),
            child: Center(
              child: Center(
                child: Text(
                  string,
                  style:const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
            gradient:const LinearGradient(colors: [
              Color(0xff38456C),
              Colors.white,
            ])));
  }
}
