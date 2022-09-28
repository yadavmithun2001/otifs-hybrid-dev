import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stellar_track/Screens/add_address_screen.dart';
import 'package:stellar_track/api_calls.dart';
import 'package:stellar_track/functions.dart';
import 'package:stellar_track/widgets/service_button.dart';

import '../Screens/addresses.dart';
import '../controllers.dart';
import 'add_new_address.dart';

class SelectAddressBottomSheet extends StatefulWidget {
  const SelectAddressBottomSheet({required this.data, Key? key})
      : super(key: key);
  final dynamic data;
  @override
  State<SelectAddressBottomSheet> createState() =>
      SelectAddressBottomSheetState();
}

class SelectAddressBottomSheetState extends State<SelectAddressBottomSheet> {
  Controller c = Get.put(Controller());

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;
    return BottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        enableDrag: false,
        onClosing: () {},
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            elevation: MaterialStateProperty.all(5)),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Add address",
                            style: TextStyle(
                                color: Color(0xff5C5C5C),
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                widget.data["status"].toString() == "failure" ?
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 50),
                      child: Container(
                        child: Text('No address found, Kindly add a new Address'),
                      ),
                    ) :
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: ht / 2.5,
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: wd / 15),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.data["data"].length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  print(
                                      widget.data['data'][index]["address_id"]);
                                  c.addressType.value = widget.data['data'][index]["address_type"].toString();

                                  print(c.addressType.value.toString());
                                  selectExistingAddress(
                                          c, widget.data, index, setState)
                                      .then((value) => setDefaultAddressId(
                                          c.refUserId,
                                          widget.data['data'][index]
                                              ["address_id"]
                                     )
                                  );
                                  // c.addressID.value = widget.data['data'][index]
                                  //         ['address_id']
                                  //     .toString();
                                  // c.address["Address"] =
                                  //     widget.data["data"][index]['address1'];
                                  // c.address["City"] =
                                  //     widget.data['data'][index]['city_name'];
                                  // c.address["State"] =
                                  //     widget.data['data'][index]['state_name'];
                                  // c.address["Postal_code"] =
                                  //     widget.data['data'][index]['pincode'];
                                  // c.coordinates["lat"] =
                                  //     widget.data['data'][index]['latitude'];
                                  // c.coordinates["lng"] =
                                  //     widget.data['data'][index]['longitude'];
                                  // c.addressType.value = widget.data['data']
                                  //     [index]["address_type"];
                                },
                              );
                              Get.close(1);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                color: Colors.transparent,
                                width: wd,
                                child: AddressesListTile(
                                  address:
                                      '${widget.data["data"][index]['address1']}, ${widget.data['data'][index]['city_name']}, ${widget.data['data'][index]['state_name']}, ${widget.data['data'][index]['pincode']}',
                                  addressType: widget.data["data"][index]
                                      ['address_type_desc'],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                ServiceButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const AddAddress()));
                  },
                  buttonText: "ADD",
                  height: ht / 16,
                  width: wd / 3,
                )
              ],
            ),
          );
        });
  }
}
