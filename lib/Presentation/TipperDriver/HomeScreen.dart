import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/Models/TipperDriver/DriverAssignmentModel.dart';
import '../../data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_states.dart';
import '../../data/bloc/cubits/UserDetails/UserDetailsCubit.dart';
import '../../data/bloc/cubits/UserDetails/UserDetailsStates.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<HomeScreen> {
  static const platform = MethodChannel('com.sunfireworks/location');
  @override
  void initState() {
    super.initState();
    context.read<DriverAssignmentCubit>().getDriverAssignments();
  }

  void _startLocationService() async {
    try {
      await platform.invokeMethod('startService', {
        'message': 'Location Service Started',
      });
    } on PlatformException catch (e) {
      print("Failed to start service: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: BlocBuilder<DriverAssignmentCubit, DriverAssignmentStates>(
          builder: (context, state) {
            // ---- State unpacking ----
            DriverAssignmentModel? model;
            bool hasNext = false;
            bool isFirstLoading = false;
            bool isAppending = false;
            String? error;

            if (state is DriverAssignmentLoading) {
              isFirstLoading = true;
            } else if (state is DriverAssignmentLoaded) {
              model = state.driverAssignmentModel;
              hasNext = state.hasNextPage;
            } else if (state is DriverAssignmentLoadingMore) {
              model = state.driverAssignmentModel;
              hasNext = state.hasNextPage;
              isAppending = true;
            } else if (state is DriverAssignmentFailure) {
              error = state.error;
            }

            // ---- First load spinner ----
            if (isFirstLoading) {
              return NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: CustomScrollView(
                  slivers: [
                    _buildHeaderAppBar(),
                    _buildTargetHeader(),
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              );
            }

            // ---- Error UI ----
            if (error != null) {
              return NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: CustomScrollView(
                  slivers: [
                    _buildHeaderAppBar(),
                    _buildTargetHeader(),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Text(
                              error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context
                                .read<DriverAssignmentCubit>()
                                .getDriverAssignments(),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            final results = model?.data?.results ?? const <Results>[];

            // ---- Empty state ----
            if (results.isEmpty) {
              return NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: CustomScrollView(
                  slivers: [
                    _buildHeaderAppBar(),
                    _buildTargetHeader(),
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text("No assignments found.")),
                    ),
                  ],
                ),
              );
            }

            // ---- Main list with infinite scroll ----
            return NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: CustomScrollView(
                slivers: [
                  _buildHeaderAppBar(),
                  _buildTargetHeader(),

                  // Live list from API
                  SliverList.builder(
                    itemCount: results.length + (hasNext ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= results.length) {
                        // Tail loader when hasNext = true
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final r = results[index];

                      // Compute UI values
                      final city =
                          r.wayPointName ?? (r.dcmAssignment?.warehouse ?? "—");

                      final status = r.dcmAssignment?.status ?? "—";
                      return InkWell(
                        onTap: () {
                          context.push("/distribute_locations");
                        },
                        child: _locationCard(
                          index: index + 1,
                          city: city,
                          km: r.distance ?? 0,
                          orderBoxes: r.boxes_count ?? 0,
                          extraBoxes: r.extra_boxes_count ?? 0,
                          status: status,
                          location: r.wayPoint ?? "",
                          context: context,
                        ),
                      );
                    },
                  ),

                  if (isAppending)
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Pagination trigger on scroll
  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollEndNotification ||
        notification is UserScrollNotification ||
        notification is OverscrollNotification) {
      final metrics = notification.metrics;
      final isNearBottom = metrics.pixels >= (metrics.maxScrollExtent - 200);
      if (isNearBottom) {
        context.read<DriverAssignmentCubit>().fetchMoreDriverAssignments();
      }
    }
    return false;
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

  // ======= Your Sliver AppBar & Header =======

  SliverAppBar _buildHeaderAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      centerTitle: false,
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
                displayName ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          );
        },
      ),
      actions: const [],
    );
  }

  SliverToBoxAdapter _buildTargetHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 8),
            const Text(
              "Target Location",
              style: TextStyle(
                fontFamily: "roboto",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            // const Spacer(),
            // IconButton(
            //   icon: const Icon(Icons.refresh, size: 20),
            //   onPressed: () {
            //     context.read<DriverAssignmentCubit>().getDriverAssignments();
            //   },
            // ),
            // IconButton(
            //   icon: const Icon(Icons.filter_list, size: 20),
            //   onPressed: () {
            //     // TODO: open filters if needed
            //   },
            // ),
            // const Text(
            //   "See All",
            //   style: TextStyle(
            //     fontFamily: "roboto",
            //     fontSize: 14,
            //     color: Colors.red,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // ======= Card (unchanged visual from your code) =======

  Widget _locationCard({
    required int index,
    required String city,
    required int km,
    required int orderBoxes,
    required int extraBoxes,
    required String status,
    required String location,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          // Map + Index
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/images/map.png", // static map thumb
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.red,
                child: Text(
                  "$index",
                  style: const TextStyle(
                    fontFamily: "roboto",
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: const TextStyle(
                    fontFamily: "roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Avg KM : $km",
                  style: const TextStyle(fontFamily: "roboto", fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  status,
                  style: TextStyle(
                    fontFamily: "roboto",
                    fontSize: 14,
                    color: _statusColor(status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Right side boxes + button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$orderBoxes order boxes",
                style: const TextStyle(fontFamily: "roboto", fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                "$extraBoxes extra boxes",
                style: const TextStyle(
                  fontFamily: "roboto",
                  fontSize: 13,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // context.push("/map_screen?location=${location}");
                  _startLocationService();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                ),
                icon: const Icon(Icons.navigation, size: 16),
                label: const Text(
                  "Navigate",
                  style: TextStyle(fontFamily: "roboto", fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('pending')) return Colors.orange;
    if (s.contains('transit')) return Colors.blue;
    if (s.contains('handover')) return Colors.indigo;
    if (s.contains('completed') || s.contains('delivered')) return Colors.green;
    if (s.contains('ready')) return Colors.teal;
    if (s.contains('unloading')) return Colors.purple;
    return Colors.black54;
  }
}
