import 'package:flutter/material.dart';

class OfficeDashboardScreen extends StatefulWidget {
  const OfficeDashboardScreen({super.key});

  @override
  State<OfficeDashboardScreen> createState() =>
      _OfficeDashboardScreenState();
}

class _OfficeDashboardScreenState extends State<OfficeDashboardScreen> {
  int selectedNavigation = 0;

  static const navy = Color(0xFF12305D);
  static const blue = Color(0xFF1173EA);
  static const grey = Color(0xFF75849B);
  static const background = Color(0xFFF4F7FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _header(),
                  const SizedBox(height: 24),
                  _statistics(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 25, 20, 12),
                    child: Text(
                      'Recent Bookings',
                      style: TextStyle(
                        color: navy,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _bookingCard(
                    status: 'Pending',
                    statusColor: const Color(0xFFB77900),
                    statusBackground: const Color(0xFFFFF5CC),
                  ),
                  _bookingCard(
                    status: 'Confirmed',
                    statusColor: const Color(0xFF159447),
                    statusBackground: const Color(0xFFE2FBEA),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Text(
                      'Car Status',
                      style: TextStyle(
                        color: navy,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _carStatusCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            _bottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: const AssetImage('assets/images/profile.png'),
            onBackgroundImageError: (_, __) {},
          ),
          const Spacer(),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Easy',
                      style: TextStyle(color: navy),
                    ),
                    TextSpan(
                      text: 'Rent',
                      style: TextStyle(color: blue),
                    ),
                  ],
                ),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Easy Rent',
                style: TextStyle(color: navy, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Image(
            image: AssetImage('assets/images/logo.png'),
            width: 50,
            height: 60,
          ),
        ],
      ),
    );
  }

  Widget _statistics() {
    return SizedBox(
      height: 115,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        children: const [
          _StatisticCard(
            title: 'Total Cars',
            value: '25',
            detail: '+2 from last month',
          ),
          _StatisticCard(
            title: 'Available Cars',
            value: '8',
            detail: '67% available',
          ),
          _StatisticCard(
            title: 'Bookings',
            value: '25',
            detail: '+1 today',
          ),
        ],
      ),
    );
  }

  Widget _bookingCard({
    required String status,
    required Color statusColor,
    required Color statusBackground,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.chevron_right, color: grey),
          const SizedBox(width: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
            decoration: BoxDecoration(
              color: statusBackground,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: statusColor.withOpacity(.4)),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 11),
            ),
          ),
          const Spacer(),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Mercedes-Benz C-Class',
                style: TextStyle(
                  color: navy,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text('John Carter', style: TextStyle(color: grey, fontSize: 11)),
              SizedBox(height: 4),
              Text(
                '12/03/24 – 15/03/24',
                style: TextStyle(color: grey, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(
              'assets/images/car_thumbnail.png',
              width: 70,
              height: 75,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _carStatusCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.chevron_right, color: grey),
          const Spacer(),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Mercedes-Benz C-Class',
                style: TextStyle(
                  color: navy,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _OfficeBadge(),
            ],
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(
              'assets/images/car_thumbnail.png',
              width: 70,
              height: 75,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigation() {
    return BottomNavigationBar(
      currentIndex: selectedNavigation,
      onTap: (index) {
        setState(() => selectedNavigation = index);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: blue,
      unselectedItemColor: navy,
      selectedFontSize: 9,
      unselectedFontSize: 9,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car_outlined),
          label: 'My Cars',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final String detail;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF75849B), fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF12305D),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            detail,
            style: const TextStyle(color: Color(0xFF22B85A), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _OfficeBadge extends StatelessWidget {
  const _OfficeBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2FBEA),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF47CE7B)),
      ),
      child: const Text(
        'Available',
        style: TextStyle(
          color: Color(0xFF159447),
          fontSize: 11,
        ),
      ),
    );
  }
}