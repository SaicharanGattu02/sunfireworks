import 'package:flutter/material.dart';

import '../../utils/media_query_helper.dart';

class DeliveryByLocationsScreen extends StatelessWidget {
  const DeliveryByLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text(
          "Delivery by Locations",
          style: TextStyle(
            fontFamily: "roboto",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // // Progress
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: const [
          //             Text("Delivery Progress",
          //                 style: TextStyle(
          //                     fontFamily: "roboto",
          //                     fontSize: 14,
          //                     fontWeight: FontWeight.w500)),
          //             Text("1/5 Delivered",
          //                 style: TextStyle(
          //                     fontFamily: "roboto",
          //                     fontSize: 14,
          //                     fontWeight: FontWeight.w500,
          //                     color: Colors.red)),
          //           ],
          //         ),
          //         const SizedBox(height: 8),
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(8),
          //           child: LinearProgressIndicator(
          //             value: 0.2,
          //             minHeight: 8,
          //             backgroundColor: Colors.grey.shade300,
          //             valueColor: const AlwaysStoppedAnimation(Colors.red),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // Transport Card
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
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage("assets/images/driver.png"),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Raju Transport",
                              style: TextStyle(
                                  fontFamily: "roboto",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text("AP 31 AT 5678  •  15 Jan 2020",
                              style: TextStyle(
                                  fontFamily: "roboto",
                                  fontSize: 13,
                                  color: Colors.black54)),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 16, color: Colors.blue),
                              SizedBox(width: 4),
                              Text("Tirupati Main Bus Stand",
                                  style: TextStyle(
                                      fontFamily: "roboto",
                                      fontSize: 13,
                                      color: Colors.black87)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Column(
                      children: [
                        Image.asset("assets/images/truck.png",
                            height: 100, fit: BoxFit.contain),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // Order Boxes Card
          SliverToBoxAdapter(
            child: _summaryCard(
              title: "Order Boxes",
              total: "50",
              amount: "₹136,500",
              items: [
                _boxTile("Normal", 20, "₹1,500", "₹30,000"),
                _boxTile("Combo", 12, "₹2,000", "₹24,000"),
                _boxTile("Double", 8, "₹4,000", "₹32,000"),
                _boxTile("Triple", 5, "₹6,000", "₹30,000"),
                _boxTile("Special", 3, "₹3,500", "₹10,500"),
                _boxTile("More", 0, "", ""),
              ],
              footer: "Ordered 60   •   Given 50   •   Left 10",
              footerColor: Colors.orange.shade50,
            ),
          ),

          // Extra Boxes Card
          SliverToBoxAdapter(
            child: _summaryCard(
              title: "Extra Boxes",
              total: "20",
              amount: "₹42,600",
              bgColor: Colors.red.shade50,
              items: [
                _boxTile("Normal", 8, "₹1,500", "₹12,000"),
                _boxTile("Combo", 5, "₹2,000", "₹10,000"),
                _boxTile("Double", 3, "₹4,000", "₹12,000"),
                _boxTile("Special", 2, "₹3,500", "₹7,000"),
                _boxTile("Mini", 1, "₹800", "₹1,600"),
              ],
              footer: "Requested 25   •   Given 20   •   Left 5",
              footerColor: Colors.red.shade100,
            ),
          ),

          // Grand Total
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Grand Total",
                      style: TextStyle(
                          fontFamily: "roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Text("₹179,100   70 boxes",
                      style: TextStyle(
                          fontFamily: "roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green)),
                ],
              ),
            ),
          ),

          // OTP Verification
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Enter The 4 Digit OTP",
                      style: TextStyle(
                          fontFamily: "roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                          (index) => Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("",
                            style: TextStyle(
                                fontFamily: "roboto",
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Click To Next verification",
                        style: TextStyle(
                            fontFamily: "roboto",
                            fontSize: 14,
                            color: Colors.white)),
                  )
                ],
              ),
            ),
          ),

          // Photo Verification
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Delivery Photo Verification",
                      style: TextStyle(
                          fontFamily: "roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt, size: 30, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Tap to capture delivery photo",
                              style: TextStyle(
                                  fontFamily: "roboto",
                                  fontSize: 13,
                                  color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Submit & Complete Delivery",
                        style: TextStyle(
                            fontFamily: "roboto",
                            fontSize: 14,
                            color: Colors.black54)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String total,
    required String amount,
    required List<Widget> items,
    String? footer,
    Color? footerColor,
    Color? bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontFamily: "roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              Text("Total: $total\n$amount",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontFamily: "roboto",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items,
          ),
          if (footer != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: footerColor ?? Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                footer,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: "roboto",
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _boxTile(String label, int count, String price, String total) {
    return Container(
      width: SizeConfig.screenWidth*0.26,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontFamily: "roboto",
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87)),
          const SizedBox(height: 6),
          Text("$count",
              style: const TextStyle(
                  fontFamily: "roboto",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
          const SizedBox(height: 4),
          Text(price,
              style: const TextStyle(
                  fontFamily: "roboto",
                  fontSize: 12,
                  color: Colors.black54)),
          Text(total,
              style: const TextStyle(
                  fontFamily: "roboto",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.green)),
        ],
      ),
    );
  }
}
