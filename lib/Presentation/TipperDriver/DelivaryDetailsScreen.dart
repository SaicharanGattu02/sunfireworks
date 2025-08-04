import 'package:flutter/material.dart';

class DeliveryDetails extends StatelessWidget {
  const DeliveryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Delivery Details",
          style: TextStyle(
            fontFamily: "roboto",
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // Truck Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Image.asset("assets/images/truck.png"), // Truck image
                const Positioned(
                  left: 24,
                  top: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order: 500 boxes",
                        style: TextStyle(
                          fontFamily: "roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Extra: 100 boxes",
                        style: TextStyle(
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
          ),

          // Driver Info
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage("assets/images/driver.jpg"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Rajesh Kumar",
                        style: TextStyle(
                          fontFamily: "roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Driver",
                        style: TextStyle(
                          fontFamily: "roboto",
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "+91 9876543210",
                            style: TextStyle(
                              fontFamily: "roboto",
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "16/07/2025",
                            style: TextStyle(
                              fontFamily: "roboto",
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.local_shipping, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "AP 16 BD 7867",
                            style: TextStyle(
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

          // Delivery Summary
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Delivery Summary",
                  style: TextStyle(
                    fontFamily: "roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _summaryRow("Order Boxes:", "500"),
                SizedBox(height: 12),
                _summaryRow("Extra Boxes:", "100"),
                SizedBox(height: 12),
                _summaryRow("Total Boxes:", "600", highlight: true),
              ],
            ),
          ),

          const Spacer(),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "View all products",
                  style: TextStyle(
                    fontFamily: "roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Summary row widget
class _summaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _summaryRow(this.label, this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "roboto",
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: "roboto",
            fontSize: 14,
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            color: highlight ? Colors.black : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
