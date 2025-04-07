import 'package:flutter/material.dart';
import 'package:comfort_zone/presentation/screens/profiles_screen.dart';
import 'package:comfort_zone/presentation/screens/settings_screen.dart';
import 'package:comfort_zone/presentation/screens/location_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _hasNotifications = false;
  final List<Widget> _screens = [
    const SwipeWrapper(child: HomeScreenContent()),
    const ProfilesScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _toggleNotifications() {
    setState(() {
      _hasNotifications = !_hasNotifications;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color (0xFF2592E1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }


}
class SwipeWrapper extends StatelessWidget {
  final Widget child;

  const SwipeWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.black54,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.ease)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: const LocationSelectionScreen(),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
      child: child,
    );
  }

}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final parentState = context.findAncestorStateOfType<_HomeScreenState>();
    return Scaffold(
      backgroundColor: const Color(0xFF469EE0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(parentState),
              const SizedBox(height: 20),
              _buildHourlyForecast(),
              const SizedBox(height: 20),
              _buildSunsetCard(),
              const SizedBox(height: 20),
              _buildDailyForecast(),
              const SizedBox(height: 20),
              _buildInfoButtons(context),
              const SizedBox(height: 20),
              _buildExtraInfo(),
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildTopSection(_HomeScreenState? parentState) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  '9°',
                  style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Icon(Icons.wb_cloudy, color: Colors.grey, size: 60),
              ],
            ),
            const Text(
              'Значительная облачность',
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Text('Первомайский район', style: TextStyle(color: Colors.white,fontSize: 22)),
                Icon(Icons.location_on, color: Colors.red, size: 32),
                SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 4),
            const Text('9° / -1°  Ощущается как 8°', style: TextStyle(color: Colors.white60,fontSize: 18)),
            const SizedBox(height: 20),
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: Icon(
              Icons.warning,
              color: parentState?._hasNotifications ?? false ? Colors.red : Colors.white,
              size: 32,
            ),
            onPressed: () {
              if (parentState != null) {
                parentState._toggleNotifications();
              }
            },
          ),
        ),
      ],
    );
  }


  Widget _buildHourlyForecast() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(6, (index) => _hourBlock('16:00', Icons.wb_sunny, '9°', '1%')),
          ),
        ],
      ),
    );
  }

  Widget _hourBlock(String time, IconData icon, String temp, String rain) {
    return Column(
      children: [
        Text(time, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        Icon(icon, color: Colors.orange),
        const SizedBox(height: 4),
        Text(temp, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        Text(rain, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }

  Widget _buildSunsetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'Закат в 19:36',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildDailyForecast() {
    return Container(
        width: double.infinity,
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.15),
    borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: List.generate(5, (index) => _dayForecastRow('Сегодня', Icons.sunny, Icons.nightlight_round, '9°', '-1°', '1%')),
    ),
    );
  }

  Widget _dayForecastRow(String day, IconData icon,IconData iconNight, String high, String low, String rain) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Icon(icon, color: Colors.orange),
          Icon(iconNight, color: Colors.white),
          Text('$high / $low', style: const TextStyle(color: Colors.white)),
          Text(rain, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildInfoButtons(BuildContext context) {
    final items = [
      {'label': 'Ветер', 'icon': Icons.air},
      {'label': 'Осадки', 'icon': Icons.grain},
      {'label': 'Влажность', 'icon': Icons.water_drop},
      {'label': 'УФ-индекс', 'icon': Icons.wb_sunny},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = (constraints.maxWidth - 60) / 2;

        return Center(
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: items.map((item) {
              return _infoButton(
                item['label'] as String,
                item['icon'] as IconData,
                itemWidth,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _infoButton(String label, IconData icon, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildExtraInfo() {
    return Container(
        decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
    borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Пыльца: ', style: TextStyle(color: Colors.white, fontSize: 20)),
              Text(' ', style: TextStyle(color: Colors.transparent)),
              Text('Низкая', style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Давление:', style: TextStyle(color: Colors.white, fontSize: 20)),
              Text(' ', style: TextStyle(color: Colors.transparent)),
              Text('1012 гПа', style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Магнитое поле:', style: TextStyle(color: Colors.white, fontSize: 20)),
              Text(' ', style: TextStyle(color: Colors.transparent)),
              Text('1', style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ),
      ],
    ),
    );
  }


}
