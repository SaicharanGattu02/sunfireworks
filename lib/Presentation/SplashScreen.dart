import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sunfireworks/services/AuthService.dart';
import 'package:sunfireworks/utils/AppLogger.dart';

import '../utils/helpers.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      final access_token = await AuthService.getAccessToken();
      AppLogger.info("access_token:${access_token}");
      if (access_token != null) {
        if (!(await checkGPSstatus())) {
          context.pushReplacement("/no_gps");
        } else {
          context.pushReplacement("/dashboard");
        }
      } else {
        context.pushReplacement("/sign_in_with_mobile");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/rocket.png")),
    );
  }
}
