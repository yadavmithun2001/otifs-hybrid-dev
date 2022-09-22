import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: SizedBox(
                      height: ht / 38,
                      width: ht / 38,
                      child: Image.asset("assets/icons/icons_png/001-pin.png")),
                ),
                c.address[""] == ""
                    ? const Text(
                        "Select Address",
                        style: TextStyle(
                            color: Color(0xff5C5C5C),
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      )
                    : Text(
                        c.addressType.value == "H"
                            ? "Home"
                            : c.addressType.value == "O"
                                ? "Office"
                                : "Custom",
                        style: const TextStyle(
                            color: Color(0xff5C5C5C),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
              ],
            ),
            c.address[""] == ""
                ? Container()
                : Text(
                    "${c.address["Address"]}, ${c.address["Sub_locality"]},${c.address["City"]},${c.address["State"]},${c.address["Country"]},${c.address["Postal_code"]}",
                    style: const TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
          ],
        ),
      ),
    );
  }
}
