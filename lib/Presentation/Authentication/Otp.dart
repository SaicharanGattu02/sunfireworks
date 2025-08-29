import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sunfireworks/Components/CustomAppButton.dart';
import 'package:sunfireworks/services/AuthService.dart';
import 'package:sunfireworks/utils/media_query_helper.dart';
import 'package:sunfireworks/utils/preferences.dart';
import '../../Components/CustomSnackBar.dart';
import '../../Components/ShakeWidget.dart';
import '../../data/bloc/cubits/Auth/auth_cubit.dart';
import '../../data/bloc/cubits/Auth/auth_state.dart';

class Otp extends StatefulWidget {
  final String mobile_number;
  const Otp({super.key, required this.mobile_number});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  bool _showOtpError = false;

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
            bottom: 40,
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
                    Text("Verify Your Number", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Enter OTP"),
                    ),
                    const SizedBox(height: 16),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: otpController,
                      autoFocus: true,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      onChanged: (_) {
                        setState(() {
                          _showOtpError = false;
                        });
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 50,
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
          child: BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) async {
              if (state is AuthVerifyOTP) {
                final data = state.verifyOTPModel.data;
                await AuthService.saveTokens(
                  data?.accessToken ?? "",
                  data?.refreshToken ?? "",
                  data?.userRole ?? "",
                  0,
                );
                PreferenceService().saveString("role", data?.userRole ?? "");
                PreferenceService().saveString(
                  "access_token",
                  data?.accessToken ?? "",
                );
                context.pushReplacement("/dashboard");
              } else if (state is AuthFailure) {
                CustomSnackBar1.show(context, state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return CustomAppButton1(
                text: 'Next',
                isLoading: isLoading,
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

                      Map<String, dynamic> data = {
                        "mobile": widget.mobile_number,
                        "otp": otpController.text,
                        "fcm_token": 'kgiergkrgngkjsegnlksdjgn',
                        "token_type": "android_token",
                      };
                      context.read<AuthCubit>().verifyOTP(data);
                    }
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
