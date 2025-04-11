import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  _ProfilesScreenState createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LatLng? _startLocation;
  LatLng? _endLocation;
  String _startLocationName = '';
  String _endLocationName = '';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _requestPermissions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  final Set<Marker> _markers = {};
  late GoogleMapController _mapController;
  final List<LatLng> _markerPositions = [
    LatLng(37.7749, -122.4194), // San Francisco
    LatLng(34.0522, -118.2437), // Los Angeles
  ];
  Future<void> _requestPermissions() async {
    PermissionStatus locationStatus = await Permission.location.request();

    if (locationStatus.isGranted) {
      print("Разрешения на геолокацию и интернет получены!");
    } else {
      print("Не все разрешения были предоставлены.");
    }
  }
  Future<String> _getLocationName(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    return "${placemark.locality}, ${placemark.country}";
  }

  Future<void> _selectLocation(bool isStartLocation) async {
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );

    if (result != null) {
      setState(() {
        if (isStartLocation) {
          _startLocation = result;
          _getLocationName(result).then((value) {
            setState(() {
              _startLocationName = value;
            });
          });
        } else {
          _endLocation = result;
          _getLocationName(result).then((value) {
            setState(() {
              _endLocationName = value;
            });
          });
        }
      });
    }
  }
  Widget _buildGoogleMap() {
    return Container(
      height: 300,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _addMarkers();
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // San Francisco as default location
          zoom: 10,
        ),
        markers: _markers,
      ),
    );
  }
  void _addMarkers() {
    for (int i = 0; i < _markerPositions.length; i++) {
      final marker = Marker(
        markerId: MarkerId('marker_$i'),
        position: _markerPositions[i],
        infoWindow: InfoWindow(
          title: 'Marker $i',
          snippet: 'This is a sample marker',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
      setState(() {
        _markers.add(marker);
      });
    }
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
        SingleChildScrollView(
          child:Column (
            children: [
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
                    children: [Align(
                      alignment: Alignment.centerLeft,
                      child: Text('О угрозах при вождении',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                    ),

                      const SizedBox(height: 6),
                      Text('',
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
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
                    children: [Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Прогноз на пути',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                    ),

                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _selectLocation(true),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(_startLocationName.isEmpty ? 'Выберите отправную точку' : _startLocationName,
                                  style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),

                      // Поле для выбора конечной локации
                      GestureDetector(
                        onTap: () => _selectLocation(false),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(_endLocationName.isEmpty ? 'Выберите пункт назначения' : _endLocationName,
                                  style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      _buildGoogleMap(),
                      // Кнопка для получения прогноза
                      ElevatedButton(
                        onPressed: () {
                          if (_startLocation != null && _endLocation != null) {
                            // Здесь нужно сделать запрос на сервер с выбранными локациями
                            print("Запрос прогноза с $_startLocationName до $_endLocationName");
                          }
                        },
                        child: Text('Получить прогноз'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
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
                    children: [Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Видимость',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                    ),

                      const SizedBox(height: 6),
                      Text('Сегодня идеальная видимость, от 23 до 31 км.',
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16)),
                      const SizedBox(height: 6),
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
                        yUnit: 'км',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        )
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
          backgroundColor: Colors.transparent,

          clipData: const FlClipData.none(),
          extraLinesData: ExtraLinesData(
            verticalLines: [
              VerticalLine(
                x: _getMiddleX(),
                color: Colors.white,
                strokeWidth: 1,
                dashArray: [5, 5],
              ),
            ],
          ),
          lineTouchData: LineTouchData(enabled: false),
          minX: points.first.x,
          maxX: points.last.x,
          minY: _getMinY(),
          maxY: _getMaxY(),

          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
            ),
          ),

          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: _getYInterval(),
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: _getXInterval(),
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: points,
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blueAccent.withOpacity(0.2),
              ),
              dotData: FlDotData(show: false),
            ),

            LineChartBarData(
              spots: [
                FlSpot(_getMiddleX(), _getMinY()),
                FlSpot(_getMiddleX(), _getMiddleY()),
              ],
              isCurved: false,
              color: Colors.white,
              barWidth: 1,
              dashArray: [5, 5],
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),

          ],
        ),
      ),
    );
  }

  double _getMinY() {
    final min = points.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    return min - ((min.abs() * 0.05).clamp(0.5, 5));
  }

  double _getMaxY() {
    final max = points.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return max + ((max.abs() * 0.05).clamp(0.5, 5));
  }

  double _getXInterval() {
    if (points.length <= 4) return 1;
    return ((points.last.x - points.first.x) / 4).ceilToDouble();
  }

  double _getYInterval() {
    final minY = _getMinY();
    final maxY = _getMaxY();
    return ((maxY - minY) / 4).ceilToDouble();
  }
  double _getMiddleX() {
    if (points.isEmpty) return 0;
    int middleIndex = points.length.isOdd
        ? (points.length ~/ 2)
        : (points.length ~/ 2) - 1;
    return points[middleIndex].x;
  }
  double _getMiddleY() {
    if (points.isEmpty) return 0;
    int middleIndex = points.length.isOdd
        ? (points.length ~/ 2)
        : (points.length ~/ 2) - 1;
    return points[middleIndex].y;
  }

}
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Выберите местоположение"),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Центр карты (например, Сан-Франциско)
          zoom: 12,
        ),
        onTap: (LatLng position) {
          Navigator.pop(context, position); // Передаем выбранную позицию назад
        },
        markers: Set<Marker>.from([]),
        onMapCreated: (GoogleMapController controller) {
          // Действия при создании карты
        },
      ),
    );
  }
}
