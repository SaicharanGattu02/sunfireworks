import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sunfireworks/Components/CustomAppButton.dart';
import 'package:sunfireworks/Components/CustomSnackBar.dart';
import 'package:sunfireworks/data/bloc/cubits/Auth/auth_cubit.dart';
import 'package:sunfireworks/data/bloc/cubits/Auth/auth_state.dart';
import 'package:sunfireworks/utils/media_query_helper.dart';
import 'package:sunfireworks/widgets/CommonTextField.dart';
import 'package:location/location.dart' as loc;

class SignInWithMobile extends StatefulWidget {
  const SignInWithMobile({super.key});

  @override
  State<SignInWithMobile> createState() => _SignInWithMobileState();
}

class _SignInWithMobileState extends State<SignInWithMobile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    getLocationPermissions();
    super.initState();
  }

  bool permissions_granted = false;
  bool serviceEnabled = false;
  int denialCount = 0;

  Future<void> getLocationPermissions() async {
    // Check if location services are enabled
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    // Check if the app has been granted location permission
    LocationPermission permission = await Geolocator.checkPermission();
    bool hasLocationPermission =
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    try {
      if (!isLocationEnabled || !hasLocationPermission) {
        // Location services or permissions are not enabled, request permission
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          denialCount++;
          if (denialCount >= 2) {
            // Redirect user to app settings after denying twice
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                    'You have denied location permission twice. Please enable it in your app settings.',
                    style: TextStyle(fontSize: 15),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        overlayColor: MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        openAppSettings(); // Redirect to app settings
                      },
                      child: Text(
                        'Open Settings',
                        style: TextStyle(fontSize: 15, color: Colors.cyan),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            // Show retry dialog if not reached the limit
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                    'Sun Fireworks uses this permission to detect your current location. Please enable your location permission.',
                    style: TextStyle(fontSize: 15),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        overlayColor: MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await getLocationPermissions();
                      },
                      child: Text(
                        'Retry',
                        style: TextStyle(fontSize: 15, color: Colors.cyan),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return;
        } else {
          // Request GPS permission if granted
          requestGpsPermission();
        }
      } else {
        // Request GPS permission if location services and permission are enabled
        requestGpsPermission();
      }
    } catch (e, s) {
      // Handle exception here
      print('Error: $e\n$s');
    }
  }

  Future<void> requestGpsPermission() async {
    // Check if the app has been granted location permission
    final loc.Location location = loc.Location();
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    try {
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          serviceEnabled = await location.requestService();
        } else {}
      } else {}
    } catch (e, s) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset(
                'assets/images/rocket.png',
                fit: BoxFit.cover,
                height: SizeConfig.screenHeight,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CommonTextField1(
                    //   lable: "Vehicle Number",
                    //   hint: "Enter vehicle number",
                    //   color: Colors.white,
                    //   controller: _vehicleController,
                    //   validator: (val) {
                    //     if (val == null || val.trim().isEmpty) {
                    //       return "Vehicle number is required";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(height: 16),
                    CommonTextField1(
                      lable: "Mobile Number",
                      hint: "Enter mobile number",
                      color: Colors.white,
                      keyboardType: TextInputType.phone,
                      controller: _mobileController,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Mobile number is required";
                        } else if (!RegExp(r'^\d{10}$').hasMatch(val)) {
                          return "Enter a valid 10-digit number";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 50),
          child: BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              if (state is AuthGenerateOTP) {
                context.push("/otp?mobile_number=${_mobileController.text}");
              } else if (state is AuthFailure) {
                CustomSnackBar1.show(context, state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return CustomAppButton1(
                isLoading: isLoading,
                text: 'Send OTP',
                onPlusTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Map<String, dynamic> data = {
                      "mobile": _mobileController.text,
                    };
                    context.read<AuthCubit>().getOTP(data);
                  } else {
                    print("Validation failed");
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
