class MainSubCategory {
  MainSubCategory(
      {required this.id,
      required this.bannerImage,
      required this.mainCat,
      required this.name,
      required this.type,
      required this.subCategories});

  String id;
  String mainCat;
  String name;
  String bannerImage;
  String type;
  List<dynamic> subCategories;
}

class Booking {
  Booking(
      {required this.userID,
      required this.addressID,
      required this.prodID,
      required this.unitName,
      required this.unitID,
      required this.qty,
      required this.fromDate,
      required this.toDate,
      required this.payMode,
      required this.fromTime,
      required this.toTime,
      required this.phone,
      required this.email});
  String userID;
  String addressID;
  String prodID;
  String unitName;
  String unitID;
  int qty;
  String fromDate;
  String toDate;
  String payMode;
  String fromTime;
  String toTime;
  int phone;
  String email;
}

Map<String, String> weekdayMap = {
  "0": "Sun",
  "1": "Mon",
  "2": "Tue",
  "3": "Wed",
  "4": "Thu",
  "5": "Fri",
  "6": "Sat",
};

Map<String, String> monthMap = {
  "0": "January",
  "1": "February",
  "2": "March",
  "3": "April",
  "4": "May",
  "5": "June",
  "6": "July",
  "7": "August",
  "8": "September",
  "9": "October",
  "10": "November",
  "11": "December",
};
