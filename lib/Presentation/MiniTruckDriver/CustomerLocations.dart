import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunfireworks/data/bloc/cubits/UserDetails/UserDetailsCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/UserDetails/UserDetailsStates.dart';

import '../../data/Models/MiniTruckDriver/AssignedOrdersModel.dart';
import '../../data/bloc/cubits/MiniTruckDriver/AssignedOrders/AssignedOrdersCubit.dart';
import '../../data/bloc/cubits/MiniTruckDriver/AssignedOrders/AssignedOrdersStates.dart';

class CustomerLocations extends StatefulWidget {
  const CustomerLocations({super.key});

  @override
  State<CustomerLocations> createState() => _CustomerLocationsState();
}

class _CustomerLocationsState extends State<CustomerLocations> {
  @override
  void initState() {
    context.read<AssignedOrdersCubit>().fetchAssignedOrders();
    context.read<UserDetailsCubit>().fetchUserDetails();
    super.initState();
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1)
      return parts.first.characters.take(2).toString().toUpperCase();
    return (parts.first.characters.take(1).toString() +
            parts.last.characters.take(1).toString())
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 12,
        title: BlocBuilder<UserDetailsCubit, UserDetailsStates>(
          builder: (context, state) {
            String displayName = '—';
            String? avatarUrl;

            if (state is UserDetailsLoading) {
              return Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFFE9E9E9),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'CustomerLocations',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              );
            }

            if (state is UserDetailsLoaded &&
                state.userDetailsModel.data != null) {
              final d = state.userDetailsModel.data!;
              displayName = d.fullName?.trim().isNotEmpty == true
                  ? d.fullName!.trim()
                  : '—';
              avatarUrl = (d.image?.trim().isNotEmpty == true)
                  ? d.image!.trim()
                  : null;
            }

            // Fallback to initials if no URL
            final hasAvatar = (avatarUrl != null && avatarUrl.isNotEmpty);

            return Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
                  child: hasAvatar
                      ? null
                      : Text(
                          _initials(displayName),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
                const SizedBox(width: 12),
                 Text(
                  displayName??"",
                  style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
                ),
              ],
            );
          },
        ),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const _TargetHeader(),
          const SizedBox(height: 12),
          // 🔽 Dynamic list from cubit
          BlocBuilder<AssignedOrdersCubit, AssignedOrdersStates>(
            builder: (context, state) {
              if (state is AssignedOrdersLoading) {
                return const _StopsLoading();
              }
              if (state is AssignedOrdersFailure) {
                return _StopsError(message: state.error);
              }
              if (state is AssignedOrdersLoaded) {
                final items = state.assignedOrders.data ?? const <Data>[];
                if (items.isEmpty) {
                  return const _StopsEmpty();
                }
                // map API -> _Stop (UI model)
                final stops = items.map(_Stop.fromApi).toList();
                return Column(
                  children: [for (final s in stops) _StopCard(stop: s)],
                );
              }
              // Initially
              return const _StopsIdle();
            },
          ),
        ],
      ),
    );
  }
}

class _StopsLoading extends StatelessWidget {
  const _StopsLoading();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (_) => Container(
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StopsEmpty extends StatelessWidget {
  const _StopsEmpty();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        'No assigned orders found.',
        style: TextStyle(color: Colors.black.withOpacity(.7)),
      ),
    );
  }
}

