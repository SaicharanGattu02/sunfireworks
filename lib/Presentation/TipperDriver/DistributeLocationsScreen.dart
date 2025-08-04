import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DistributeLocationsScreen extends StatelessWidget {
  const DistributeLocationsScreen({super.key});

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
          "Disturb by Locations",
          style: TextStyle(
            fontFamily: "roboto",
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: CustomScrollView(
          slivers: [
            // Header Card with Gradient
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF512F), Color(0xFFF09819)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      "Raju Transport",
                      style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Distribute boxes to Customers",
                      style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sub Card (white overlay)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Reached Customers Locations",
                            style: TextStyle(
                              fontFamily: "roboto",
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.access_time,
                                color: Colors.white70,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "09:42 pm",
                                style: TextStyle(
                                  fontFamily: "roboto",
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white70,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "08 Jul 2025",
                                style: TextStyle(
                                  fontFamily: "roboto",
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Order & Extra Boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Column(
                          children: [
                            Text(
                              "Order Boxes",
                              style: TextStyle(
                                fontFamily: "roboto",
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "250",
                              style: TextStyle(
                                fontFamily: "roboto",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Extra Boxes",
                              style: TextStyle(
                                fontFamily: "roboto",
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "100",
                              style: TextStyle(
                                fontFamily: "roboto",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Target Location Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list, size: 20),
                      onPressed: () {},
                    ),
                    const Text(
                      "See All",
                      style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Locations List
            SliverList(
              delegate: SliverChildListDelegate([
                _locationCard(
                  index: 1,
                  name: "Ramesh Kumar",
                  km: 50,
                  orderBoxes: 120,
                  extraBoxes: 10,
                  status: "Unloading",
                  context: context,
                ),
                _locationCard(
                  index: 2,
                  name: "Lakshmi Stores",
                  km: 40,
                  orderBoxes: 50,
                  extraBoxes: 10,
                  status: "In Transit",
                  context: context,
                ),
                _locationCard(
                  index: 3,
                  name: "Venkatesh Traders",
                  km: 20,
                  orderBoxes: 76,
                  extraBoxes: 24,
                  status: "Handover Started",
                  context: context,
                ),
                _locationCard(
                  index: 4,
                  name: "Sita General Store",
                  km: 20,
                  orderBoxes: 50,
                  extraBoxes: 10,
                  status: "Delivery Completed",
                  context: context,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationCard({
    required int index,
    required String name,
    required int km,
    required int orderBoxes,
    required int extraBoxes,
    required String status,
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
                  name,
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
                  style: const TextStyle(
                    fontFamily: "roboto",
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Right side
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
                  context.push("/delivery_by_locations");
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
}
