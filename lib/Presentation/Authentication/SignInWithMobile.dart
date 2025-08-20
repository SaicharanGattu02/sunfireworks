import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunfireworks/Components/CustomAppButton.dart';
import 'package:sunfireworks/Components/CustomSnackBar.dart';
import 'package:sunfireworks/data/bloc/cubits/Auth/auth_cubit.dart';
import 'package:sunfireworks/data/bloc/cubits/Auth/auth_state.dart';
import 'package:sunfireworks/utils/media_query_helper.dart';
import 'package:sunfireworks/widgets/CommonTextField.dart';

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
