import 'package:flutter/material.dart';
import 'package:comfort_zone/presentation/screens/profiles_screen.dart';
import 'package:comfort_zone/presentation/screens/settings_screen.dart';
import 'package:comfort_zone/presentation/screens/location_selection_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _notifications = [

  ];
  @override
  void initState() {
    super.initState();
    _notifications = [
      {'message': 'Гроза в течение ближайшего часа', 'type': 2},
      {'message': 'Сильный ветер', 'type': 1},
      {'message': 'Повышенный уровень УФ-индекса', 'type': 1},
   ];
  }
  bool get hasThreats {
    return _notifications.any((notification) => notification['type'] == 2);
  }

  bool get hasWarnings {
    return _notifications.any((notification) => notification['type'] == 1);
  }
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
    if (_notifications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              'Предупреждений нет',
              textAlign: TextAlign.center,  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Color (0xFF2592E1),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Notifications',
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              heightFactor: 1.0,
              widthFactor: 0.8,
              child: _NotificationsPanel(notifications: _notifications),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasThreats = _notifications.any((notification) => notification['type'] == 2);
    bool hasWarnings = _notifications.any((notification) => notification['type'] == 1);

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
class _NotificationsPanel extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;

  const _NotificationsPanel({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    bool hasThreats = notifications.any((notification) => notification['type'] == 2);
    bool hasWarnings = notifications.any((notification) => notification['type'] == 1);

    return Material(
      color: const Color(0xFF469EE0),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white.withOpacity(0.15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Угрозы',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = notifications[index];
                  return Column(
                      children: [
                        const SizedBox(height: 16),
                   Container(
                  decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  ),
                    child: ListTile(
                      leading: Icon(
                        Icons.warning,
                        color: notification['type'] == 2 ? Colors.redAccent : Colors.yellowAccent, // Red for threat, Yellow for warning
                      ),
                      title: Text(
                        notification['message'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                  ),
                  ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
              _buildExtraInfo(context),
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
              color: (parentState?.hasThreats ?? false)
                  ? Colors.red
                  : (parentState?.hasWarnings ?? false)
                  ? Colors.yellow
                  : Colors.white,
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
      {
        'label': 'Ветер',
        'icon': Icons.air,
      },
      {
        'label': 'Осадки',
        'icon': Icons.grain,
      },
      {
        'label': 'Влажность',
        'icon': Icons.water_drop,
      },
      {
        'label': 'УФ-индекс',
        'icon': Icons.wb_sunny,
      },
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
                context,
              );
            }).toList(),
          ),
        );
      },
    );
  }


  Widget _infoButton(String label, IconData icon, double size, BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context, label),
      child: Container(
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
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }


  void _showBottomSheet(BuildContext context, String label) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withOpacity(0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        Widget sheetContent;
        switch (label) {
          case 'Ветер':
            sheetContent = const WindSheetContent();
            break;
          case 'Осадки':
            sheetContent = const PrecipitationSheetContent();
            break;
          case 'Влажность':
            sheetContent = const HumiditySheetContent();
            break;
          case 'УФ-индекс':
            sheetContent = const UvIndexSheetContent();
            break;
          case 'Остальные показатели':
            sheetContent = const HealthStatusSheetContent();
            break;
          default:
            sheetContent = const Text('Неизвестный параметр');
        }

        return FractionallySizedBox(
          heightFactor: 0.91,
          widthFactor: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF469EE0).withOpacity(0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Expanded(child: sheetContent),
              ],
            ),
          ),
        );
      },
    );
  }





  Widget _buildExtraInfo(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context, 'Остальные показатели'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Пыльца: ', style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('Низкая', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Магнитное поле:', style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('Умеренное', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Давление:', style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('1012 гПа', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }


}
class WindSheetContent extends StatelessWidget {
  const WindSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column (
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Главное',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Скорость ветра сейчас составляет N км/ч, направление: восток-юго-восток. Сегодня скорость ветра составит от n до n км/ч с порывами до n км/ч.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                SizedBox(height: 15),
                CustomLineChart(
                  points: [
                    FlSpot(0, 5),
                    FlSpot(3, 9),
                    FlSpot(6, 12),
                    FlSpot(9, 15),
                    FlSpot(12, 17),
                    FlSpot(15, 16),
                    FlSpot(18, 13),
                    FlSpot(21, 10),
                  ],
                  xUnit: 'часы',
                  yUnit: '°C',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('О скорости и порывах ветра',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Скорость ветра рассчитывается на основе среднего значения за короткий период времени. Порыв - это резкое увеличение скорости ветра относительно его средней скорости. Обычно порыв длится менее 20 секунд.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Сравнение по дням',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Максимальная скорость ветра сегодня ниже чем вчера.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                ComparisonBarWidget(
                  value1: 5.4,
                  value2: 2.2,
                  label1: 'Сегодня',
                  label2: 'Вчера',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('О шкале Бофорта',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Шкала Бофорта используется для оценки силы ветра в зависимости от его скорости. Она помогает понять, насколько крепок ветер и какие последсвтия он может вызвать. Каждое значение на шкале соответсвует определённому диапазону скоростей.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
          SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Шкала Бофорта',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                BeaufortScaleWidget(),
              ],
            ),
          ),
        ),
      ],
    ),
    );

  }
}
class HealthStatusSheetContent  extends StatelessWidget {
  const HealthStatusSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column (
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('О пыльце',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('ээ',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Уровни пыльцы',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('ээ',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('О геомагнитном поле',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('ээ',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Уровни геомагнитной активности',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('ээ',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Давление',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Давление стабильное и сейчас составляет 1019 гПа. Сегодня среднее давление достигает отметки 1020 гПа, а минимальное значение опустится до 1018гПа.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                SizedBox(height: 15),
                CustomLineChart(
                  points: [
                    FlSpot(0, 5),
                    FlSpot(3, 9),
                    FlSpot(6, 12),
                    FlSpot(9, 15),
                    FlSpot(12, 17),
                    FlSpot(15, 16),
                    FlSpot(18, 13),
                    FlSpot(21, 10),
                  ],
                  xUnit: 'часы',
                  yUnit: '°C',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('О давлении',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Существенные, резкие изменения давления используются для прогнозирования изменений погоды. Например, падение давления может означать, что скоро пойдёт доджь или снег, а повышение давления может предвещать улучшение погоды. Давление также называют барометрическим давлением или атмосферным.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    ),
    );

  }
}
class PrecipitationSheetContent extends StatelessWidget {
  const PrecipitationSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column (
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Главное',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('За последние 24 часа общее количество осадков составило 0 мм. Сегодня общее количество осадков составит 0 мм. В следующий раз осадки ожидаются 4 апреля в виде снега.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                SizedBox(height: 15),
                CustomLineChart(
                  points: [
                    FlSpot(0, 5),
                    FlSpot(3, 9),
                    FlSpot(6, 12),
                    FlSpot(9, 15),
                    FlSpot(12, 17),
                    FlSpot(15, 16),
                    FlSpot(18, 13),
                    FlSpot(21, 10),
                  ],
                  xUnit: 'часы',
                  yUnit: '°C',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Общий объём осадков',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('За последние сутки выпало 0 мм.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                Text('За следующие сутки выпадет 0 мм.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                ComparisonBarWidget(
                  value1: 5.4,
                  value2: 2.2,
                  label1: 'Сегодня',
                  label2: 'Вчера',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Об интенсивности осадков',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Интенсивность рассчитывается исходя из того, сколько дождя или снега выпадает за час, и указывает, насколько сильным будет ощущаться дождь или снег. Этот показатель также используется и с другими типами осадков, такими как ледяной дождь и снег с дождём. Ливень или метель могут характеризоваться как обильные осадки. А умеренные или небольшие - это, к примеру, моросящий дождь.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    ),
    );

  }
}

class HumiditySheetContent extends StatelessWidget {
  const HumiditySheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:Column (
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Главное',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Сегодня средняя влажность составит 63%. Точка росы: от -1° до 1°.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                SizedBox(height: 15),
                CustomLineChart(
                  points: [
                    FlSpot(0, 5),
                    FlSpot(3, 9),
                    FlSpot(6, 12),
                    FlSpot(9, 15),
                    FlSpot(12, 17),
                    FlSpot(15, 16),
                    FlSpot(18, 13),
                    FlSpot(21, 10),
                  ],
                  xUnit: 'часы',
                  yUnit: '°C',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Сравнение по дням',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Средний уровень влажности сегодня ниже, чем вчера.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                ComparisonBarWidget(
                  value1: 5.4,
                  value2: 2.2,
                  label1: 'Сегодня',
                  label2: 'Вчера',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Об относительной влажности',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Относительная влажность, или просто влажность, - это отношение количества влаги в воздухе к максимальному количеству, которое может содержаться в воздухе. При высокой температуре в воздухе может содержаться больше влаги. Если относительная влажность составляет около 100%, это может означать наличие росы или тумана.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('О точке росы',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Точка росы - это значение, до каторого должна снизиться температура, чтобы образовалась роса. Это удобный способ определения влажности воздуха: чем выше точка росы, тем более влажным ощущается воздух.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
        ),
    );

  }
}

class UvIndexSheetContent extends StatelessWidget {
  const UvIndexSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    child:Column (
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Главное',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('УФ-индекс сейчас n, что является низким значением.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                SizedBox(height: 15),
                CustomLineChart(
                  points: [
                    FlSpot(0, 5),
                    FlSpot(3, 9),
                    FlSpot(6, 12),
                    FlSpot(9, 15),
                    FlSpot(12, 17),
                    FlSpot(15, 16),
                    FlSpot(18, 13),
                    FlSpot(21, 10),
                  ],
                  xUnit: 'часы',
                  yUnit: '°C',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Сравнение по дням',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('Максимальный УФ-индекс сешлжня выше, чем вчера.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
                ComparisonBarWidget(
                  value1: 5.4,
                  value2: 2.2,
                  label1: 'Сегодня',
                  label2: 'Вчера',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Об УФ-индексе',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 6),
                Text('УФ-индекс (УФИ), разработанный Всемирной Организацией Здравоохранения, обознвчает мощность фиолетового излучения. Чем он выше, тем опаснее находиться под солнцем и тем быстрее это может навредить здоровью. При значении УФ-индекса 3 и выше ВОЗ рекомендует находиться в тени, пользоваться солнцезащитными средствами и носить головные уборы и закрытую одежду.',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16)),
              ],
            ),
          ),
        ),

      ],
    ),
    );
  }
}
// Шкала Бофорта (1 виджет)

