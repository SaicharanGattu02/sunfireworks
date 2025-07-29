import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sunfireworks/Components/CustomAppButton.dart';
import 'package:sunfireworks/utils/media_query_helper.dart';
import '../../Components/ShakeWidget.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  bool _showOtpError = false;

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
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
            bottom: 40,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Verify Your Number",
                      style: AppTextStyles.headlineSmall(
                        textColor,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Enter OTP",
                        style: AppTextStyles.titleLarge(textColor).copyWith(
                          fontWeight: FontWeight.w500,
                          color: Color(0xffBDBDBD),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    PinCodeTextField(
                      appContext: context,
                      length: 4,
                      controller: otpController,
                      autoFocus: true,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      textStyle: AppTextStyles.headlineSmall(
                        textColor,
                      ).copyWith(fontWeight: FontWeight.w600),
                      onChanged: (_) {
                        setState(() {
                          _showOtpError = false;
                        });
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 60,
                        fieldWidth: 60,
                        activeColor: Color(0xffE9E9E9),
                        inactiveColor: Color(0xffE9E9E9),
                        selectedColor: Color(0xffE9E9E9),
                        activeFillColor: Color(0xffE9E9E9),
                        inactiveFillColor: Color(0xffE9E9E9),
                        selectedFillColor: Color(0xffE9E9E9),
                      ),
                    ),

                    if (_showOtpError)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: ShakeWidget(
                          key: const Key('otp_error'),
                          duration: const Duration(milliseconds: 700),
                          child: const Text(
                            'Please enter a valid 4-digit OTP',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),
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
            text: 'Next',
            onPlusTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                if (otpController.text.trim().length != 6) {
                  setState(() {
                    _showOtpError = true;
                  });
                } else {
                  setState(() {
                    _showOtpError = false;
                  });

                  print("OTP Verified: ${otpController.text}");
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
