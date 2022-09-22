import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:get/get.dart';
import 'package:stellar_track/widgets/loader.dart';
import 'package:stellar_track/widgets/product_details_bottom_sheet.dart';

import '../api_calls.dart';

class PopularServicesHome extends StatefulWidget {
  const PopularServicesHome({required this.data, Key? key}) : super(key: key);
  final data;
  @override
  State<PopularServicesHome> createState() => _PopularServicesHomeState();
}

class _PopularServicesHomeState extends State<PopularServicesHome> {
  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;

    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.data["data"].length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: ht / 4,
            crossAxisSpacing: 0,
            mainAxisSpacing: ht / 36,
            crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: ht / 2,
            child: GestureDetector(
              onTap: (() async {
                var slots;
                var value;
                Get.dialog(SizedBox(height:150,child: const Loader()));

                await getProductDetails(
                        widget.data["data"][index]["product_id"])
                    .then(
                  (item) {
                    setState(() {
                      value = item;
                    });
                  },
                );
                await getTimeSlots(widget.data["data"][index]["product_id"])
                    .then((value) {
                  setState(() {
                    slots = value;
                  });
                  Get.close(1);
                });

                bottomSheet(context, value["data"][0], slots);
              }),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    child: SizedBox(
                      height: ht / 5.8,
                      width: wd / 2.34,
                      child: Image.network(
                        widget.data["data"][index]["product_image"],
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: SizedBox(
                              height: 150,
                              child: ProfileShimmer(),
                            ),
                          );
                        },
                        filterQuality: FilterQuality.low,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: wd / 4.6,
                    child: Text(
                      widget.data["data"][index]["product_name"].toString(),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xff5C5C5C),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
