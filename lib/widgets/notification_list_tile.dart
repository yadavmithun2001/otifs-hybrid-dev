import 'package:flutter/material.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem(
      {required this.height,
      required this.width,
      required this.data,
      required this.index,
      Key? key})
      : super(key: key);
  final double height;
  final double width;
  final dynamic data;
  final int index;
  @override
  Widget build(BuildContext context) {
    final double ht = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 114,
      width: 343,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.hardEdge,
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: wd / 16,
                ),
                SizedBox(
                  height: height,
                  width: width,
                  child: Image.asset(
                    "assets/icons/icons_png/002-bell.png",
                    color: const Color(0xff4C6D9A),
                  ),
                ),
                SizedBox(
                  width: wd / 18,
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['data'][index]['title'],
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5D5D5D)),
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      SizedBox(
                        width: wd / 1.5,
                        child: Text(
                          data['data'][index]['description'],
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff5D5D5D)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wd / 16),
              child: SizedBox(
                child: Text(
                  data['data'][index]['notification_date'],
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Color(0xffA2A2A2)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
