import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sunfireworks/Components/CustomAppButton.dart';
import 'package:sunfireworks/utils/media_query_helper.dart';
import 'package:sunfireworks/widgets/CommonTextField.dart';
import '../../theme/ThemeHelper.dart';

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
  Widget build(BuildContext context) {
    final isDarkMode = ThemeHelper.isDarkMode(context);
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
                    CommonTextField1(
                      lable: "Vehicle Number",
                      hint: "Enter vehicle number",
                      color: Colors.white,
                      controller: _vehicleController,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Vehicle number is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CommonTextField1(
                      lable: "Mobile Number",
                      hint: "Enter mobile number",
                      color: Colors.white,
                      keyboardType: TextInputType.phone,
                      controller: _mobileController,
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
          child: CustomAppButton1(
            text: 'Send OTP',
            onPlusTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                context.pushReplacement("/otp");
              } else {
                print("Validation failed");
              }
            },

          ),
        ),
      ),
    );
  }
}
