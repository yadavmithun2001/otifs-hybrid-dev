// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:stellar_track/main.dart';
import 'package:flutter/material.dart';
import 'package:stellar_track/widgets/mobile_field.dart';
import 'package:stellar_track/widgets/otp_field.dart';
import 'api_calls.dart';
import 'controllers.dart';

Future determinePosition() async {
  // GeoCode geoCode = GeoCode();
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  var location = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
//  var address = location;
  final Controller c = Get.put(Controller());

  c.coordinates["lat"] = location.latitude.toString();
  c.coordinates["lng"] = location.longitude.toString();

  List<dynamic> address = await placemarkFromCoordinates(
    location.latitude,
    location.longitude,
  );
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return address;
}

Future getCoordinatesFromLocation(address) async {
  var coordinates = await locationFromAddress(address);
  // print(coordinates[0]);
  return coordinates;
}

Future savePhoneAndEmail(email, mobile) async {
  final Controller c = Get.put(Controller());
  c.email.value = email.toString();
  c.mobile.value = mobile.toString();
  return true;
}

Future getDateTime() async {
  DateTime dateToday = DateTime.now();

  dateToday = dateToday.add(const Duration(days: 1));

  return dateToday;
}

Future saveLoginStatus(refUserId) async {
  await getStorage.write('refUserId', refUserId);

  return true;
}

Future updateAddress(setState) async {
  var userAdderss;
  List addressMap = [];
  await determinePosition().then((value) {
    setState(() {
      userAdderss = value;
    });
  });
  List splittedAdd = userAdderss[0].toString().split(',');
  for (var element in splittedAdd) {
    addressMap.add(element.toString().split(':')[1]);
  }

  return addressMap;
}

Future saveAddress(setState) async {
  Map<String, String> add = {
    "Address": "",
    "Street_Name": "",
    "Sub_locality": "",
    "Locality": '',
    "City": '',
    "State": '',
    "Postal_code": '',
    "Country": ''
  };
  await updateAddress(setState).then((value) {
    setState(() {
      add["Address"] = value[0] == " " ? "Address" : value[0].trim();
      add["Street_Name"] = value[1] == " " ? "Street name" : value[1].trim();
      add["Sub_locality"] = value[8] == " " ? "Sub locality" : value[8].trim();
      add["Locality"] = value[7] == " " ? "Locality" : value[7].trim();
      add["City"] = value[6] == " " ? "City" : value[6].trim();
      add["State"] = value[5] == " " ? "State" : value[5].trim();
      add["Postal_code"] = value[4] == " " ? "Postal Code" : value[4].trim();
      add["Country"] = value[3] == " " ? "Country" : value[3].trim();
    });
  });

  return add;
}

onRefresh(mainCatID, subCatID, controller, setState, data) {
  getServices(getStorage.read('refUserId'), mainCatID, subCatID).then((value) {
    setState(() {
      data = value;
    });
  }).then((value) => controller.refreshCompleted());
}

updateCartCount(setState, c) async {
  getStorage.read('refUserId') == null
      ? null
      : await getCartCount(c.refUserId.value).then((count) {
          setState(() {
            c.cartCount.value = count['data'][0]['car_count'];
          });
        });
}

Future triggerSignInDialog(context, setState) async {
  final Controller c = Get.put(Controller());
  var ht = MediaQuery.of(context).size.height;
  // var wd = MediaQuery.of(context).size.width;
  var res;
  await Get.dialog(
    Obx(
      () => Dialog(
        child: SizedBox(
          height: ht / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: ht / 60),
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff38456C)),
                ),
              ),
              Visibility(
                visible: !c.otpField.value,
                child: MObileField(
                  onboarding: false,
                  color: Colors.cyan[50],
                  textColor: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ht / 50),
                child: Visibility(
                  visible: c.otpField.value,
                  child: OtpField(
                    onboarding: false,
                    color: Colors.cyan[50],
                    textColor: Colors.black,
                    phone: c.mobile.value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ).then((value) {
    c.otpField.value = false;
  });
  return res;
}

Future getAllServices() async {
  final Controller c = Get.put(Controller());
  Map<String, String> allServices = {};
  await getServices(c.refUserId.value, null, null).then((value) {
    for (var i = 0; i < value['data'].length; i++) {
      allServices.addAll({
        value["data"][i]["product_name"]:
            value["data"][i]["product_id"].toString()
      });
    }
  });

  return allServices;
}

Future selectExistingAddress(c,dynamic data,int index, setState) async {
  setState(() {
    c.addressID.value = data['data'][index]['address_id'].toString();
    c.address["address_type"] = data['data'][index]["address_type"];
    c.address["Address"] = data["data"][index]['address1'];
    c.address["City"] = data['data'][index]['city_name'];
    c.address["State"] = data['data'][index]['state_name'];
    c.address["Postal_code"] = data['data'][index]['pincode'];
    c.coordinates["lat"] = data['data'][index]['latitude'];
    c.coordinates["lng"] = data['data'][index]['longitude'];

  });
  return true;
}
