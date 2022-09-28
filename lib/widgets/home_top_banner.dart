import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:stellar_track/widgets/loader.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({required this.data, Key? key}) : super(key: key);
  final data;
  @override
  Widget build(BuildContext context) {
    return data == null
        ? SizedBox(height:150,child: Loader())
        : CarouselSlider.builder(
            itemCount: data["data"].length,
            options: CarouselOptions(
                enableInfiniteScroll: true,
                viewportFraction: 1,
                enlargeCenterPage: true),
            itemBuilder: ((context, index, realIndex) {
              return Container(
                child: Image.network(
                  data["data"][index]["banner_image"],
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: ProfilePageShimmer(),
                    );
                  },
                  fit: BoxFit.contain,
                ),
              );
            }),
          );
  }
}