class BeaufortScaleWidget extends StatelessWidget {
  const BeaufortScaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = [
      {'label': 'Штиль', 'speed': '0 км/ч', 'color': Colors.blue.shade100},
      {'label': 'Легкий ветер', 'speed': '1–5 км/ч', 'color': Colors.blue.shade200},
      {'label': 'Слабый ветер', 'speed': '6–11 км/ч', 'color': Colors.lightBlue},
      {'label': 'Умеренный ветер', 'speed': '12–19 км/ч', 'color': Colors.lightBlueAccent},
      {'label': 'Свежий ветер', 'speed': '20–28 км/ч', 'color': Colors.cyan},
      {'label': 'Сильный ветер', 'speed': '29–38 км/ч', 'color': Colors.teal},
      {'label': 'Крепкий ветер', 'speed': '39–49 км/ч', 'color': Colors.green},
      {'label': 'Очень крепкий ветер', 'speed': '50–61 км/ч', 'color': Colors.yellow},
      {'label': 'Шторм', 'speed': '62–74 км/ч', 'color': Colors.orange},
      {'label': 'Сильный шторм', 'speed': '75–88 км/ч', 'color': Colors.deepOrange},
      {'label': 'Жестокий шторм', 'speed': '89–102 км/ч', 'color': Colors.red},
      {'label': 'Ураган', 'speed': '103–117 км/ч', 'color': Colors.purple},
      {'label': 'Сильный ураган', 'speed': '>118 км/ч', 'color': Colors.black},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Шкала Бофорта',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(levels.length, (index) {
            final level = levels[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: level['color'] as Color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Уровень $index', style: const TextStyle(color: Colors.white)),
                  Text(level['label'] as String, style: const TextStyle(color: Colors.white)),
                  Text(level['speed'] as String, style: const TextStyle(color: Colors.white)),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

//   child: BeaufortScaleWidget(),

// Сравнение двух показателей (2 виджет)
class ComparisonBarWidget extends StatelessWidget {
  final double value1;
  final double value2;
  final String label1;
  final String label2;

  const ComparisonBarWidget({
    super.key,
    required this.value1,
    required this.value2,
    this.label1 = 'A',
    this.label2 = 'B',
  });

  @override
  Widget build(BuildContext context) {
    final max = value1 > value2 ? value1 : value2;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label1), Text(value1.toString())],
        ),
        LinearProgressIndicator(
          value: value1 / max,
          minHeight: 8,
          color: Colors.green,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label2), Text(value2.toString())],
        ),
        LinearProgressIndicator(
          value: value2 / max,
          minHeight: 8,
          color: Colors.orange,
        ),
      ],
    );
  }
}
 // ComparisonBarWidget(
 // value1: 5.4,
 // value2: 2.2,
 // label1: 'Сегодня',
 // label2: 'Вчера',
 // ),

class CustomLineChart extends StatelessWidget {
  final List<FlSpot> points;
  final String xUnit;
  final String yUnit;

  const CustomLineChart({
    super.key,
    required this.points,
    required this.xUnit,
    required this.yUnit,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: points,
              isCurved: true,
              barWidth: 3,
              color: Colors.blue,
              dotData: FlDotData(show: false),
            ),
          ],
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}
// CustomLineChart(
// points: [
// FlSpot(0, 5),
// FlSpot(3, 9),
// FlSpot(6, 12),
// FlSpot(9, 15),
// FlSpot(12, 17),
// FlSpot(15, 16),
// FlSpot(18, 13),
// FlSpot(21, 10),
// ],
// xUnit: 'часы',
// yUnit: '°C',
// ),