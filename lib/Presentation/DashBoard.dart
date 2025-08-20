import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunfireworks/Presentation/DriverProfileScreen.dart';
import 'package:sunfireworks/Presentation/TipperDriver/HomeScreen.dart';
import 'package:sunfireworks/Presentation/TipperDriver/OrdersScreen.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/SaveMiniTruckLocation/save_minitruck_location_cubit.dart';
import 'package:sunfireworks/utils/AppLogger.dart';
import '../data/bloc/internet_status/internet_status_bloc.dart';
import '../services/location_channel.dart';

class Dashboard extends StatefulWidget {
  final int initialTab;
  const Dashboard({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController pageController;
  int _selectedIndex = 0;
  String _currentLocation = "Waiting for location...";

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    pageController = PageController(initialPage: _selectedIndex);
  }
  //
  // Future<void> _initLocationUpdates() async {
  //   final bool hasPermissions = await LocationBridge.ensurePermissions();
  //   if (hasPermissions) {
  //     await LocationBridge.startListeningToLocationUpdates((latitude, longitude, address) {
  //       setState(() {
  //         _currentLocation = "Lat: $latitude, Lon: $longitude, Address: $address";
  //       });
  //       print("Received Location Update: Latitude: $latitude, Longitude: $longitude, Address: $address");
  //     });
  //     await LocationBridge.startService(message: 'Tracking location...');
  //   } else {
  //     setState(() {
  //       _currentLocation = "Location permissions not granted.";
  //     });
  //     print("Permission not granted. Cannot start location service.");
  //   }
  //   // Explicitly complete the Future<void>
  //   return;
  // }

  Future<void> _stop() async {
    print("Dashboard: Stopping location service");
    await LocationBridge.stopService();
    setState(() {
      _currentLocation = "Location service stopped.";
    });
  }


  void onItemTapped(int selectedItems) {
    pageController.jumpToPage(selectedItems);
    setState(() {
      _selectedIndex = selectedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            } else if (state is InternetStatusBackState) {
              context.pop();
            }
          },
          child: PageView(
            onPageChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() {
                _selectedIndex = value;
              });
            },
            controller: pageController,
            children: [HomeScreen(), OrdersScreen(), DriverProfileScreen()],
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 10,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
      child: BottomNavigationBar(
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
          BottomNavigationBarItem(
            label: "Orders",
            icon: Image.asset(
              "assets/images/orders.png",
              width: 25,
              height: 25,
              color: _selectedIndex == 1 ? Colors.black : Color(0xff994D52),
            ),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Image.asset(
              "assets/images/profile.png",
              width: 25,
              height: 25,
              color: _selectedIndex == 2 ? Colors.black : Color(0xff994D52),
            ),
          ),
        ],
      ),
    );
  }
}
