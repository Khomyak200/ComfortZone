import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isCelsius = true;
  bool autoUpdate = true;
  bool onTheGoMode = false;
  bool useGeolocation = true;
  bool showWidget = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF469EE0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2592E1),
        title: const Text('Настройки', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSwitchCard(
            title: 'Единицы температуры',
            subtitle: isCelsius ? 'Цельсий (°C)' : 'Фаренгейт (°F)',
            value: isCelsius,
            onChanged: (val) => setState(() => isCelsius = val),
            toggleLabels: const ['°C', '°F'],
          ),
          _buildToggle('Автообновление', autoUpdate, (val) {
            setState(() => autoUpdate = val);
          }),
          _buildToggle('Режим "на ходу"', onTheGoMode, (val) {
            setState(() => onTheGoMode = val);
          }),
          _buildToggle('Геолокация', useGeolocation, (val) {
            setState(() => useGeolocation = val);
          }),
          _buildToggle('Виджет на экран', showWidget, (val) {
            setState(() => showWidget = val);
          }),
          _buildToggle('Уведомления', notificationsEnabled, (val) {
            setState(() => notificationsEnabled = val);
          }),
          _infoCard(
            'О приложении',
            'Версия 1.0.0\nРазработано с любовью для пользователей погоды.',
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String title, bool value, Function(bool) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SwitchListTile(
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        inactiveThumbColor: Colors.grey[300],
      ),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required List<String> toggleLabels,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
                  ]),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              inactiveThumbColor: Colors.grey[300],
            ),
          ],
        ),
      ),
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
                style:
                const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
