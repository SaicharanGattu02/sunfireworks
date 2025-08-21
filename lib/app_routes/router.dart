import 'dart:io';
import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sunfireworks/Presentation/DashBoard.dart';
import 'package:sunfireworks/Presentation/DriverProfileScreen.dart';
import 'package:sunfireworks/Presentation/MiniTruckDriver/CustomerDeliveryScreen.dart';
import 'package:sunfireworks/Presentation/TipperDriver/DelivaryDetailsScreen.dart';
import 'package:sunfireworks/Presentation/TipperDriver/HomeScreen.dart';
import '../Presentation/Authentication/Otp.dart';
import '../Presentation/Authentication/SignInWithMobile.dart';
import '../Presentation/SplashScreen.dart';
import '../Presentation/TipperDriver/DistributeLocationsScreen.dart';

import '../Presentation/TipperDriver/MiniTruckDeliveryScreen.dart';
import '../Presentation/TipperDriver/OrdersScreen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          buildSlideTransitionPage(Splashscreen(), state),
    ),
    GoRoute(
      path: '/sign_in_with_mobile',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(SignInWithMobile(), state);
      },
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) {
        final mobile_number = state.uri.queryParameters['mobile_number'] ?? "";
        return buildSlideTransitionPage(Otp(mobile_number: mobile_number,), state);
      },
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(DriverProfileScreen(), state);
      },
    ),
    GoRoute(
      path: '/orders',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(OrdersScreen(), state);
      },
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(Dashboard(), state);
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(HomeScreen(), state);
      },
    ),
    GoRoute(
      path: '/distribute_locations',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(DistributeLocationsScreen(), state);
      },
    ),
    GoRoute(
      path: '/delivery_details',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(DeliveryDetails(), state);
      },
    ),
    GoRoute(
      path: '/truck_delivery',
      pageBuilder: (context, state) {
        return buildSlideTransitionPage(MiniTruckDeliveryScreen(), state);
      },
    ),
    GoRoute(
      path: '/customer_delivery',
      pageBuilder: (context, state) {
        final order_id = state.uri.queryParameters['order_id'] ?? "";
        return buildSlideTransitionPage(CustomerDeliveryScreen(order_id: order_id), state);
      },
    ),
  ],
);

Page<dynamic> buildSlideTransitionPage(Widget child, GoRouterState state) {
  if (Platform.isIOS) {
    // Use default Cupertino transition on iOS
    return CupertinoPage(key: state.pageKey, child: child);
  }

  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

Page<dynamic> buildSlideFromBottomPage(Widget child, GoRouterState state) {
  // if (Platform.isIOS) {
  //   // Use default Cupertino transition on iOS
  //   return CupertinoPage(key: state.pageKey, child: child);
  // }
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); // bottom to top
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
