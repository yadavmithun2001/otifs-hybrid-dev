import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stellar_track/Screens/service_screen.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../controllers.dart';
import '../main.dart';

class SubcategoriesScreen1 extends StatefulWidget {
  const SubcategoriesScreen1({required this.categoryId, Key? key})
      : super(key: key);
  final String categoryId;
  @override
  State<SubcategoriesScreen1> createState() => _SubcategoriesScreen1State();
}

class _SubcategoriesScreen1State extends State<SubcategoriesScreen1> {
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
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                  ),
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
                        const EdgeInsets.all(7),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color(0xffe8e8e8)
                            ),

                            boxShadow:[BoxShadow(
                              color: Color(0xfffafafa),
                            ),]
                          ),
                          child: SubCategoryListItem1(
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

class SubCategoryListItem1 extends StatefulWidget {
  const SubCategoryListItem1({required this.data, required this.index, Key? key})
      : super(key: key);
  final dynamic data;
  final int index;

  @override
  State<SubCategoryListItem1> createState() => _SubCategoryListItem1State();
}

class _SubCategoryListItem1State extends State<SubCategoryListItem1> {
  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Image.network(
                widget.data["data"][0]["sub_categories"][widget.index]
                ["sub_category_image"],
                fit: BoxFit.contain,
                height: ht / 12,
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
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: wd,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.data["data"][0]["sub_categories"][widget.index]
                              ["sub_category_name"]
                                  .toString(),
                              style: const TextStyle(
                                  color: Color(0xff5C5C5C),
                                  fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 0),
                    child: Text(
                      widget.data["data"][0]["sub_categories"][widget.index]["services_count"]
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
                        horizontal: 0.0, vertical: 0),
                    child: Text(
                      widget.data["data"][0]["sub_categories"][widget.index]
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
          ],
        ),
        // const Divider(
        //   thickness: 2,
        // )
      ],
    );
  }
}