class _StopsError extends StatelessWidget {
  final String message;
  const _StopsError({required this.message});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        'Failed to load: $message',
        style: TextStyle(
          color: Colors.red.shade600,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StopsIdle extends StatelessWidget {
  const _StopsIdle();
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// --------------------------- HEADER ---------------------------
// class _Header extends StatelessWidget {
//   const _Header();
//
//   static const _g1 = Color(0xFFFF7A00);
//   static const _g2 = Color(0xFFFF5151);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       padding: const EdgeInsets.fromLTRB(20, 26, 20, 18),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [_g1, _g2],
//         ),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Text(
//             'Raju Transport',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               height: 1.1,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Distribute boxes to Customers',
//             style: TextStyle(
//               color: Colors.white.withOpacity(.9),
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 16),
//           _ReachedCard(),
//         ],
//       ),
//     );
//   }
// }
class _ReachedCard extends StatelessWidget {
  const _ReachedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(.15),
            Colors.white.withOpacity(.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _circleIcon(Icons.check, const Color(0x33FFFFFF)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Reached Customers Locations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _circleIcon(Icons.card_giftcard, const Color(0x33FFFFFF)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _chip(icon: Icons.access_time, label: '09:42 pm'),
              const SizedBox(width: 10),
              _chip(icon: Icons.event, label: '08 Jul 2025'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _StatBlock(title: 'Order Boxes', value: '250'),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _StatBlock(title: 'Extra Boxes', value: '100'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _circleIcon(IconData icon, Color bg) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  static Widget _chip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String title;
  final String value;
  const _StatBlock({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.18)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text('', style: TextStyle(fontSize: 0)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------ TARGET HEADER ------------------------
class _TargetHeader extends StatelessWidget {
  const _TargetHeader();

  @override
  Widget build(BuildContext context) {
    final label = TextStyle(
      color: Colors.black.withOpacity(.9),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.place_rounded, color: Colors.black87),
          const SizedBox(width: 8),
          Text('Target Locations', style: label),
          // const Spacer(),
          // Icon(Icons.sync, color: Colors.black.withOpacity(.6)),
          // const SizedBox(width: 12),
          // Icon(Icons.tune, color: Colors.black.withOpacity(.6)),
          // const SizedBox(width: 10),
          // Text(
          //   'See All',
          //   style: TextStyle(
          //     color: Colors.red.shade500,
          //     fontWeight: FontWeight.w700,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _StopCard extends StatelessWidget {
  final _Stop stop;
  const _StopCard({required this.stop});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push("/customer_delivery?order_id=${stop.orderId}");
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _MapThumb(),
                Positioned(
                  left: -6,
                  bottom: -6,
                  child: _NumberBadge(number: stop.idx),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(child: _StopInfo(stop: stop)),
            const SizedBox(width: 10),
            _RightPanel(stop: stop),
          ],
        ),
      ),
    );
  }
}

class _MapThumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder “map thumb”
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 58,
        height: 58,
        color: const Color(0xFFEFF1F4),
        child: const Icon(
          Icons.directions_car_filled,
          color: Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  final int number;
  const _NumberBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFFF5A5A),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _StopInfo extends StatelessWidget {
  final _Stop stop;
  const _StopInfo({required this.stop});

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: Colors.black.withOpacity(.9),
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.05,
    );
    final subStyle = TextStyle(
      color: Colors.black.withOpacity(.6),
      fontSize: 13.5,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${stop.titleLines[0]}', style: titleStyle),
        const SizedBox(height: 6),
        Text('Distance : ${stop.avgKm.toStringAsFixed(2)} km', style: subStyle),
        if (stop.address != null) ...[
          const SizedBox(height: 4),
          Text(
            stop.address!,
            style: subStyle.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          stop.status,
          style: TextStyle(
            color: stop.statusColor,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RightPanel extends StatelessWidget {
  final _Stop stop;
  const _RightPanel({required this.stop});

  @override
  Widget build(BuildContext context) {
    final muted = TextStyle(
      color: Colors.black.withOpacity(.55),
      fontWeight: FontWeight.w700,
    );
    final alert = TextStyle(
      color: Colors.red.shade500,
      fontWeight: FontWeight.w700,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (stop.amount != null) Text('₹ ${stop.amount}', style: alert),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            // _openMapsForLocation(context, stop.location, stop.address);
          },
          icon: const Icon(Icons.near_me, size: 18),
          label: const Text('Navigate'),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.red.shade500,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _Stop {
  final int idx;
  final List<String> titleLines;
  final double avgKm; // using API "distance"
  final int?
  orderBoxes; // not in API; keep nullable or repurpose if you get count later
  final int? extraBoxes; // not in API
  final String status; // show ETA/duration or a label
  final Color statusColor;
  final String? orderId;
  final String? address;
  final String? mobile;
  final String? amount;
  final String? location; // "lat,lng" string

  _Stop({
    required this.idx,
    required this.titleLines,
    required this.avgKm,
    this.orderBoxes,
    this.extraBoxes,
    required this.status,
    required this.statusColor,
    this.orderId,
    this.address,
    this.mobile,
    this.amount,
    this.location,
  });

  // ✅ API -> UI
  factory _Stop.fromApi(Data d, {int index = 0}) {
    final name = d.customerDetails?.customerName?.trim().isNotEmpty == true
        ? d.customerDetails!.customerName!.trim()
        : 'Customer';
    final parts = name.split(' ');
    final line1 = parts.isNotEmpty ? parts.first : name;
    final line2 = parts.length > 1
        ? parts.sublist(1).join(' ')
        : (d.orderId ?? '');

    final dist = (d.distance is num)
        ? (d.distance as num).toDouble()
        : double.tryParse('${d.distance}') ?? 0.0;

    final dur = (d.duration?.toString().trim().isNotEmpty ?? false)
        ? d.duration.toString()
        : 'Assigned';

    return _Stop(
      idx: index + 1,
      titleLines: [line1, line2],
      avgKm: dist,
      orderBoxes: null, // unknown from API; keep hidden in UI if null
      extraBoxes: null, // unknown from API
      status: dur, // show "4 mins" etc.
      statusColor: const Color(0xFF1DB954),
      orderId: d.id,
      address: d.customerDetails?.address,
      mobile: d.customerDetails?.mobile,
      amount: d.totalAmount,
      location: d.location,
    );
  }
}
