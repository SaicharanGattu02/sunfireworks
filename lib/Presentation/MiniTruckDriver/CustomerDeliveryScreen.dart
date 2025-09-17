import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sunfireworks/Components/CustomSnackBar.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/AssignedOrdersDetails/AssignedOrdersDetailsCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/CustomerGenerateOTP/CustomerGenerateOtpStates.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/UpdateOrderStatus/UpdateOrderStatusCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/UpdateOrderStatus/UpdateOrderStatusStates.dart';
import 'package:sunfireworks/utils/color_constants.dart';

import '../../data/Models/MiniTruckDriver/AssignedOrdersDetailsModel.dart';
import '../../data/bloc/cubits/MiniTruckDriver/AssignedOrders/AssignedOrdersCubit.dart';
import '../../data/bloc/cubits/MiniTruckDriver/AssignedOrdersDetails/AssignedOrdersDetailsStates.dart';
import '../../data/bloc/cubits/MiniTruckDriver/CustomerGenerateOTP/CustomerGenerateOtpCubit.dart';

class CustomerDeliveryScreen extends StatefulWidget {
  final String order_id;
  const CustomerDeliveryScreen({super.key, required this.order_id});

  @override
  State<CustomerDeliveryScreen> createState() => _CustomerDeliveryScreenState();
}

