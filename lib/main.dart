
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stellar_track/Screens/Main%20Screens/bookacall.dart';
import 'package:stellar_track/Screens/Main%20Screens/booking_lists_screen.dart';
import 'package:stellar_track/Screens/Main%20Screens/cart_screen.dart';
import 'package:stellar_track/Screens/Main%20Screens/home_page.dart';
import 'package:stellar_track/Screens/screen1.dart';
import 'package:stellar_track/functions.dart';
import 'package:stellar_track/themes.dart';
import 'package:stellar_track/widgets/bottom_nav.dart';
import 'Screens/Main Screens/account_section_screen.dart';
import 'Screens/splash_screen.dart';
import 'controllers.dart';

List<Widget> screens = const [
  HomePage(),
  BookACallPage(),
  CartScreen(
    isBottomNav: true,
  ),
  BookingListsScreen(),
  AccountSectionScreen(),
];
void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

final getStorage = GetStorage();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeClass.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // getStorage.write('refUserId', '');
    return const Scaffold(extendBodyBehindAppBar: false, body: SplashScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    getAllServices().then((res) {
      setState(() {
        c.allServicesMap.value = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // var wd = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;

    return Obx(
      () => Scaffold(
        bottomNavigationBar: Container(
            height: ht / 14.5,
            // width: wd,
            color: Colors.white,
            child: BottomNavigation(
              height: ht / 14.5,
            )),
        body: SafeArea(
          child: screens[c.screenIndex.value],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
