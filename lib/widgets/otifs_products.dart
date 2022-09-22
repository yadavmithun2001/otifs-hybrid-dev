import 'package:flutter/material.dart';
import 'package:stellar_track/widgets/home_and_personal_service.dart';
import 'package:stellar_track/widgets/loader.dart';

class OtifsProducts extends StatefulWidget {
  const OtifsProducts({this.title, required this.color, Key? key})
      : super(key: key);

  @override
  State<OtifsProducts> createState() => _OtifsProductsState();
  final String? title;
  final Color color;
}

class _OtifsProductsState extends State<OtifsProducts> {
  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;

    return Container(
      color: widget.color,
      width: wd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title == null ? "" : widget.title!,
            style: const TextStyle(color: Colors.black87, fontSize: 18),
          ),
          SizedBox(
            width: wd,
            height: wd / 2.5,
            child: homeService == null
                ? const Loader()
                : ListView.builder(
                    itemCount: homeService.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // itemExtent: wd / 4,
                    itemBuilder: ((context, index) {
                      return Row(
                        children: [
                          Column(
                            children: [
                              Image.network(
                                homeService[index]["banner_image"],
                                height: wd / 5,
                                width: wd / 5,
                              ),
                              Text(
                                homeService[index]["name"],
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          const VerticalDivider()
                        ],
                      );
                    })),
          ),
        ],
      ),
    );
  }
}
