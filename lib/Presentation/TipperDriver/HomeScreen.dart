import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              pinned: true,
              floating: false,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.person, color: Colors.black),
                onPressed: () {},
              ),
              centerTitle: true,
              title: const Text(
                "Sun Fireworks",
                style: TextStyle(
                  fontFamily: "roboto",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            ),

            // Truck Card
            SliverToBoxAdapter(
              child: Container(
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
                    // Truck Image with dynamic text
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          "assets/images/truck.png", // your red DCM truck image
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order: 500 boxes",
                                style: const TextStyle(
                                  fontFamily: "roboto",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Extra: 300 boxes",
                                style: const TextStyle(
                                  fontFamily: "roboto",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "AP 26BX 5295",
                          style: TextStyle(
                            fontFamily: "roboto",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                          ),
                          child: const Text(
                            "View Details",
                            style: TextStyle(
                              fontFamily: "roboto",
                              fontSize: 14,
                            ),
                          ),
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

            // Target Location List
            SliverList(
              delegate: SliverChildListDelegate([
                _locationCard(
                  index: 1,
                  city: "Tirupati",
                  km: 580,
                  orderBoxes: 250,
                  extraBoxes: 100,
                  status: "Unloading",
                ),
                _locationCard(
                  index: 2,
                  city: "Nellore",
                  km: 500,
                  orderBoxes: 250,
                  extraBoxes: 100,
                  status: "In Transit",
                ),
                _locationCard(
                  index: 3,
                  city: "Vijayawada",
                  km: 500,
                  orderBoxes: 250,
                  extraBoxes: 100,
                  status: "Handover Started",
                ),
                _locationCard(
                  index: 4,
                  city: "Ongole",
                  km: 500,
                  orderBoxes: 250,
                  extraBoxes: 100,
                  status: "Delivery Completed",
                ),
                _locationCard(
                  index: 5,
                  city: "Kadapa",
                  km: 500,
                  orderBoxes: 250,
                  extraBoxes: 100,
                  status: "Ready for Dispatch",
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
    required String city,
    required int km,
    required int orderBoxes,
    required int extraBoxes,
    required String status,
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
                onPressed: () {},
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