class _CustomerDeliveryScreenState extends State<CustomerDeliveryScreen> {
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
  void initState() {
    super.initState();
    context.read<AssignedOrdersDetailsCubit>().fetchAssignedOrderDetails(
      widget.order_id,
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
      if (x != null) {
        setState(() => _photoFile = File(x.path));
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Camera error: ${e.message}')));
    }
  }

  // Helpers to compute totals from model
  int _totalQty(AssignedOrdersDetailsModel m) {
    final list = m.data?.orders ?? const <Orders>[];
    int sum = 0;
    for (final o in list) {
      sum += (o.quantity ?? 0);
    }
    return sum;
  }

  double _totalValue(AssignedOrdersDetailsModel m) {
    final list = m.data?.orders ?? const <Orders>[];
    double sum = 0.0;
    for (final o in list) {
      sum += double.tryParse(o.totalAmount ?? '0') ?? 0;
    }
    return sum;
  }

  String _currency(double v) => '₹${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AssignedOrdersDetailsCubit, AssignedOrdersDetailsStates>(
        builder: (context, state) {
          if (state is AssignedOrdersDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AssignedOrdersDetailsFailure) {
            return SafeArea(
              child: Column(
                children: [
                  _gradientAppBar(),
                  const SizedBox(height: 24),
                  Text(
                    state.error.isEmpty ? 'Something went wrong' : state.error,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<AssignedOrdersDetailsCubit>()
                        .fetchAssignedOrderDetails(widget.order_id),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is AssignedOrdersDetailsLoaded) {
            final m = state.assignedOrdersDetails;
            final customer = (m.data?.orderedCustomer?.isNotEmpty ?? false)
                ? m.data!.orderedCustomer!.first
                : null;

            final qty = _totalQty(m);
            final value = _totalValue(m);

            return CustomScrollView(
              slivers: [
                _sliverGradientAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _customerCard(
                          name: customer?.customerName ?? '—',
                          mobile: customer?.mobile ?? '—',
                          address: customer?.address ?? '—',
                        ),
                        const SizedBox(height: 16),
                        _summaryRow(
                          orderBoxes: qty,
                          extraBoxes:
                              0, // if you have extra boxes in model, replace this
                          totalValue: value,
                        ),
                        const SizedBox(height: 16),
                        _orderItemsCard(m),
                        const SizedBox(height: 16),

                        // OTP section
                        _otpSection(
                          orderId: m.data?.orderId ?? '',
                          mobile: customer?.mobile ?? '',
                        ),
                        const SizedBox(height: 16),

                        // Photo section
                        _photoSection(),
                        const SizedBox(height: 16),

                        // // QR section (keep static or wire to your payment info)
                        // _qrSection(),
                        // const SizedBox(height: 16),

                        // Submit
                        BlocConsumer<
                          UpdateOrderStatusCubit,
                          UpdateOrderStatusStates
                        >(
                          listener: (context, state) {
                            if (state is UpdateOrderStatusUpdated) {
                              context
                                  .read<AssignedOrdersCubit>()
                                  .fetchAssignedOrders();
                              CustomSnackBar1.show(
                                context,
                                state.successModel.message ?? "",
                              );
                              context.pop();
                            } else if (state is UpdateOrderStatusFailure) {
                              CustomSnackBar1.show(context, state.error);
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is UpdateOrderStatusLoading;
                            return ElevatedButton.icon(
                              onPressed: (_otpVerified && _photoFile != null)
                                  ? () {
                                      Map<String, dynamic> data = {
                                        "order_status": "delivered",
                                        "delivery_image": _photoFile?.path,
                                      };
                                      context
                                          .read<UpdateOrderStatusCubit>()
                                          .updateOrderStatus(
                                            widget.order_id,
                                            data,
                                          );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                backgroundColor: primarycolor,
                              ),
                              label: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Submit & Complete Delivery',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ============ APP BAR ============

  Widget _gradientAppBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFA6C3F), Color(0xFFEF3F60)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: const [
            Positioned(
              left: 8,
              top: 8,
              bottom: 8,
              child: BackButton(color: Colors.white),
            ),
            Center(
              child: Text(
                'Delivery Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliverGradientAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 60,
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: const BackButton(color: Colors.white),
      centerTitle: true,
      title: const Text(
        'Delivery Details',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFA6C3F), Color(0xFFEF3F60)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  // ============ CARDS ============

  Widget _customerCard({
    required String name,
    required String mobile,
    required String address,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(mobile, style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 2),
            Text(address),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow({
    required int orderBoxes,
    required int extraBoxes,
    required double totalValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _boxCountCard(
          'Order Boxes',
          '$orderBoxes',
          _currency(totalValue),
          Colors.orange.shade50,
          emphasisColor: Colors.deepOrange,
        ),
        _boxCountCard(
          'Extra Boxes',
          '$extraBoxes',
          extraBoxes > 0 ? 'Added' : '—',
          Colors.red.shade50,
          emphasisColor: Colors.red,
        ),
        _boxCountCard(
          'Total Value',
          _currency(totalValue),
          '$orderBoxes boxes',
          Colors.green.shade50,
          emphasisColor: Colors.green,
        ),
      ],
    );
  }

  Widget _boxCountCard(
    String title,
    String value1,
    String value2,
    Color bgColor, {
    Color emphasisColor = Colors.green,
  }) {
    return Expanded(
      child: Card(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(
                value1,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(value2, style: TextStyle(color: emphasisColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderItemsCard(AssignedOrdersDetailsModel m) {
    final items = m.data?.orders ?? const <Orders>[];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((o) {
              final q = o.quantity ?? 0;
              final amt = o.totalAmount ?? '0.00';
              return Container(
                width: 140,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.productName ?? '—',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text('Qty: $q'),
                    Text(
                      'Amount: ₹$amt',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ============ OTP ============
  Widget _otpSection({required String orderId, required String mobile}) {
    return BlocConsumer<CustomerGenerateOtpCubit, CustomerGenerateOtpStates>(
      listener: (context, state) {
        if (state is CustomerGenerateOtpGenerated) {
          _generatingOtp = false;
          _otpSent = true;
          _otpVerified = false;
          CustomSnackBar1.show(context, state.successModel.message ?? "");
        } else if (state is CustomerGenerateOtpVerified) {
          _verifying = false;
          _otpVerified = true;
          _otpSent = false;
          CustomSnackBar1.show(context, state.successModel.message ?? "");
        } else if (state is CustomerGenerateOtpFailure) {
          CustomSnackBar1.show(context, state.error ?? "");
        }
      },
      builder: (context, state) {
        // ✅ hide OTP section completely if already verified
        if (_otpVerified) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_otpSent) ...[
              const Text(
                'Delivery OTP Verification',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _generatingOtp
                    ? null
                    : () {
                        setState(() => _generatingOtp = true);
                        Map<String, dynamic> data = {"order_id": orderId};
                        context.read<CustomerGenerateOtpCubit>().generateOtp(
                          data,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  backgroundColor: Colors.orangeAccent,
                ),
                child: state is CustomerGenerateOtpLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Generate OTP'),
              ),
            ],

            if (_otpSent) ...[
              const Text('Enter the 4-digit OTP sent to customer'),
              const SizedBox(height: 8),
              PinCodeTextField(
                appContext: context,
                controller: _otpController,
                length: 6, // ✅ usually 4 digits, adjust if needed
                autoFocus: true,
                keyboardType: TextInputType.number,
                enableActiveFill: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  inactiveColor: Colors.grey.shade400,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeFillColor: Colors.white,
                  activeColor: Colors.green,
                  selectedColor: Colors.deepOrange,
                ),
                onChanged: (_) {},
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: state is CustomerGenerateOtpLoading
                          ? null
                          : () {
                              Map<String, dynamic> data = {
                                "mobile": mobile,
                                "otp": _otpController.text,
                              };
                              context
                                  .read<CustomerGenerateOtpCubit>()
                                  .verifyOtp(data);
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        backgroundColor: Colors.greenAccent,
                      ),
                      child: state is CustomerGenerateOtpLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'Verify OTP',
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Not verified',
                    style: TextStyle(color: Colors.red.shade400),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: _generatingOtp
                    ? null
                    : () {
                        setState(() => _generatingOtp = true);
                        Map<String, dynamic> data = {"order_id": orderId};
                        context.read<CustomerGenerateOtpCubit>().generateOtp(
                          data,
                        );
                      },
                child: _generatingOtp
                    ? const Text('Sending...')
                    : const Text('Resend OTP'),
              ),
            ],
          ],
        );
      },
    );
  }

  // ============ PHOTO ============

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
                        Text(
                          'Required for completion',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  // ============ QR ============

  Widget _qrSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Scan this QR Code to process your payment'),
        const SizedBox(height: 12),
        // Replace with your dynamic QR if available
        Image.asset('assets/qr.png', height: 160, fit: BoxFit.contain),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Text('This QR Code will expire in 04:59')),
        ),
      ],
    );
  }
}
