import 'package:flutter/material.dart';

class DistributionDetailsScreen extends StatelessWidget {
  const DistributionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Distribution Details'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFA6C3F), Color(0xFFEF3F60)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage('assets/driver.jpg'),
                        ),
                        title: const Text(
                          'Raju Transport',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'AP 31 AT 5678',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Distribution Progress',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: LinearProgressIndicator(
                          value: 0.25,
                          color: Colors.green,
                          backgroundColor: Colors.white30,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Boxes: 70',
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              'People: 4',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _driverCard(),
                  const SizedBox(height: 16),
                  _summaryCard(),
                  const SizedBox(height: 16),
                  _boxCategoryCard(),
                  const SizedBox(height: 16),
                  _extraBoxCard(),
                  const SizedBox(height: 16),
                  _otpSection(),
                  const SizedBox(height: 16),
                  _photoSection(),
                  const SizedBox(height: 16),
                  _qrSection(),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.grey.shade300,
                    ),
                    icon: const Icon(Icons.camera_alt, color: Colors.grey),
                    label: const Text(
                      'Submit & Complete Delivery',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/user1.jpg'),
        ),
        title: const Text('Ramesh Kumar'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('+91 98765 43210', style: TextStyle(color: Colors.blue)),
            const Text('Shop No. 45, Tirupati Main Market'),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _boxCountCard('Order Boxes', '12', '₹28,500', Colors.orange.shade50),
        _boxCountCard('Extra Boxes', '5', '₹7,300', Colors.red.shade50),
        _boxCountCard(
          'Total Value',
          '₹35,800',
          '17 boxes',
          Colors.green.shade50,
        ),
      ],
    );
  }

  Widget _boxCountCard(
    String title,
    String value1,
    String value2,
    Color bgColor,
  ) {
    return Expanded(
      child: Card(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                value1,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(value2, style: const TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _boxCategoryCard() {
    return _categoryCard('Order Box Categories', 12, [
      ['Normal', 5, '₹7,500'],
      ['Combo', 3, '₹6,000'],
      ['Double', 2, '₹8,000'],
      ['Special', 2, '₹7,000'],
    ], Colors.orange.shade50);
  }

  Widget _extraBoxCard() {
    return _categoryCard('Extra Box Categories', 5, [
      ['Normal', 3, '₹4,500'],
      ['Combo', 1, '₹2,000'],
      ['Mini', 1, '₹800'],
    ], Colors.red.shade50);
  }

  Widget _categoryCard(
    String title,
    int total,
    List<List<dynamic>> items,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title   Total: $total',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                width: 100,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      item[0],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${item[1]}'),
                    Text(item[2], style: const TextStyle(color: Colors.green)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _otpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter The 4 Digit OTP'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) => _otpBox()),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 44),
            backgroundColor: Colors.greenAccent,
          ),
          child: const Text(
            'Click To Next verification',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _otpBox() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _photoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Delivery Photo Verification'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined, color: Colors.grey),
                Text(
                  'Tap to capture delivery photo',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Required for completion',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _qrSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Scan this QR Code to process your payment'),
        const SizedBox(height: 12),
        Image.asset('assets/qr.png', height: 160),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('This QR Code will be expired in 04:59'),
          ),
        ),
      ],
    );
  }
}
