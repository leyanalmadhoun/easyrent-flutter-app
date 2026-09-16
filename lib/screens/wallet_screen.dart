import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

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
          title: const Text('Wallet & Payments', style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w800)),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF12305D), Color(0xFF1173EA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Color(0x301173EA), blurRadius: 18, offset: Offset(0, 8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Wallet Balance', style: TextStyle(color: Color(0xFFDCEAFF), fontSize: 14)), Icon(Icons.account_balance_wallet_outlined, color: Colors.white)]),
                  const SizedBox(height: 14),
                  const Text('\$250.00', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add Money'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: blue, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text('Recent Transactions', style: TextStyle(color: navy, fontSize: 21, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            const _TransactionTile(icon: Icons.directions_car_rounded, title: 'Toyota Corolla Booking', date: 'September 5, 2026', amount: '-\$120.00', positive: false),
            const SizedBox(height: 11),
            const _TransactionTile(icon: Icons.replay_rounded, title: 'Booking Refund', date: 'August 20, 2026', amount: '+\$80.00', positive: true),
            const SizedBox(height: 11),
            const _TransactionTile(icon: Icons.directions_car_rounded, title: 'Honda Civic Booking', date: 'July 15, 2026', amount: '-\$150.00', positive: false),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final bool positive;

  const _TransactionTile({required this.icon, required this.title, required this.date, required this.amount, required this.positive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFE8EDF4))),
      child: Row(
        children: [
          Container(width: 45, height: 45, decoration: BoxDecoration(color: positive ? const Color(0xFFEAF9EF) : const Color(0xFFFFEEEE), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: positive ? const Color(0xFF16A34A) : const Color(0xFFEF4444), size: 23)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: WalletScreen.navy, fontSize: 14, fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(date, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12))])),
          Text(amount, style: TextStyle(color: positive ? const Color(0xFF16A34A) : const Color(0xFFEF4444), fontSize: 15, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
