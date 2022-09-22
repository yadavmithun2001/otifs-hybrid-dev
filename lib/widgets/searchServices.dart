import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/product_details_bottom_sheet.dart';

import '../controllers.dart';
import 'loader.dart';

class SearchServices extends SearchDelegate {
  final Controller c = Get.put(Controller());
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> serviceSuggested = c.allServicesMap.keys
        .toList()
        .where((service) => service.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
        itemCount: serviceSuggested.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              var slots;
              var prodID;
              var value;

              prodID = c.allServicesMap.value[serviceSuggested[index]];

              Get.dialog(const Loader());
              await getProductDetails(prodID).then(
                (item) {
                  value = item;
                },
              );
              await getTimeSlots(prodID).then((value) {
                slots = value;

                Get.close(1);
                close(context, query);
              });
              bottomSheet(context, value["data"][0], slots);
            },
            title: Text(serviceSuggested[index]),
          );
        });
  }
}
