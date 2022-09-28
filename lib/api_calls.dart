// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'controllers.dart';

// fetches list of services

String apiHeader = "https://otifs.com/public";

Future getData() async {
  var request = http.Request(
      'GET', Uri.parse('https://www.otifs.com/api/b2c/services/list'));

  http.StreamedResponse response = await request.send();
  var data = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(data);
  } else {
    print(response.reasonPhrase);
  }
  return data;
}

//Fetches the list of services after adding main and sub-category
Future getServices(refUserId, mainCatId, subCatId) async {
  var request = http.Request(
      'GET',
      Uri.parse(refUserId == null
          ? '$apiHeader/api/hybrid/services/list?main_category_id=$mainCatId&sub_category_id=$subCatId'
          : mainCatId == null || subCatId == null
              ? '$apiHeader/api/hybrid/services/list?&ref_user_id=$refUserId'
              : '$apiHeader/api/hybrid/services/list?main_category_id=$mainCatId&sub_category_id=$subCatId&ref_user_id=$refUserId'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

// Fetches product details
Future getProductDetails(prodID) async {
  var request = http.Request('GET',
      Uri.parse('$apiHeader/api/hybrid/services/details?product_id=$prodID'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}



//Fetches unit deatails
Future getUnitDetails(prodID,unit_name) async {
  var request = http.Request('GET',
      Uri.parse('$apiHeader/api/hybrid/services/unit-values?product_id=$prodID&unit_name=$unit_name'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

//Fetches price details
Future getUpdatedPrice(prodID,unit_value_id,quantity) async {
  var request = http.Request('POST',
      Uri.parse('$apiHeader/api/hybrid/services/calculate-price?product_id=$prodID&unit_values_id=$unit_value_id&quantity=$quantity'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}


//Fetches the seasonal offers
Future getSeasonalOffers() async {
  var request = http.Request(
      'GET', Uri.parse('$apiHeader/api/hybrid/home-page/season-offers'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

//Fetches the ongoing offers
Future getOngoingOffers() async {
  var request = http.Request(
      'GET', Uri.parse('$apiHeader/api/hybrid/home-page/on-going-offers'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

// Triggers the otp after entering mobile number
Future getOtp(String phone) async {
  var request = http.Request('POST',
      Uri.parse('$apiHeader/api/hybrid/auth/signin/otp/send?phone=$phone'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

//Validates the otp entered
Future validateOTP(String phone, String otp) async {
  final Controller c = Get.put(Controller());
  var request = http.Request(
      'POST',
      Uri.parse(
          '$apiHeader/api/hybrid/auth/signin/otp/confirm?phone=$phone&otp=$otp'));
// $apiHeader/api/hybrid/auth/signin/otp/confirm?phone=$phone&otp=$otp
  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());

  if (response.statusCode == 200) {
    c.refUserId.value = res["data"]["ref_user_id"].toString();
    c.defaultAddressId.value = res["data"]["address_id"].toString();
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

//Fetches the main categories
Future getMainCategories() async {
  var request = http.Request(
      'GET', Uri.parse('$apiHeader/api/hybrid/home-page/main-category'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

// Fetches the sub categories after entering the main category id
Future getSubcategories(String catId) async {
  var request = http.Request(
      'GET',
      Uri.parse(
          '$apiHeader/api/hybrid/home-page/sub-category?main_category_id=$catId&sub_category_id'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }

  return res;
}

//Fetches popular services
Future getPopularServices() async {
  var request = http.Request(
      'GET', Uri.parse('$apiHeader/api/hybrid/home-page/popular-services?'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    res.toString();
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

//Fetches Banners being displayed on the home screen
Future getHomeBanners() async {
  var request =
      http.Request('GET', Uri.parse('$apiHeader/api/hybrid/home-page/banner'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future getMainAndSubCategories() async {
  var request = http.Request(
      'GET', Uri.parse('$apiHeader/api/hybrid/home-page/main-sub-category'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print("Sub categories===> " + res.toString());
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future saveUserAddress(userID, addressType, stateName, cityName, pinCode, lat,
    lng, address1) async {
  var request = http.Request(
      'POST',
      Uri.parse(
          '$apiHeader/api/hybrid/auth/profile/address/store?ref_user_id=$userID&address_type=$addressType&state_name=$stateName&city_name=$cityName&latitude=$lat&longitude=$lng&address1=$address1&pincode=$pinCode'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());

  if (response.statusCode == 200) {
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

//Get Product Time SLots

Future getProductTimeSlots() async {
  var request = http.Request(
      'GET', Uri.parse('$apiHeader/api/hybrid/services/slots?product_id=193'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

//get Time slots
Future getTimeSlots(prodID) async {
  var request = http.Request('GET',
      Uri.parse('$apiHeader/api/hybrid/services/slots?product_id=$prodID'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future booking(refUserID, addID, prodID, unitName, unitID, qty, fromDate,
    toDate, payMode, fromTime, toTime, phone, email) async {
  var request = http.Request(
      'POST',
      Uri.parse(
          '$apiHeader/api/hybrid/services/booking?ref_user_id=$refUserID&address_id=$addID&product_id=$prodID&unit_name=$unitName&unit_id=$unitID&quantity=$qty&from_date=$fromDate&to_date=$toDate&payment_mode=$payMode&from_time=$fromTime&to_time=$toTime&contact_phone=$phone&contact_email=$email'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future getActiveBookings(refUserID) async {
  print(refUserID);
  var request = http.Request(
      'GET',
      Uri.parse(
          '$apiHeader/api/hybrid/account/bookings/active?ref_user_id=$refUserID'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future getBookingHistory(refUserID) async {
  var request = http.Request(
      'GET',
      Uri.parse(
          '$apiHeader/api/hybrid/account/bookings/history?ref_user_id=$refUserID'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future getAboutUsDetails() async {
  var request =
      http.Request('GET', Uri.parse('$apiHeader/api/hybrid/account/about'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future listUserAddresses(refUserId, addressID) async {
  var request = http.Request(
      'GET',
      Uri.parse(addressID == null
          ? '$apiHeader/api/hybrid/auth/profile/address/lists?ref_user_id=$refUserId'
          : '$apiHeader/api/hybrid/auth/profile/address/lists?ref_user_id=$refUserId&address_id=$addressID'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future listdefaultaddress(refUserId, addressID) async {
  var request = http.Request(
      'GET',
      Uri.parse('$apiHeader/api/hybrid/auth/profile/address/lists?ref_user_id=$refUserId&address_id=$addressID&default_address=1'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}


Future getNotificationScreenData(refUserId) async {
  var request = http.Request(
      'GET',
      Uri.parse(
          '$apiHeader/api/hybrid/account/notifications?ref_user_id=$refUserId'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print("Notification Data :=> " + res.toString());
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future addItemToCart(refUserId, prodId, unitId,
    {String? qty, String? date, String? fromTime, String? toTime}) async {
  final Controller c = Get.put(Controller());
  var request = http.Request(
      'POST',
      Uri.parse(
          // '$apiHeader/api/hybrid/cart/store?ref_user_id=$refUserId&product_id=$prodId&unit_id=$unitId&quantity=$qty&from_date=$date&to_date=$date&from_time=$fromTime&to_time=$toTime'
          '$apiHeader/api/hybrid/cart/store?ref_user_id=$refUserId&product_id=$prodId&unit_id=$unitId&quantity=$qty&from_date=$date&to_date=$date&from_time=$fromTime&to_time=$toTime'
          // qty != ""
          //     ? '$apiHeader/api/hybrid/cart/store?ref_user_id=$refUserId&product_id=$prodId&unit_id=$unitId&quantity=$qty'
          //     : date != '' || fromTime != ''
          //         ? '$apiHeader/api/hybrid/cart/store?ref_user_id=$refUserId&product_id=$prodId&unit_id=$unitId&from_date=$date&to_date=$date&from_time=$fromTime&to_time=$fromTime'
          //         : '$apiHeader/api/hybrid/cart/store?ref_user_id=$refUserId&product_id=$prodId&unit_id=$unitId'
          ));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  print("Service Date" + date!);
  print(res);
  if (response.statusCode == 200) {
    Get.snackbar('Service Added', 'Check cart to schedule the service');
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future getCartItems(refUserID) async {
  var request = http.Request('GET',
      Uri.parse('$apiHeader/api/hybrid/cart/list?ref_user_id=$refUserID'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future getCartCount(String refUserId) async {
  var request = http.Request('GET',
      Uri.parse('$apiHeader/api/hybrid/cart/counts?ref_user_id=$refUserId'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future removeCartItem(refUserId, cartId) async {
  final Controller c = Get.put(Controller());
  var request = http.Request(
      'POST',
      Uri.parse(
          '$apiHeader/api/hybrid/cart/remove?ref_user_id=$refUserId&cart_id=$cartId'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
    c.cartCount.value = c.cartCount.value - 1;
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future initiateAccountTransfer(refUSerID, phone) async {
  var request = http.Request(
      'POST',
      Uri.parse(
          '$apiHeader/api/hybrid/account/transfer/initiate?ref_user_id=$refUSerID&phone=$phone'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future confirmAccountTransferOtp(refUserID, otp) async {
  var request = http.Request(
      'POST',
      Uri.parse(
          '$apiHeader/api/hybrid/account/transfer/confirm?ref_user_id=$refUserID&otp=$otp'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future getBookingTransactions(refUserID) async {
  var request = http.Request(
      'GET',
      Uri.parse(
          '$apiHeader/api/hybrid/account/transactions/booking?ref_user_id=$refUserID'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future getProfileDetails(refUserId) async {
  var request = http.Request(
      'GET',
      Uri.parse(
          '$apiHeader/api/hybrid/auth/profile/my-account/details?ref_user_id=$refUserId'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future cartbooking(refUserId, addressID, paymentMode, phone, email) async {
  var request = http.Request(
      'POST',
      Uri.parse(
          '$apiHeader/api/hybrid/cart/booking?ref_user_id=$refUserId&address_id=$addressID&payment_mode=$paymentMode&contact_phone=$phone&contact_email=$email'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future getPaymentMethods() async {
  var request =
      http.Request('GET', Uri.parse('$apiHeader/api/hybrid/payment-mode/list'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print(res);
  } else {
    print(response.reasonPhrase);
  }
  return res;
}

Future setDefaultAddressId(userId, addressId) async {
  var request = http.Request(
      'POST',
      Uri.parse(
          'https://otifs.com/public/api/hybrid/auth/profile/address/mark-default?ref_user_id=$userId&address_id=$addressId'));

  http.StreamedResponse response = await request.send();
  var res = jsonDecode(await response.stream.bytesToString());
  if (response.statusCode == 200) {
    print("default api");
    print(res);
    return res;
  } else {
    print(response.reasonPhrase);
  }
}
