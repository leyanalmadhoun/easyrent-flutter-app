import 'package:flutter/material.dart';

import 'office_bookings_screen.dart';
import 'office_dashboard_screen.dart';
import 'office_my_cars_screen.dart';
import 'office_notifications_screen.dart';
import 'office_profile_screen.dart';

class OfficeBottomNav extends StatelessWidget {
  final int currentIndex;
  const OfficeBottomNav({super.key, required this.currentIndex});

  void _open(BuildContext context, int index) {
    if (index == currentIndex) return;
    final pages = <Widget>[
      const OfficeDashboardScreen(),
      const OfficeMyCarsScreen(),
      const OfficeBookingsScreen(),
      const OfficeNotificationsScreen(),
      const OfficeProfileScreen(),
    ];
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => pages[index]));
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1173EA);
    const navy = Color(0xFF12305D);
    const items = [
      (Icons.home_outlined, Icons.home_rounded, 'Dashboard'),
      (Icons.directions_car_outlined, Icons.directions_car_rounded, 'My Cars'),
      (Icons.calendar_month_outlined, Icons.calendar_month_rounded, 'Bookings'),
      (Icons.notifications_none_rounded, Icons.notifications_rounded, 'Notifications'),
      (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
    ];
    return SafeArea(
      top: false,
      child: Container(
        height: 72,
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE7ECF3)))),
        child: Row(
          children: List.generate(items.length, (index) {
            final selected = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => _open(context, index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(selected ? items[index].$2 : items[index].$1, color: selected ? blue : navy, size: 23),
                    const SizedBox(height: 4),
                    FittedBox(child: Text(items[index].$3, style: TextStyle(color: selected ? blue : navy, fontSize: 10, fontWeight: selected ? FontWeight.w800 : FontWeight.w500))),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
