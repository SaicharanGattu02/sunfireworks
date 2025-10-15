import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunfireworks/Components/CustomAppButton.dart';

import '../data/bloc/cubits/UserDetails/UserDetailsCubit.dart';
import '../data/bloc/cubits/UserDetails/UserDetailsStates.dart';
import '../services/AuthService.dart';
import '../utils/AppLogger.dart';
import '../utils/color_constants.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();

  // Reuse helpers you already wrote
  static Widget _workRow(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontFamily: "roboto", fontSize: 15),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: "roboto",
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  static Widget _optionRow(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontFamily: "roboto", fontSize: 15),
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserDetailsCubit>().fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.getRole(),
      builder: (context, asyncSnapshot) {
        final role = asyncSnapshot.data ?? "";
        AppLogger.info("role: ${role}");
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[50],
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: const Text(
              "Driver profile",
              style: TextStyle(
                fontFamily: "roboto",
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                onPressed: role == "dcm_driver" ? () {
                  context.push("/dcm_polyline");
                }:(){
                  context.push("/car_polyline");
                },
                icon: Icon(Icons.route,color: Colors.black,),
              ),
            ],
          ),
          body: BlocBuilder<UserDetailsCubit, UserDetailsStates>(
            builder: (context, state) {
              if (state is UserDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is UserDetailsFailure) {
                return _ErrorView(
                  message: state.error,
                  onRetry: () =>
                      context.read<UserDetailsCubit>().fetchUserDetails(),
                );
              }

              if (state is UserDetailsLoaded) {
                final d = state.userDetailsModel.data;
                final name = d?.fullName ?? "—";
                final mobile = d?.mobile ?? "—";
                final email = d?.email ?? "—";
                final role = d?.userRole ?? "—";
                final gender = _cap(d?.gender);
                final dob = _formatDate(d?.dateOfBirth);
                final avatar = d?.image;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Card (now using network image + data)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: (avatar != null && avatar.isNotEmpty)
                                  ? NetworkImage(avatar)
                                  : null,
                              child: (avatar == null || avatar.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 32,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontFamily: "roboto",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        mobile,
                                        style: const TextStyle(
                                          fontFamily: "roboto",
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.badge, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        role, // using user_role as "designation"
                                        style: const TextStyle(
                                          fontFamily: "roboto",
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Personal Details (replaces your "Current Details" with real fields)
                      SectionCard(
                        title: "Personal Details",
                        children: [
                          _infoRow(
                            icon: Icons.mail_outline,
                            label: "Email",
                            value: email,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 10),
                          _infoRow(
                            icon: Icons.person_outline,
                            label: "Gender",
                            value: gender,
                            color: Colors.purple,
                          ),
                          const SizedBox(height: 10),
                          _infoRow(
                            icon: Icons.cake_outlined,
                            label: "Date of Birth",
                            value: dob,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Work Info (no counts in payload, show as em-dash)
                      SectionCard(
                        title: "Work Info",
                        children: [
                          DriverProfileScreen._workRow(
                            "Total Deliveries",
                            "—",
                            Icons.check_circle,
                            Colors.green,
                          ),
                          const SizedBox(height: 12),
                          DriverProfileScreen._workRow(
                            "Active Orders",
                            "—",
                            Icons.assignment_outlined,
                            Colors.orange,
                          ),
                          const SizedBox(height: 12),
                          DriverProfileScreen._workRow(
                            "Extra Boxes Delivered",
                            "—",
                            Icons.card_giftcard,
                            Colors.purple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomAppButton1(
                        text: "Log Out",
                        onPlusTap: () {
                          showLogoutDialog(context);
                        },
                        color: Color(0xffFF4646),
                      ),
                    ],
                  ),
                );
              }

              // Fallback (shouldn’t hit)
              return const SizedBox.shrink();
            },
          ),
        );
      }
    );
  }

  // Small convenience row for Personal Details
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "$label: $value",
            style: const TextStyle(fontFamily: "roboto", fontSize: 15),
          ),
        ),
      ],
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 4.0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            width: 300.0,
            height: 220.0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Power Icon Positioned Above Dialog
                Positioned(
                  top: -35.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 6.0, color: Colors.white),
                      shape: BoxShape.circle,
                      color: Colors.red.shade100, // Light red background
                    ),
                    child: const Icon(
                      Icons.power_settings_new,
                      size: 40.0,
                      color: Colors.red, // Power icon color
                    ),
                  ),
                ),

                Positioned.fill(
                  top: 30.0, // Moves content down
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15.0),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            color: primarycolor,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "Are you sure you want to logout?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Buttons Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // No Button (Filled)
                            SizedBox(
                              width: 100,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primarycolor,
                                  foregroundColor: Colors.white, // Text color
                                ),
                                child: const Text(
                                  "No",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                            // Yes Button (Outlined)
                            SizedBox(
                              width: 100,
                              height: 45,
                              child: OutlinedButton(
                                onPressed: () async {
                                  await AuthService.logout();
                                  context.go("/sign_in_with_mobile");
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primarycolor, // Text color
                                  side: BorderSide(
                                    color: primarycolor,
                                  ), // Border color
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ========== Section Card (unchanged) ==========
class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SectionCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            title,
            style: const TextStyle(
              fontFamily: "roboto",
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

// ========== Error view ==========
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}

// ========== helpers ==========
String _cap(String? v) {
  if (v == null || v.isEmpty) return "—";
  return v[0].toUpperCase() + v.substring(1);
}

String _formatDate(String? ymd) {
  if (ymd == null || ymd.isEmpty) return "—";
  try {
    final dt = DateTime.parse(ymd); // "2025-08-15"
    // dd MMM yyyy
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}";
  } catch (_) {
    return ymd; // fallback to raw
  }
}
