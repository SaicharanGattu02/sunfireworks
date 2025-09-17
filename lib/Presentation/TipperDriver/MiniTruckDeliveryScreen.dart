import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/CarDriverOTP/CarDriverOTPStates.dart';

import '../../Components/CustomSnackBar.dart';
import '../../data/Models/TipperDriver/DriverAssignmentModel.dart';
import '../../data/bloc/cubits/TipperDriver/CarDriverOTP/CarDriverOTPCubit.dart';

class MiniTruckDeliveryScreen extends StatefulWidget {
  final AssignedCar assignedCar;

  const MiniTruckDeliveryScreen({super.key, required this.assignedCar});

  @override
  State<MiniTruckDeliveryScreen> createState() =>
      _MiniTruckDeliveryScreenState();
}

class _MiniTruckDeliveryScreenState extends State<MiniTruckDeliveryScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _photoFile;

  // OTP
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  bool _otpVerified = false;

  // UI state
  bool _verifying = false;
  bool _generatingOtp = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final x = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );
      if (x != null) setState(() => _photoFile = File(x.path));
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Camera error: ${e.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignedCar = widget.assignedCar;

    int totalIndividualBoxes = assignedCar.individualStockDetails.fold(
      0,
      (sum, e) => sum + e.stockRequired,
    );
    int totalComboBoxes = assignedCar.comboStockDetails.fold(
      0,
      (sum, e) => sum + e.stockRequired,
    );
    int totalBoxes = totalIndividualBoxes + totalComboBoxes;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Delivery by Locations",
          style: TextStyle(
            fontFamily: "roboto",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Transport Card
          SliverToBoxAdapter(child: _transportCard(assignedCar)),

          // Individual Stock Card
          if (assignedCar.individualStockDetails.isNotEmpty)
            SliverToBoxAdapter(
              child: _summaryCard(
                title: "Individual Stock",
                total: totalIndividualBoxes.toString(),
                amount: "—",
                items: assignedCar.individualStockDetails
                    .map((e) => _boxTile(e.individualName, e.stockRequired))
                    .toList(),
                footer: "Total: $totalIndividualBoxes boxes",
              ),
            ),

          // Combo Stock Card
          if (assignedCar.comboStockDetails.isNotEmpty)
            SliverToBoxAdapter(
              child: _summaryCard(
                title: "Combo Stock",
                total: totalComboBoxes.toString(),
                amount: "—",
                items: assignedCar.comboStockDetails
                    .map((e) => _boxTile(e.comboName, e.stockRequired))
                    .toList(),
                footer: "Total: $totalComboBoxes boxes",
                bgColor: Colors.red.shade50,
              ),
            ),

          // OTP Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _otpSection(
                orderId: assignedCar.id ?? '',
                mobile: assignedCar.car?.driver_mobile_no ?? '',
              ),
            ),
          ),

          // Photo Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _photoSection(),
            ),
          ),

          // Submit Button
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: BlocConsumer<UpdateOrderStatusCubit, UpdateOrderStatusStates>(
          //       listener: (context, state) {
          //         if (state is UpdateOrderStatusUpdated) {
          //           CustomSnackBar1.show(context, state.successModel.message ?? "");
          //           Navigator.pop(context);
          //         } else if (state is UpdateOrderStatusFailure) {
          //           CustomSnackBar1.show(context, state.error);
          //         }
          //       },
          //       builder: (context, state) {
          //         final isLoading = state is UpdateOrderStatusLoading;
          //         return ElevatedButton.icon(
          //           onPressed: (_otpVerified && _photoFile != null)
          //               ? () {
          //             Map<String, dynamic> data = {
          //               "order_status": "delivered",
          //               "delivery_image": _photoFile?.path,
          //             };
          //             context.read<UpdateOrderStatusCubit>().updateOrderStatus(
          //               assignedCar.car?.id ?? '',
          //               data,
          //             );
          //           }
          //               : null,
          //           style: ElevatedButton.styleFrom(
          //             minimumSize: const Size(double.infinity, 48),
          //             backgroundColor: Colors.green,
          //           ),
          //           label: isLoading
          //               ? const CircularProgressIndicator(color: Colors.white)
          //               : const Text(
          //             'Submit & Complete Delivery',
          //             style: TextStyle(color: Colors.white),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _transportCard(AssignedCar car) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage("assets/images/driver.png"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.car?.driver ?? 'Unknown Driver',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.car?.vehicleNumber ?? '—',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          car.selectedPoint,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Image.asset(
              "assets/images/truck.png",
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // ========== OTP Section ==========
  Widget _otpSection({required String orderId, required String mobile}) {
    return BlocConsumer<CarDriverOTPCubit, CarDriverOTPStates>(
      listener: (context, state) {
        if (state is CarDriverOTPGenerated) {
          setState(() {
            _generatingOtp = false;
            _otpSent = true;
            _otpVerified = false;
          });
          CustomSnackBar1.show(context, state.successModel.message ?? "");
        } else if (state is CarDriverOTPVerified) {
          setState(() {
            _verifying = false;
            _otpVerified = true;
            _otpSent = false;
          });
          CustomSnackBar1.show(context, state.successModel.message ?? "");
        } else if (state is CarDriverOTPFailure) {
          CustomSnackBar1.show(context, state.error ?? "");
        }
      },
      builder: (context, state) {
        if (_otpVerified) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_otpSent)
              ElevatedButton(
                onPressed: _generatingOtp
                    ? null
                    : () {
                        setState(() => _generatingOtp = true);
                        context.read<CarDriverOTPCubit>().generateOTP({
                          "car_assignment_id": orderId,
                        });
                      },
                child: state is CarDriverOTPLoading
                    ? const CircularProgressIndicator()
                    : const Text("Generate OTP"),
              ),
            if (_otpSent) ...[
              PinCodeTextField(
                appContext: context,
                controller: _otpController,
                length: 6,
                autoFocus: true,
                keyboardType: TextInputType.number,
                onChanged: (_) {},
              ),
              ElevatedButton(
                onPressed: state is CarDriverOTPLoading
                    ? null
                    : () {
                        context.read<CarDriverOTPCubit>().verifyOTP({
                          "mobile": mobile,
                          "otp": _otpController.text,
                        });
                      },
                child: const Text("Verify OTP"),
              ),
              TextButton(
                onPressed: _generatingOtp
                    ? null
                    : () {
                        setState(() => _generatingOtp = true);
                        context.read<CarDriverOTPCubit>().generateOTP({
                          "order_id": orderId,
                        });
                      },
                child: const Text("Resend OTP"),
              ),
            ],
          ],
        );
      },
    );
  }

  // ========== Photo Section ==========
  Widget _photoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Photo Verification',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickPhoto,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              image: _photoFile != null
                  ? DecorationImage(
                      image: FileImage(_photoFile!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _photoFile == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(height: 6),
                        Text('Tap to capture delivery photo'),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  // ---------- Reusable UI ----------
  Widget _summaryCard({
    required String title,
    required String total,
    required String amount,
    required List<Widget> items,
    String? footer,
    Color? bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Total: $total\n$amount",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, children: items),
          if (footer != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(footer, textAlign: TextAlign.center),
            ),
        ],
      ),
    );
  }

  Widget _boxTile(String label, int count) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text("$count", style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
