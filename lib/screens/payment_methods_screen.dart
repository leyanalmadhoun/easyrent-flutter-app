import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  static const navy = Color(0xFF12305D);
  static const blue = Color(0xFF1173EA);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FD),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navy)),
          title: const Text('Payment Methods', style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w800)),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 28),
          children: [
            const _PaymentTile(icon: Icons.credit_card_rounded, iconColor: Color(0xFF1A237E), title: 'Visa Credit Card', subtitle: '•••• 4567', badge: 'VISA'),
            const SizedBox(height: 12),
            const _PaymentTile(icon: Icons.credit_card_rounded, iconColor: Color(0xFFFF5F00), title: 'Mastercard', subtitle: '•••• 8901', badge: 'MC'),
            const SizedBox(height: 12),
            const _PaymentTile(icon: Icons.account_balance_wallet_rounded, iconColor: Color(0xFF0070BA), title: 'PayPal', subtitle: 'ethan.carter@email.com', badge: 'P'),
            const SizedBox(height: 12),
            const _PaymentTile(icon: Icons.apple_rounded, iconColor: Colors.black, title: 'Apple Pay', subtitle: 'Ethan Carter', badge: 'Pay'),
            const SizedBox(height: 28),
            SizedBox(
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_rounded),
                label: const Text('Add New Payment Method'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: blue,
                  side: const BorderSide(color: blue, width: 1.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;

  const _PaymentTile({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFE8EDF4))),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: iconColor.withValues(alpha: .09), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: iconColor, size: 27)),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: PaymentMethodsScreen.navy, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              ],
            ),
          ),
          Text(badge, style: TextStyle(color: iconColor, fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(width: 8),
          const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8), size: 20),
        ],
      ),
    );
  }
}
