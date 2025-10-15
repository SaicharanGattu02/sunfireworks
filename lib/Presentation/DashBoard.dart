import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunfireworks/Presentation/DriverProfileScreen.dart';
import 'package:sunfireworks/Presentation/TipperDriver/HomeScreen.dart';
import 'package:sunfireworks/Presentation/TipperDriver/OrdersScreen.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/SaveMiniTruckLocation/save_minitruck_location_cubit.dart';
import 'package:sunfireworks/services/AuthService.dart';
import 'package:sunfireworks/utils/AppLogger.dart';
import '../data/bloc/internet_status/internet_status_bloc.dart';
import '../services/location_channel.dart';
import 'MiniTruckDriver/CustomerLocations.dart';
import 'MiniTruckDriver/CustomerDeliveryScreen.dart';

class Dashboard extends StatefulWidget {
  final int initialTab;
  const Dashboard({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController pageController;
  int _selectedIndex = 0;
  static const platform = MethodChannel('com.sunfireworks/location');

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    pageController = PageController(initialPage: _selectedIndex);
    _startLocationService();
  }

  void _startLocationService() async {
    try {
      await platform.invokeMethod('startService', {
        'message': 'Location Service Started',
      });
    } on PlatformException catch (e) {
      print("Failed to start service: '${e.message}'.");
    }
  }

  void onItemTapped(int selectedItems) {
    pageController.jumpToPage(selectedItems);
    setState(() {
      _selectedIndex = selectedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.getRole(),
      builder: (context, asyncSnapshot) {
        final role = asyncSnapshot.data ?? "";
        AppLogger.info("role: ${role}");
        return WillPopScope(
          onWillPop: () async {
            if (_selectedIndex != 0) {
              setState(() {
                _selectedIndex = 0;
              });
              pageController.jumpToPage(0);
              return false; // Prevent app from exiting
            } else {
              SystemNavigator.pop(); // Exit app
              return true;
            }
          },
          child: Scaffold(
            body: BlocListener<InternetStatusBloc, InternetStatusState>(
              listener: (context, state) {
                if (state is InternetStatusLostState) {
                  context.push('/no_internet');
                } else if (state is InternetStatusBackState) {}
              },
              child: PageView(
                onPageChanged: (value) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedIndex = value;
                  });
                },
                controller: pageController,
                children: [
                  role == "dcm_driver" ? HomeScreen() : CustomerLocations(),
                  // OrdersScreen(),
                  DriverProfileScreen(),
                ],
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
            bottomNavigationBar: SafeArea(child: _buildBottomNavigationBar()),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedLabelStyle: TextStyle(
        fontFamily: 'roboto',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'roboto',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xff994D52),
      ),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 0,
      currentIndex: _selectedIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Image.asset(
            "assets/images/home.png",
            width: 25,
            height: 25,
            color: _selectedIndex == 0 ? Colors.black : Color(0xff994D52),
          ),
        ),
        // BottomNavigationBarItem(
        //   label: "Orders",
        //   icon: Image.asset(
        //     "assets/images/orders.png",
        //     width: 25,
        //     height: 25,
        //     color: _selectedIndex == 1 ? Colors.black : Color(0xff994D52),
        //   ),
        // ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: Image.asset(
            "assets/images/profile.png",
            width: 25,
            height: 25,
            color: _selectedIndex == 1 ? Colors.black : Color(0xff994D52),
          ),
        ),
      ],
    );
  }
}
