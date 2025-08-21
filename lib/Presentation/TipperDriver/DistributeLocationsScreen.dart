import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/Models/TipperDriver/DriverAssignmentModel.dart';
import '../../data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_cubit.dart';
import '../../data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_states.dart';

class DistributeLocationsScreen extends StatefulWidget {
  const DistributeLocationsScreen({super.key});

  @override
  State<DistributeLocationsScreen> createState() =>
      _DistributeLocationsScreenState();
}

class _DistributeLocationsScreenState extends State<DistributeLocationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load first page
    context.read<DriverAssignmentCubit>().getDriverAssignments();
  }

  bool _onScroll(ScrollNotification n) {
    if (n is ScrollEndNotification ||
        n is UserScrollNotification ||
        n is OverscrollNotification) {
      final m = n.metrics;
      if (m.pixels >= (m.maxScrollExtent - 200)) {
        context.read<DriverAssignmentCubit>().fetchMoreDriverAssignments();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
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
          "Distribute by Locations",
          style: TextStyle(
            fontFamily: "roboto",
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: BlocBuilder<DriverAssignmentCubit, DriverAssignmentStates>(
          builder: (context, state) {
            bool hasNext = false;
            bool firstLoading = false;
            bool appending = false;
            String? error;
            DriverAssignmentModel? model;

            if (state is DriverAssignmentLoading) {
              firstLoading = true;
            } else if (state is DriverAssignmentLoaded) {
              model = state.driverAssignmentModel;
              hasNext = state.hasNextPage;
            } else if (state is DriverAssignmentLoadingMore) {
              model = state.driverAssignmentModel;
              hasNext = state.hasNextPage;
              appending = true;
            } else if (state is DriverAssignmentFailure) {
              error = state.error;
            }

            if (firstLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (error != null) {
              return _ErrorView(
                message: error!,
                onRetry: () => context
                    .read<DriverAssignmentCubit>()
                    .getDriverAssignments(),
              );
            }

            // Flatten assigned_cars across all results
            final cars = _flattenAssignedCars(model);

            if (cars.isEmpty) {
              return CustomScrollView(
                slivers: [
                  _targetHeader(context),
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text("No assigned cars found.")),
                  ),
                ],
              );
            }

            return CustomScrollView(
              slivers: [
                _targetHeader(context),

                // Assigned cars list with pagination tail
                SliverList.builder(
                  itemCount: cars.length + (hasNext ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= cars.length) {
                      // tail loader
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final c = cars[index];
                    return _carCard(
                      index: index + 1,
                      driverName: c.driverName,
                      vehicleNumber: c.vehicleNumber,
                      ordersCount: c.ordersCount,
                      status: c.status,
                      onNav: () => context.push("/delivery_by_locations"),
                    );
                  },
                ),

                if (appending) const SliverToBoxAdapter(child: SizedBox(height: 8)),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------- UI pieces ----------

  SliverToBoxAdapter _targetHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 8),
            const Text(
              "Assigned Cars",
              style: TextStyle(
                fontFamily: "roboto",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: () =>
                  context.read<DriverAssignmentCubit>().getDriverAssignments(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carCard({
    required int index,
    required String driverName,
    required String vehicleNumber,
    required int ordersCount,
    required String status,
    required VoidCallback onNav,
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
          // Left avatar + index
          Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.red.shade100,
                child: const Icon(Icons.local_shipping, color: Colors.red),
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.red.shade200,
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
                  driverName,
                  style: const TextStyle(
                    fontFamily: "roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.directions_car, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      vehicleNumber,
                      style: const TextStyle(fontFamily: "roboto", fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: _statusColor(status)),
                    const SizedBox(width: 6),
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
              ],
            ),
          ),

          // Right action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: onNav,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
}

// ---------- Helpers: flatten + map assigned_cars safely ----------

class _AssignedCarView {
  final String driverName;
  final String vehicleNumber;
  final int ordersCount;
  final int radius;
  final String status;

  _AssignedCarView({
    required this.driverName,
    required this.vehicleNumber,
    required this.ordersCount,
    required this.radius,
    required this.status,
  });
}

List<_AssignedCarView> _flattenAssignedCars(DriverAssignmentModel? model) {
  final out = <_AssignedCarView>[];
  final results = model?.data?.results ?? const <Results>[];

  for (final r in results) {
    final list = r.assignedCars; // List<AssignedCars>?
    if (list == null || list.isEmpty) continue;

    for (final item in list) {
      out.add(_AssignedCarView(
        driverName: item.car?.driver ?? '—',
        vehicleNumber: item.car?.vehicleNumber ?? '—',
        ordersCount: item.ordersCount ?? 0,
        radius: item.radius ?? 0,
        status: item.status ?? '—',
      ));
    }
  }
  return out;
}

Color _statusColor(String s) {
  final x = s.toLowerCase();
  if (x.contains('pending')) return Colors.orange;
  if (x.contains('active') || x.contains('running')) return Colors.blue;
  if (x.contains('completed') || x.contains('done')) return Colors.green;
  return Colors.black54;
}

// ---------- Simple error view ----------
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}

