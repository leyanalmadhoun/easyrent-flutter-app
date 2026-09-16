import 'package:flutter/material.dart';

import 'booking_screen.dart';
import '../widgets/car_image.dart';

class CarDetailsScreen extends StatefulWidget {
  final String carId;
  final Map<String, dynamic> car;
  const CarDetailsScreen({super.key, required this.carId, required this.car});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  static const Color navy = Color(0xFF12305D);
  static const Color blue = Color(0xFF1173EA);
  static const Color grey = Color(0xFF64748B);
  bool isFavorite = false;
  int selectedPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navy),
          ),
          title: const Text(
            'Car Details',
            style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              onPressed: () => setState(() => isFavorite = !isFavorite),
              icon: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFavorite ? Colors.red : navy,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 235,
                      width: double.infinity,
                      child: CarImage(url: widget.car['imageUrl'] as String?, width: double.infinity, height: 235),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.car['name'] ?? 'Car'}',
                                      style: const TextStyle(color: navy, fontSize: 24, fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: const [
                                        Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 22),
                                        SizedBox(width: 5),
                                        Text('4.8', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                        SizedBox(width: 5),
                                        Text('(124 reviews)', style: TextStyle(color: grey, fontSize: 14)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, color: grey, size: 20),
                                        const SizedBox(width: 5),
                                        Text('${widget.car['officeName'] ?? 'Rental Office'}', style: const TextStyle(color: grey, fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 76,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Color(0xFFEAF2FC),
                                      child: Icon(Icons.business_rounded, color: navy),
                                    ),
                                    const SizedBox(height: 7),
                                    Text('${widget.car['officeName'] ?? 'Office'}', textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          const _SectionTitle('Description'),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.car['description'] ?? 'A comfortable car for your next trip.'}',
                            style: const TextStyle(color: grey, fontSize: 15, height: 1.55),
                          ),
                          const SizedBox(height: 26),
                          const _SectionTitle('Car Information'),
                          const SizedBox(height: 8),
                          _InfoRow(icon: Icons.event_seat_outlined, iconColor: const Color(0xFFEF4444), text: '${widget.car['seats'] ?? 5} seats'),
                          _InfoRow(icon: Icons.settings_outlined, iconColor: const Color(0xFFF59E0B), text: '${widget.car['transmission'] ?? 'Automatic'} transmission'),
                          _InfoRow(icon: Icons.local_gas_station_outlined, iconColor: const Color(0xFF22C55E), text: '${widget.car['fuel'] ?? 'Petrol'}'),
                          const _InfoRow(icon: Icons.luggage_outlined, iconColor: Color(0xFF7C3AED), text: 'Large luggage capacity'),
                          const SizedBox(height: 26),
                          const _SectionTitle('Pricing Options'),
                          const SizedBox(height: 3),
                          const Text('Choose the plan that suits you', style: TextStyle(color: grey, fontSize: 13)),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(child: _PriceCard(label: 'Daily', price: '\$${widget.car['dailyPrice'] ?? 0}/day', selected: selectedPrice == 0, onTap: () => setState(() => selectedPrice = 0))),
                              const SizedBox(width: 9),
                              Expanded(child: _PriceCard(label: 'Weekly', price: '\$${widget.car['weeklyPrice'] ?? 0}/week', selected: selectedPrice == 1, onTap: () => setState(() => selectedPrice = 1))),
                              const SizedBox(width: 9),
                              Expanded(child: _PriceCard(label: 'Monthly', price: '\$700/month', selected: selectedPrice == 2, onTap: () => setState(() => selectedPrice = 2))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 13, 22, 14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, -3))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.ios_share_rounded),
                        label: const Text('Share'),
                        style: _buttonStyle(false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(carId: widget.carId, car: widget.car)));
                        },
                        style: _buttonStyle(true),
                        child: const Text('Book Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(bool filled) {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(54)),
      backgroundColor: WidgetStatePropertyAll(filled ? blue : Colors.white),
      foregroundColor: WidgetStatePropertyAll(filled ? Colors.white : blue),
      side: filled ? null : const WidgetStatePropertyAll(BorderSide(color: blue, width: 1.4)),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: _CarDetailsScreenState.navy, fontSize: 21, fontWeight: FontWeight.w800));
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  const _InfoRow({required this.icon, required this.iconColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: iconColor.withValues(alpha: .09), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 21),
          ),
          const SizedBox(width: 13),
          Text(text, style: const TextStyle(color: Color(0xFF172033), fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  final String label;
  final String price;
  final bool selected;
  final VoidCallback onTap;
  const _PriceCard({required this.label, required this.price, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? const Color(0xFF1173EA) : const Color(0xFFE2E8F0), width: selected ? 1.4 : 1),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            const SizedBox(height: 6),
            Text(price, maxLines: 1, style: const TextStyle(color: Color(0xFF12305D), fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
