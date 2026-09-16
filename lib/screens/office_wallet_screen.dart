import 'package:flutter/material.dart';

class OfficeWalletScreen extends StatelessWidget {
  const OfficeWalletScreen({super.key});
  static const navy = Color(0xFF12305D);
  static const blue = Color(0xFF1173EA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: AppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.white, centerTitle: true, leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navy)), title: const Text('Wallet & Payments', style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w800))),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19), border: Border.all(color: const Color(0xFFE7ECF3)), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 14, offset: Offset(0, 5))]), child: Column(children: [
          const Text('Wallet Balance', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          const SizedBox(height: 10),
          const Text('\$250.00', style: TextStyle(color: navy, fontSize: 36, fontWeight: FontWeight.w900)),
          const SizedBox(height: 22),
          Row(children: [Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: blue, side: const BorderSide(color: blue), minimumSize: const Size(0, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))), child: const Text('Withdraw'))), const SizedBox(width: 10), Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: blue, foregroundColor: Colors.white, elevation: 0, minimumSize: const Size(0, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))), child: const Text('Add Money')))]),
        ])),
        const SizedBox(height: 28),
        const Text('Recent Transactions', style: TextStyle(color: navy, fontSize: 21, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        const _OfficeTransaction(title: 'Toyota Corolla Booking', date: 'September 5, 2026', amount: '+\$120.00', positive: true),
        const SizedBox(height: 11),
        const _OfficeTransaction(title: 'Booking Refund', date: 'August 20, 2026', amount: '-\$80.00', positive: false),
        const SizedBox(height: 11),
        const _OfficeTransaction(title: 'Honda Civic Booking', date: 'July 15, 2026', amount: '+\$150.00', positive: true),
      ]),
    );
  }
}

class _OfficeTransaction extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final bool positive;
  const _OfficeTransaction({required this.title, required this.date, required this.amount, required this.positive});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)), child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: positive ? const Color(0xFFE8FAF0) : const Color(0xFFFFEEEE), borderRadius: BorderRadius.circular(12)), child: Icon(positive ? Icons.south_west_rounded : Icons.north_east_rounded, color: positive ? const Color(0xFF16A75C) : Colors.red)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: OfficeWalletScreen.navy, fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(date, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12))])), Text(amount, style: TextStyle(color: positive ? const Color(0xFF16A75C) : Colors.red, fontSize: 15, fontWeight: FontWeight.w800))]));
}
