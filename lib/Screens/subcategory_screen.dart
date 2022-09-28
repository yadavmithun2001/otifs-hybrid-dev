import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stellar_track/Screens/service_screen.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../controllers.dart';
import '../main.dart';

class SubcategoriesScreen extends StatefulWidget {
  const SubcategoriesScreen({required this.categoryId, Key? key})
      : super(key: key);
  final String categoryId;
  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  Controller c = Get.put(Controller());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubcategories(widget.categoryId).then((value) {
      setState(() {
        data = value;
      });
    });
  }

  var data;

  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: SizedBox(
        //       height: wd / 4.8,
        //       child: BottomNavigation(
        //         height: wd / 4.8,
        //       )),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 40,
          leading: Container(
            height: 5,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: data == null
            ? Center(
                child: ShimmerLoader(
                height: 100,
                width: wd,
              ))
            : SizedBox(
                height: ht,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: wd / 2,
                        width: wd,
                        child: Image.network(
                          data["data"][0]['main_category_image'],
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          fit: BoxFit.contain,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              data["data"][0]["main_category_name"],
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: GestureDetector(
                              onTap: (){
                                c.screenIndex.value = 1;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()
                                )
                                );
                              },
                              child: Image.asset(
                                "assets/AppBarCall.png",
                                // width: 30,
                                height: 20,
                              ),
                            ),
                          ),
                         /* const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0),
                            child: Icon(
                              Icons.bookmark,
                              size: 20,
                            ),
                          ), */
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: data["data"][0]["sub_categories"].length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => ServiceScreen(
                                        mainCatImage: data["data"][0]
                                        ["sub_categories"][index]
                                        ["sub_category_image"],
                                        mainCatID: widget.categoryId,
                                        subCatID: data["data"][0]
                                                ["sub_categories"][index]
                                            ["sub_category_id"],
                                      )),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: Card(
                                child: SubCategoryListItem(
                                  data: data,
                                  index: index,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class SubCategoryListItem extends StatelessWidget {
  const SubCategoryListItem({required this.data, required this.index, Key? key})
      : super(key: key);
  final dynamic data;
  final int index;
  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
                data["data"][0]["sub_categories"][index]
                ["sub_category_image"],
                fit: BoxFit.contain,
                height: ht / 14,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                width: wd / 4,

              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: wd,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data["data"][0]["sub_categories"][index]
                                      ["sub_category_name"]
                                  .toString(),
                              style: const TextStyle(
                                  color: Color(0xff5C5C5C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.arrow_right))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: Text(
                      data["data"][0]["sub_categories"][index]["services_count"]
                              .toString() +
                          " Services",
                      style: const TextStyle(
                          color: Color(0xffBABABA),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Text(
                      data["data"][0]["sub_categories"][0]
                              ["sub_category_summary"]
                          .toString(),
                      style: const TextStyle(
                          color: Color(0xff7E7D7D),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        // const Divider(
        //   thickness: 2,
        // )
      ],
    );
  }
}
