import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selected = "Assigned"; // toggle state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.grey[50],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {},
              ),
              centerTitle: true,
              title: const Text(
                "Orders",
                style: TextStyle(
                  fontFamily: "roboto",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              actions: [],
            ),
            // Toggle Buttons (Assigned / Pending)
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverHeaderDelegate(
                minHeight: 70,
                maxHeight: 70,
                child: Container(
                  color: Colors.grey[50],
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      _toggleButton("Assigned", selected == "Assigned"),
                      const SizedBox(width: 12),
                      _toggleButton("Pending", selected == "Pending"),
                    ],
                  ),
                ),
              ),
            ),
            // Orders List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _orderCard(index + 1, selected);
                },
                childCount: 10, // for demo
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton(String text, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selected = text);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? null
                : Border.all(color: Colors.grey.shade400, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: "roboto",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderCard(int orderNo, String type) {
    String status = type == "Assigned"
        ? (orderNo == 2 ? "Loading" : "assigned")
        : "Pending";

    Color statusColor = status == "assigned"
        ? Colors.blue.shade100
        : status == "Loading"
        ? Colors.orange.shade100
        : Colors.blue.shade100;

    Color textColor = status == "assigned"
        ? Colors.blue
        : status == "Loading"
        ? Colors.orange
        : Colors.blue;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row (Order no + Status)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "#$orderNo",
                style: const TextStyle(
                  fontFamily: "roboto",
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: "roboto",
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Name
          const Text(
            "Ramesh",
            style: TextStyle(
              fontFamily: "roboto",
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),

          // Address
          const Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                "123 Main St, Downtown",
                style: TextStyle(
                  fontFamily: "roboto",
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Vehicle & Time
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ramesh",
                        style: TextStyle(
                          fontFamily: "roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Vehicle: TRK-001",
                        style: TextStyle(
                          fontFamily: "roboto",
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "2:30 PM",
                      style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Delivery",
                      style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Box Categories
          const Text(
            "Box Categories (6 total)",
            style: TextStyle(
              fontFamily: "roboto",
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _boxInfo("3", "Normal", Colors.blue.shade50, Colors.blue),
              const SizedBox(width: 10),
              _boxInfo("1", "Extra", Colors.orange.shade50, Colors.orange),
              const SizedBox(width: 10),
              _boxInfo("", "More", Colors.purple.shade50, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _boxInfo(String count, String title, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (count.isNotEmpty)
              Text(
                count,
                style: TextStyle(
                  fontFamily: "roboto",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            if (count.isNotEmpty) const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontFamily: "roboto",
                fontSize: 13,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

