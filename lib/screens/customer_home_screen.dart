import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int selectedCategory = 0;
  int selectedNavigation = 0;

  static const navy = Color(0xFF12305D);
  static const blue = Color(0xFF1173EA);
  static const grey = Color(0xFF75849B);
  static const background = Color(0xFFF4F7FD);

  final categories = ['All', 'Economy', 'SUV', 'Luxury'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _header()),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const Text(
                          'Find Your Car',
                          style: TextStyle(
                            color: navy,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Discover and book cars from local rental offices in your city.',
                          style: TextStyle(
                            color: grey,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _searchBox(),
                        const SizedBox(height: 14),
                        _categories(),
                        const SizedBox(height: 22),
                        const Text(
                          'Available Cars',
                          style: TextStyle(
                            color: navy,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          '4 cars found',
                          style: TextStyle(color: grey, fontSize: 14),
                        ),
                        const SizedBox(height: 15),
                        _carCard(),
                        const SizedBox(height: 12),
                        _carCard(),
                        const SizedBox(height: 20),
                      ]),
                    ),
                  ),
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
            backgroundColor: const Color(0xFFE8EEF7),
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
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _searchRow(Icons.location_on_outlined, 'Pickup Location'),
          const Divider(height: 1),
          _searchRow(Icons.calendar_month_outlined, 'Pickup Date'),
          const Divider(height: 1),
          _searchRow(Icons.calendar_month_outlined, 'Return Date'),
          Padding(
            padding: const EdgeInsets.all(4),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Search Cars',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchRow(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
        child: Row(
          children: [
            Icon(icon, color: blue, size: 21),
            const SizedBox(width: 11),
            Text(
              title,
              style: const TextStyle(color: grey, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categories() {
    return Row(
      children: List.generate(categories.length, (index) {
        final selected = selectedCategory == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == categories.length - 1 ? 0 : 7,
            ),
            child: InkWell(
              onTap: () {
                setState(() => selectedCategory = index);
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? blue : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: selected ? Colors.white : navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _carCard() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/car.png',
                  width: double.infinity,
                  height: 185,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned(
                top: 10,
                left: 10,
                child: _StatusBadge(
                  text: 'Economy',
                  color: Color(0xFFF1F5F9),
                  textColor: grey,
                ),
              ),
              const Positioned(
                top: 10,
                right: 10,
                child: _StatusBadge(
                  text: 'Available',
                  color: Color(0xFFDDFBEA),
                  textColor: Color(0xFF1CAF61),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Toyota Camry 2023',
            style: TextStyle(
              color: navy,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          const Row(
            children: [
              Icon(Icons.star, color: Color(0xFFFFBF19), size: 20),
              SizedBox(width: 4),
              Text('4.8', style: TextStyle(color: navy)),
              SizedBox(width: 4),
              Text('(124)', style: TextStyle(color: grey)),
            ],
          ),
          const SizedBox(height: 7),
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: grey, size: 17),
              SizedBox(width: 4),
              Text('Downtown', style: TextStyle(color: grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 13),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CarFeature(Icons.people_outline, '5 Seats'),
              _CarFeature(Icons.local_gas_station_outlined, 'Petrol'),
              _CarFeature(Icons.settings_outlined, 'Automatic'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              SizedBox(
                width: 130,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$45',
                    style: TextStyle(
                      color: blue,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'per day',
                    style: TextStyle(color: navy, fontSize: 13),
                  ),
                ],
              ),
            ],
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
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Explore',
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

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _StatusBadge({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 11),
      ),
    );
  }
}

class _CarFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CarFeature(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF75849B), size: 17),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Color(0xFF75849B), fontSize: 12),
        ),
      ],
    );
  }
}