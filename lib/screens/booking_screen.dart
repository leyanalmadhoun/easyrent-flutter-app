import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/car_image.dart';

class BookingScreen extends StatefulWidget {
  final String carId;
  final Map<String, dynamic> car;
  const BookingScreen({super.key, required this.carId, required this.car});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const Color navy = Color(0xFF12305D);
  static const Color blue = Color(0xFF1173EA);
  static const Color grey = Color(0xFF64748B);
  DateTime? pickupDate;
  DateTime? returnDate;
  TimeOfDay? pickupTime;
  TimeOfDay? returnTime;
  int deliveryOption = 0;
  int paymentMethod = 0;
  bool loading = false;

  Future<void> _confirmBooking() async {
    if (pickupDate == null || returnDate == null || pickupTime == null || returnTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select pickup and return dates and times.')));
      return;
    }
    final pickup = DateTime(pickupDate!.year, pickupDate!.month, pickupDate!.day, pickupTime!.hour, pickupTime!.minute);
    final returned = DateTime(returnDate!.year, returnDate!.month, returnDate!.day, returnTime!.hour, returnTime!.minute);
    if (!returned.isAfter(pickup)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Return time must be after pickup time.')));
      return;
    }
    setState(() => loading = true);
    try {
      await FirebaseService.createBooking(carId: widget.carId, car: widget.car, pickup: pickup, returned: returned, delivery: deliveryOption == 0 ? 'office' : 'address', payment: ['card', 'wallet', 'cash'][paymentMethod]);
      if (!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking request sent successfully.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking failed: $e')));
    } finally { if (mounted) setState(() => loading = false); }
  }

  String _dateText(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _pickDate(bool pickup) async {
    final value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (value != null) setState(() => pickup ? pickupDate = value : returnDate = value);
  }

  Future<void> _pickTime(bool pickup) async {
    final value = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (value != null) setState(() => pickup ? pickupTime = value : returnTime = value);
  }

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
          title: const Text('Book Now', style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w700)),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: SizedBox(
                              height: 165,
                              width: double.infinity,
                              child: CarImage(url: widget.car['imageUrl'] as String?, width: double.infinity, height: 165),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('${widget.car['name'] ?? 'Car'}', style: const TextStyle(color: navy, fontSize: 21, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 5),
                          Text('${widget.car['description'] ?? 'Comfortable and ready for your next trip.'}', style: const TextStyle(color: grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(child: _PickerField(label: 'Pick-up Date', value: _dateText(pickupDate), icon: Icons.calendar_month_outlined, onTap: () => _pickDate(true))),
                        const SizedBox(width: 12),
                        Expanded(child: _PickerField(label: 'Return Date', value: _dateText(returnDate), icon: Icons.calendar_month_outlined, onTap: () => _pickDate(false))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _PickerField(label: 'Pick-up Time', value: pickupTime?.format(context) ?? 'Select time', icon: Icons.schedule_rounded, onTap: () => _pickTime(true))),
                        const SizedBox(width: 12),
                        Expanded(child: _PickerField(label: 'Return Time', value: returnTime?.format(context) ?? 'Select time', icon: Icons.schedule_rounded, onTap: () => _pickTime(false))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _Title('Pick-up & Delivery'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _ChoiceCard(text: 'Pick up from office', selected: deliveryOption == 0, onTap: () => setState(() => deliveryOption = 0))),
                        const SizedBox(width: 10),
                        Expanded(child: _ChoiceCard(text: 'Deliver to my address', selected: deliveryOption == 1, onTap: () => setState(() => deliveryOption = 1))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _Title('Required Documents'),
                    const SizedBox(height: 10),
                    const _UploadTile(icon: Icons.badge_outlined, text: 'Driving License'),
                    const SizedBox(height: 10),
                    const _UploadTile(icon: Icons.credit_card_outlined, text: 'National ID'),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document upload will be connected next.'))),
                        icon: const Icon(Icons.upload_file_rounded),
                        label: const Text('Upload Documents'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const _Title('Payment Method'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _PaymentCard(icon: Icons.credit_card_rounded, text: 'Card', selected: paymentMethod == 0, onTap: () => setState(() => paymentMethod = 0))),
                        const SizedBox(width: 9),
                        Expanded(child: _PaymentCard(icon: Icons.account_balance_wallet_outlined, text: 'Wallet', selected: paymentMethod == 1, onTap: () => setState(() => paymentMethod = 1))),
                        const SizedBox(width: 9),
                        Expanded(child: _PaymentCard(icon: Icons.payments_outlined, text: 'Cash', selected: paymentMethod == 2, onTap: () => setState(() => paymentMethod = 2))),
                      ],
                    ),
                    const SizedBox(height: 26),
                    const _Title('Booking Summary'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                      child: const Column(
                        children: [
                          _SummaryRow(label: 'Toyota Corolla 2023', value: '\$40/day × 3'),
                          Divider(height: 1),
                          _SummaryRow(label: 'Taxes and fees', value: '\$15'),
                          Divider(height: 1),
                          _SummaryRow(label: 'Total', value: '\$135', bold: true),
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
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, -3))]),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: _bottomButton(false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: loading ? null : _confirmBooking,
                        style: _bottomButton(true),
                        child: loading ? const SizedBox(width:22,height:22,child:CircularProgressIndicator(color:Colors.white,strokeWidth:2)) : const Text('Confirm Booking'),
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

  ButtonStyle _bottomButton(bool filled) {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(54)),
      backgroundColor: WidgetStatePropertyAll(filled ? blue : Colors.white),
      foregroundColor: WidgetStatePropertyAll(filled ? Colors.white : blue),
      side: filled ? null : const WidgetStatePropertyAll(BorderSide(color: blue, width: 1.4)),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: _BookingScreenState.navy, fontSize: 19, fontWeight: FontWeight.w800));
  }
}

class _PickerField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  const _PickerField({required this.label, required this.value, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF172033), fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 7),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Container(
            height: 51,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFDCE2EA)), borderRadius: BorderRadius.circular(11)),
            child: Row(
              children: [
                Icon(icon, color: _BookingScreenState.navy, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(value, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _BookingScreenState.grey, fontSize: 13))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _ChoiceCard({required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 53,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF2FF) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: selected ? _BookingScreenState.blue : Colors.transparent),
        ),
        child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: selected ? _BookingScreenState.navy : const Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const _UploadTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFDCE2EA)), borderRadius: BorderRadius.circular(11)),
      child: Row(
        children: [
          Icon(icon, color: _BookingScreenState.navy, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          const Icon(Icons.add_circle_outline_rounded, color: _BookingScreenState.blue, size: 21),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _PaymentCard({required this.icon, required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: selected ? _BookingScreenState.blue : const Color(0xFFDCE2EA)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? _BookingScreenState.blue : _BookingScreenState.navy, size: 22),
            const SizedBox(width: 7),
            Text(text, style: const TextStyle(color: _BookingScreenState.navy, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: _BookingScreenState.navy, fontSize: 14, fontWeight: bold ? FontWeight.w800 : FontWeight.w500))),
          Text(value, style: TextStyle(color: _BookingScreenState.navy, fontSize: 14, fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
        ],
      ),
    );
  }
}
