import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sunfireworks/Components/CustomAppButton.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/CarDriverOTP/CarDriverOTPStates.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/StockTransfer/stock_transfer_cubit.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/StockTransfer/stock_transfer_states.dart';
import '../../Components/CustomSnackBar.dart';
import '../../data/Models/TipperDriver/DriverAssignmentModel.dart';
import '../../data/bloc/cubits/TipperDriver/CarDriverOTP/CarDriverOTPCubit.dart';
import '../../data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_cubit.dart';
import '../QrScannerScreen.dart';

class MiniTruckDeliveryScreen extends StatefulWidget {
  final AssignedCar assignedCar;
  final String dcm_assignmentID;
  const MiniTruckDeliveryScreen({
    super.key,
    required this.assignedCar,
    required this.dcm_assignmentID,
  });
  @override
  State<MiniTruckDeliveryScreen> createState() =>
      _MiniTruckDeliveryScreenState();
}

class _MiniTruckDeliveryScreenState extends State<MiniTruckDeliveryScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _photoFile;
  late List<bool> _bagsDelivered;
  late List<bool> _packsDelivered;

  // OTP
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  bool _otpVerified = false;

  // UI state
  bool _verifying = false;
  bool _generatingOtp = false;

  // ✅ Helper getter to check if all bags are delivered
  bool get allDelivered {
    final allBagsDone = _bagsDelivered.every((d) => d);
    final allPacksDone = _packsDelivered.every((d) => d);
    return allBagsDone && allPacksDone;
  }

  @override
  void initState() {
    super.initState();
    _bagsDelivered = List.generate(
      widget.assignedCar.bags.length,
      (_) => false,
    );

    _packsDelivered = List.generate(
      widget.assignedCar.packItems.length,
      (_) => false,
    );
  }

  Future<void> _handleScannedCode(String scannedData) async {
    final bags = widget.assignedCar.bags;
    final packs = widget.assignedCar.packItems;

    bool found = false;
    String scannedCode = scannedData.trim();

    // 🧩 CASE 1 — BAG QR
    if (scannedData.startsWith("Bag Code:")) {
      final prefix = "Bag Code:";
      final endIndex = scannedData.indexOf(" |");
      scannedCode = endIndex != -1
          ? scannedData.substring(prefix.length, endIndex).trim()
          : scannedData.substring(prefix.length).trim();

      for (int i = 0; i < bags.length; i++) {
        if (bags[i].code.toLowerCase() == scannedCode.toLowerCase()) {
          setState(() => _bagsDelivered[i] = true);
          found = true;
          break;
        }
      }
    }
    // 🧩 CASE 2 — PACK (ORDER) QR
    else if (scannedData.startsWith("Order ID:")) {
      final prefix = "Order ID:";
      final endIndex = scannedData.indexOf(" |");
      scannedCode = endIndex != -1
          ? scannedData.substring(prefix.length, endIndex).trim()
          : scannedData.substring(prefix.length).trim();

      // Match scanned order id or internal pack code
      for (int i = 0; i < packs.length; i++) {
        if (packs[i].code.toLowerCase() == scannedCode.toLowerCase() ||
            (packs[i].order?.orderId.toLowerCase() ==
                scannedCode.toLowerCase())) {
          setState(() => _packsDelivered[i] = true);
          found = true;
          break;
        }
      }
    }

    // 🧩 CASE 3 — fallback match by code presence
    if (!found) {
      for (int i = 0; i < bags.length; i++) {
        if (scannedData.contains(bags[i].code)) {
          setState(() => _bagsDelivered[i] = true);
          found = true;
          scannedCode = bags[i].code;
          break;
        }
      }
    }

    if (!found) {
      for (int i = 0; i < packs.length; i++) {
        if (scannedData.contains(packs[i].code)) {
          setState(() => _packsDelivered[i] = true);
          found = true;
          scannedCode = packs[i].code;
          break;
        }
      }
    }

    // ✅ FEEDBACK
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          found
              ? "$scannedCode marked delivered ✅"
              : "$scannedCode not found ❌",
        ),
      ),
    );
  }

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
        actions: [
          IconButton(
            onPressed: () async {
              final scannedCode = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QrScannerScreen()),
              );
              print("scannedCode:${scannedCode}");
              if (scannedCode != null) {
                _handleScannedCode(scannedCode);
              }
            },
            icon: Icon(Icons.qr_code, color: Colors.black),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Transport Card
          SliverToBoxAdapter(child: _transportCard(assignedCar)),

          if (assignedCar.bags.isNotEmpty)
            SliverToBoxAdapter(
              child: _summaryCard(
                title: "Bags To Delivery",
                total: assignedCar.bags.length.toString(),
                amount: "—",
                items: List.generate(
                  assignedCar.bags.length,
                  (index) => _boxTile1(index, assignedCar.bags[index].code),
                ),
                footer: "Total: ${assignedCar.bags.length} boxes",
              ),
            ),

          if (assignedCar.packItems.isNotEmpty)
            SliverToBoxAdapter(
              child: _summaryCard(
                title: "Pack Items To Delivery",
                total: assignedCar.packItems.length.toString(),
                amount: "—",
                items: List.generate(
                  assignedCar.packItems.length,
                  (index) =>
                      _boxTile2(index, assignedCar.packItems[index].code),
                ),
                footer: "Total: ${assignedCar.packItems.length} Packs",
              ),
            ),
          //
          // // Individual Stock Card
          // if (assignedCar.individualStockDetails.isNotEmpty)
          //   SliverToBoxAdapter(
          //     child: _summaryCard(
          //       title: "Individual Stock",
          //       total: totalIndividualBoxes.toString(),
          //       amount: "—",
          //       items: assignedCar.individualStockDetails
          //           .map((e) => _boxTile(e.individualName, e.stockRequired))
          //           .toList(),
          //       footer: "Total: $totalIndividualBoxes boxes",
          //     ),
          //   ),
          //
          // // Combo Stock Card
          // if (assignedCar.comboStockDetails.isNotEmpty)
          //   SliverToBoxAdapter(
          //     child: _summaryCard(
          //       title: "Combo Stock",
          //       total: totalComboBoxes.toString(),
          //       amount: "—",
          //       items: assignedCar.comboStockDetails
          //           .map((e) => _boxTile(e.comboName, e.stockRequired))
          //           .toList(),
          //       footer: "Total: $totalComboBoxes boxes",
          //       bgColor: Colors.red.shade50,
          //     ),
          //   ),

          // OTP Section
          if (allDelivered)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _otpSection(
                  orderId: assignedCar.id ?? '',
                  mobile: assignedCar.car?.mobile ?? '',
                ),
              ),
            ),

          // // Photo Section
          // if (_otpVerified)
          //   SliverToBoxAdapter(
          //     child: Padding(
          //       padding: const EdgeInsets.all(16),
          //       child: _photoSection(),
          //     ),
          //   ),
          if (_otpVerified)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BlocConsumer<StockTransferCubit, StockTransferStates>(
                  listener: (context, state) {
                    if (state is StockTransferLoaded) {
                      CustomSnackBar1.show(
                        context,
                        state.successModel.message ?? "",
                      );
                      context
                          .read<DriverAssignmentCubit>()
                          .getDriverAssignments();
                      Navigator.pop(context);
                    } else if (state is StockTransferFailure) {
                      CustomSnackBar1.show(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is StockTransferLoading;
                    return CustomAppButton1(
                      text: "Submit & Complete Delivery",
                      isLoading: isLoading,
                      onPlusTap: (_otpVerified)
                          ? () {
                              // ✅ Collect delivered bag IDs
                              final deliveredBagIds = [
                                for (
                                  int i = 0;
                                  i < assignedCar.bags.length;
                                  i++
                                )
                                  if (_bagsDelivered[i]) assignedCar.bags[i].id,
                              ];

                              // ✅ Collect delivered pack IDs
                              final deliveredPackIds = [
                                for (
                                  int i = 0;
                                  i < assignedCar.packItems.length;
                                  i++
                                )
                                  if (_packsDelivered[i])
                                    assignedCar.packItems[i].id,
                              ];

                              final data = {
                                "car_assignment": assignedCar.id,
                                "dcm_assignment": widget.dcm_assignmentID,
                                "bags": deliveredBagIds,
                                "packs": deliveredPackIds,
                                "photo": _photoFile?.path,
                              };
                              print("📦 Payload: $data");
                              context
                                  .read<StockTransferCubit>()
                                  .stockTransferApi(data);
                            }
                          : null,
                    );
                  },
                ),
              ),
            ),

          SliverPadding(padding: EdgeInsets.all(25)),
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
                          car.selectedPoint ?? "",
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
              CustomAppButton1(
                text: "Generate OTP",
                isLoading: state is CarDriverOTPLoading,
                onPlusTap: _generatingOtp
                    ? null
                    : () {
                        setState(() => _generatingOtp = true);
                        context.read<CarDriverOTPCubit>().generateOTP({
                          "mobile": mobile,
                        });
                      },
              ),
            if (_otpSent) ...[
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                autoFocus: true,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
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
              CustomAppButton1(
                text: "Verify OTP",
                isLoading: state is CarDriverOTPLoading,
                onPlusTap: state is CarDriverOTPLoading
                    ? null
                    : () {
                        context.read<CarDriverOTPCubit>().verifyOTP({
                          "mobile": mobile,
                          "otp": _otpController.text,
                        });
                      },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
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
                "Total: $total",
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

  Widget _boxTile2(int index, String label) {
    final delivered = _packsDelivered[index];
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: delivered ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, textAlign: TextAlign.center),
          if (delivered) const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }

  Widget _boxTile1(int index, String label) {
    final delivered = _bagsDelivered[index];
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: delivered ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, textAlign: TextAlign.center),
          if (delivered) const Icon(Icons.check_circle, color: Colors.green),
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
