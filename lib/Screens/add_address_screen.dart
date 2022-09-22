import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/controllers.dart';
import 'package:stellar_track/widgets/shimmer_loader.dart';

import '../functions.dart';
import '../main.dart';
import '../widgets/add_address_dialog.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  void initState() {
    saveAddress(setState).then((value) {
      setState(() {
        c.address.value = value;
      });
    });

    super.initState();
  }

  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xff38456C),
      body: SafeArea(
        child: Obx((() => SizedBox(
              height: ht,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: SizedBox(
                        height: ht / 1.8,
                        child: Image.asset(
                          "assets/housewife-woking-home-lady-blue-shirt-woman-bathroom.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      Text(
                        "Current Location",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  c.address["Address"] != null
                      ? Center(
                          child: SizedBox(
                            width: wd,
                            child: Text(
                              // add["Address"],
                              "${c.address["Address"]}, ${c.address["Sub_locality"]},${c.address["Locality"]},${c.address["State"]},${c.address["Country"]},${c.address["Postal_code"]}",
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                              maxLines: 4,
                              // overflow: TextOverflow.visible,
                            ),
                          ),
                        )
                      : LocationShimmer(
                          height: wd / 10,
                          width: wd / 2,
                          string: "Fetching location",
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => addAddressDialog(context, null),
                        child: const Text(
                          "ADD",
                          style:
                              TextStyle(color: Color(0xff1FD0C2), fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "CHANGE",
                          style:
                              TextStyle(color: Color(0xff1FD0C2), fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: wd / 15, vertical: ht / 50),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "SKIP",
                          style:
                              TextStyle(color: Color(0xff1FD0C2), fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ))),
      ),
    );
  }
}
