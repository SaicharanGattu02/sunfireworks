import 'package:flutter/material.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
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
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "K. Ramu",
                          style: TextStyle(
                            fontFamily: "roboto",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 16),
                            SizedBox(width: 6),
                            Text(
                              "9876543210",
                              style: TextStyle(fontFamily: "roboto", fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.local_shipping, size: 16),
                            SizedBox(width: 6),
                            Text(
                              "DCM - AP01AB1234",
                              style: TextStyle(fontFamily: "roboto", fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Current Details
            SectionCard(
              title: "Current Details",
              children: const [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Current Location: Nellore",
                      style: TextStyle(fontFamily: "roboto", fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.alt_route, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Route: Tirupati Area",
                      style: TextStyle(fontFamily: "roboto", fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Work Info
            SectionCard(
              title: "Work Info",
              children: [
                _workRow("Total Deliveries", "120", Icons.check_circle,
                    Colors.green),
                const SizedBox(height: 12),
                _workRow("Active Orders", "3", Icons.assignment_outlined,
                    Colors.orange),
                const SizedBox(height: 12),
                _workRow("Extra Boxes Delivered", "50", Icons.card_giftcard,
                    Colors.purple),
              ],
            ),
            const SizedBox(height: 20),

            // Options
            SectionCard(
              title: "Options",
              children: [
                _optionRow("Edit Profile", Icons.edit, Colors.blue),
                const SizedBox(height: 14),
                _optionRow("My Documents", Icons.description,
                    Colors.green),
                const SizedBox(height: 14),
                _optionRow("Logout", Icons.logout, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _workRow(
      String title, String value, IconData icon, Color color) {
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
              fontFamily: "roboto", fontSize: 15, fontWeight: FontWeight.w600),
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
