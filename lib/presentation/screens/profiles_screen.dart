import 'package:flutter/material.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  _ProfilesScreenState createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2592E1),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
             labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(
                icon: Icon(Icons.directions_car, color: Colors.white),
                text: 'Водитель',
              ),
              Tab(
                icon: Icon(Icons.water_drop, color: Colors.white),
                text: 'Рыбак',

              ),
              Tab(
                icon: Icon(Icons.agriculture, color: Colors.white),
                text: 'Дачник',

              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileContent('Водитель', Icons.directions_car),
          _buildProfileContent('Рыбак', Icons.water_damage),
          _buildProfileContent('Дачник', Icons.agriculture),
        ],
      ),
      backgroundColor: const Color(0xFF469EE0),
    );
  }
  Widget _buildProfileContent(String profile, IconData icon) {
    List<Widget> content = [];

    if (profile == 'Водитель') {
      content = [
        _infoCard('Дорожные условия', 'Информация о состоянии дорог, пробки, дорожные работы'),
        _infoCard('Погода на маршруте', 'Температура, осадки, видимость, скорость ветра'),
        _infoCard('Индекс дорожной безопасности', 'Наличие гололеда, снегопад, дождь'),
        _infoCard('Прогноз на поездку', 'Условия в точках отправления и назначения'),
        _infoCard('Уровень загрязнения воздуха', 'Важно для длительных поездок'),
      ];
    } else if (profile == 'Дачник') {
      content = [
        _infoCard('Температура', 'Текущая и прогноз на несколько дней'),
        _infoCard('Осадки', 'Дождь, снег, вероятность их выпадения'),
        _infoCard('Влажность', 'Полезна для садоводов и огородников'),
        _infoCard('Солнечные часы', 'Для планирования времени на улице'),
        _infoCard('Скорость ветра', 'Важна для растительности и дачных работ'),
        _infoCard('Прогноз для растений', 'Рекомендации по поливу и защите от мороза'),
      ];
    } else if (profile == 'Рыбак') {
      content = [
        _infoCard('Температура воды', 'Важна для рыбной ловли'),
        _infoCard('Лунное освещение', 'Учитывается влияние луны на активность рыбы'),
        _infoCard('Скорость и направление ветра', 'Влияет на поклевку и условия на воде'),
        _infoCard('Осадки и давление', 'Могут повлиять на поведение рыбы'),
        _infoCard('Прогноз для рыбалки', 'Лучшие дни и время для ловли'),
        _infoCard('Уровень воды', 'Важен для рыболовства в некоторых водоёмах'),
      ];
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        Icon(icon, size: 100, color: Colors.white),
        const SizedBox(height: 10),
        Text('Профиль: $profile', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: content,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(String title, String description) {
    return Container(
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
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(description,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }

}
