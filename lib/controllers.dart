import 'package:get/get.dart';

class Controller extends GetxController {
  RxInt screenIndex = 0.obs;
  RxString refUserId = ''.obs;
  dynamic otpField = false.obs;
  RxString mobile = ''.obs;
  RxString email = ''.obs;
  RxMap<String, String> address = {"": ""}.obs;
  RxString addressID = ''.obs;
  RxString defaultAddressId = ''.obs;
  RxMap<String, String> coordinates = {"lat": "", "lng": ""}.obs;
  RxString addressType = 'C'.obs;
  RxString sqft = ''.obs;
  RxString dateSelected = ''.obs;
  RxString timeSlot = ''.obs;
  RxString totime = ''.obs;
  RxString currentTimeSelected = ''.obs;
  RxString currentDateSelected = ''.obs;
  RxString date = "".obs;
  RxString weekday = "0".obs;
  RxString month = "0".obs;
  RxString selected_id =''.obs;
  RxString selected_quantity = ''.obs;
  RxString updated_price = ''.obs;
  RxInt cartCount = 0.obs;
  RxString bookorcart = ''.obs;
  RxMap<String, String> allServicesMap = {"": ""}.obs;
  RxBool reload = false.obs;
  RxList<String> paymentMethods = <String>[].obs;
  RxList<String> paymentMethodCodes = <String>[].obs;
}



