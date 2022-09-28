import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:stellar_track/Screens/subcategory_screen.dart';
import 'package:stellar_track/widgets/loader.dart';

import '../Screens/subcategory_screen1.dart';

class MainCategoriesList extends StatefulWidget {
  const MainCategoriesList({required this.data, Key? key}) : super(key: key);
  final dynamic data;
  @override
  State<MainCategoriesList> createState() => _MainCategoriesListState();
}

class _MainCategoriesListState extends State<MainCategoriesList> {
  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;

    return widget.data == null
        ? const Center(child: SizedBox(height:150,child: Loader()))
        : SizedBox(
            height: wd / 2.5,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.data["data"].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubcategoriesScreen1(
                                categoryId: widget.data["data"][index]["id"]
                                    .toString()),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Card(
                            color: Colors.transparent,
                            elevation: 0,
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              height: ht / 9.5,
                              width: wd / 5.4,
                              child: widget.data == null
                                  ? SizedBox(height:150,child: const Loader())
                                  : Image.network(
                                      widget.data["data"][index]
                                          ["banner_image"],
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: ProfileShimmer(),
                                        );
                                      },
                                      filterQuality: FilterQuality.low,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                          widget.data == null
                              ? SizedBox(height:150,child: const Loader())
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: wd / 4,
                                    child: Text(
                                      widget.data["data"][index]["name"],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Color(0xff5C5C5C)),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  );
                }),
          );
  }
}
