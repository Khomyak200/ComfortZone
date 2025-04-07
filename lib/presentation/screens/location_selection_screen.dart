import 'package:flutter/material.dart';

class LocationSelectionScreen extends StatelessWidget {
  const LocationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> favorites = ['Минск', 'Вильнюс'];
    final String currentLocation = 'Текущее местоположение';
    final List<String> recentLocations = ['Москва', 'Берлин', 'Париж'];

    return Scaffold(
      backgroundColor: const Color(0xFF469EE0),
      appBar: AppBar(
        title: const Text('Выбор локации',style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF469EE0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '⭐ Избранные',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ...favorites.map((city) => _buildLocationTile(city, Icons.star, context)),

          const SizedBox(height: 24),
          const Text(
            '📍 Текущее местоположение',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          _buildLocationTile(currentLocation, Icons.gps_fixed, context),

          const SizedBox(height: 24),
          const Text(
            '🕓 Последние местоположения',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ...recentLocations.map((city) => _buildLocationTile(city, Icons.history, context)),
        ],
      ),
    );
  }

  Widget _buildLocationTile(String name, IconData icon, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        onTap: () {
          Navigator.pop(context, name);
        },
      ),
    );
  }
}
