import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:stellar_track/widgets/loader.dart';

class RewardCarousel extends StatelessWidget {
  const RewardCarousel(
      {required this.data, this.height, this.padEnds, this.viewPort, Key? key})
      : super(key: key);
  final data;
  final height;
  final viewPort;
  final bool? padEnds;
  @override
  Widget build(BuildContext context) {
    print(data);
    final wd = MediaQuery.of(context).size.width;
    // print("ppppppppppppppppppppppp" + data["data"].toString());
    return data == null
        ? SizedBox(height:150,child: Loader())
        : CarouselSlider.builder(
            itemCount: data["data"] == null ? 0 : data["data"].length,
            itemBuilder: ((context, index, realIndex) {
              return data["data"] == null
                  ? Container()
                  : SizedBox(
                      width: wd,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: Colors.white,
                        child: data["data"][index]["offer_image"] == null
                            ? Loader()
                            : Image.network(
                                data["data"][index]["offer_image"],
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: SizedBox(height:150,child: ProfileShimmer()),
                                  );
                                },
                                filterQuality: FilterQuality.low,
                                fit: BoxFit.fill,
                              ),
                      ),
                    );
            }),
            options: CarouselOptions(
                enlargeCenterPage: false,
                padEnds: padEnds ?? true,
                height: height ?? wd / 2.5,
                viewportFraction: viewPort ?? 0.9,
                enableInfiniteScroll: true));
  }
}

class SeasonalOffersCarousel extends StatelessWidget {
  const SeasonalOffersCarousel({required this.data, Key? key})
      : super(key: key);
  final data;
  @override
  Widget build(BuildContext context) {
    final wd = MediaQuery.of(context).size.width;
    print("SUMMERSSSSSSSSSSSS" + data["data"].toString());
    return data == null
        ? Loader()
        : Container(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  return CarouselSlider.builder(
                      itemCount: data["data"][index]["offers"].length,
                      itemBuilder: ((context, count, realIndex) {
                        return SizedBox(
                          width: wd,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: Colors.white,
                            child: Image.network(
                              data["data"][index]["offers"][count]
                                  ["offer_image"],
                              // loadingBuilder: ,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              filterQuality: FilterQuality.low,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }),
                      options: CarouselOptions(
                          enlargeCenterPage: false,
                          padEnds: true,
                          height: wd / 2.5,
                          viewportFraction: 0.9,
                          enableInfiniteScroll: true));
                })),
          );
  }
}
