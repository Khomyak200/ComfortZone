import 'package:comfort_zone/data/models/hour_model.dart';
import 'package:comfort_zone/data/models/warning_info_item_model.dart';
import 'package:comfort_zone/state/weather/weather_view_model.dart';
import 'package:flutter/material.dart';
import 'package:comfort_zone/presentation/screens/profiles_screen.dart';
import 'package:comfort_zone/presentation/screens/settings_screen.dart';
import 'package:comfort_zone/presentation/screens/location_selection_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:comfort_zone/presentation/widgets/sunrise.dart';
import 'package:comfort_zone/presentation/widgets/humidity_widget.dart';
import 'package:comfort_zone/presentation/widgets/rainfall.dart';
import 'package:comfort_zone/presentation/widgets/uv_index.dart';
import 'package:comfort_zone/presentation/widgets/wind_info_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<WarningItem> _notifications = [];
  late WeatherViewModel _weatherViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<WeatherViewModel>(context, listen: false);
      if (!vm.isDataLoaded) vm.fetchWeather("Minsk,by", 10, "ru");
    });

  }
  bool get hasThreats {
    return _notifications.any((notification) => notification.level == "red");
  }

  bool get hasDangers{
    return _notifications.any((notification) => notification.level == "orange");
  }

  bool get hasWarnings {
    return _notifications.any((notification) => notification.level == "yellow");
  }

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

    return Consumer<WeatherViewModel>(
      builder: (context, vm, _) {
        if (!vm.isDataLoaded) return Center(child: CircularProgressIndicator());
        if (vm.error != null) return Center(child: Text(vm.error!));
        _notifications = _weatherViewModel.stormWarning!.items;
        final List<Widget> _screens = [
          SwipeWrapper(child: HomeScreenContent(weatherViewModel: _weatherViewModel,)),
          const ProfilesScreen(),
          const SettingsScreen(),
        ];

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
  final List<WarningItem> notifications;

  const _NotificationsPanel({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {

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
                        color: notification.level == "red" ? Colors.redAccent : (notification.level == "orange"? Colors.orangeAccent : Colors.yellowAccent), // Red for threat, Yellow for warning
                      ),
                      title: Text(
                        notification.description,
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
  final WeatherViewModel weatherViewModel;
  HomeScreenContent({super.key, required this.weatherViewModel});

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
              children: [
                Text(
                  '${weatherViewModel.weatherInfo?.tempC.toString() as String} ',
                  style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Image.network('https:${weatherViewModel.weatherInfo?.conditionIcon as String}',
                              width:  60,
                              height: 60,),
              ],
            ),
            Text(
              weatherViewModel.weatherInfo?.conditionText as String,
              style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold,),
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
            Text('${weatherViewModel.forecast?[0].maxtempC}° / ${weatherViewModel.forecast?[0].mintempC}°  Ощущается как ${weatherViewModel.weatherInfo?.feelsLikeC}°', style: TextStyle(color: Colors.white60,fontSize: 18)),
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
                  : (parentState?.hasDangers ?? false)
                  ? Colors.orange
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
    const int count = 12;
    DateTime dt = DateTime.now();

    List<HourInfo> hourData = [];
    int itemsCount = 0;
    bool isNextDay = false;
    for (int i = 0; itemsCount < 12; i++){
      if (!isNextDay && weatherViewModel.forecast![0].hour[i].date.hour > dt.hour) {
        hourData.add(weatherViewModel.forecast![0].hour[i]);
        itemsCount++;
      } else if (isNextDay){
        hourData.add(weatherViewModel.forecast![1].hour[i]);
        itemsCount++;
      }

      if (i == 23) {
        isNextDay = true;
        i = 0;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            count,
                (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _hourBlock('${convertDate(hourData[index].date.hour)}:00', 'https:${hourData[index].conditionIcon}', 
                '${hourData[index].tempC}°', 
                '${hourData[index].chanceOfRain > hourData[index].chanceOfSnow ? hourData[index].chanceOfRain : hourData[index].chanceOfRain}%'),
            ),
          ),
        ),
      ),
    );
  }


  Widget _hourBlock(String time, String icon, String temp, String rain) {
    return Column(
      children: [
        Text(time, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        Image.network(icon,
          width: 32,),
        const SizedBox(height: 4),
        Text(temp, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        Text(rain, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    return DateTime(2023, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
  }

  Widget _buildSunsetCard() {
    String sunriseTime = '06:30'; // Пример времени восхода
    String sunsetTime = '18:45'; // Пример времени заката
    DateTime sunrise = _parseTime(sunriseTime);
    DateTime sunset = _parseTime(sunsetTime);

    String hours;
    String minutes;
    String title;
    if (sunset.hour<12)
      hours = '0'+sunset.hour.toString();
    else
      hours = sunset.hour.toString();

    if (sunset.minute<10)
      minutes ='0'+sunset.minute.toString();
    else
      minutes =sunset.minute.toString();

    title = hours+':'+minutes;


    return Container(
      width: double.infinity,
      height: 600,
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Добавляем Row для иконки и текста
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.wb_sunny, // Используем иконку солнца
                color: Colors.white,
                size: 30, // Размер иконки
              ),
              const SizedBox(width: 8), // Отступ между иконкой и текстом
              const Text(
                'Восход солнца',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),

          // Затем добавляем график и текст заката
          Expanded(
            child: SunSineChart(
              sunrise: sunrise,
              sunset: sunset,
              size: 800, // Или любой необходимый размер
            ),
          ),
          Center(
            child: Text(
              'Закат в '+title  ,
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyForecast() {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 10,
        itemBuilder: (context, index) {
          return _dayForecastRow(
            '${convertDate(weatherViewModel.forecast?[index].date.day)}.${convertDate(weatherViewModel.forecast?[index].date.month)}',
            'https:${weatherViewModel.forecast?[index].hour[11].conditionIcon}',
            'https:${weatherViewModel.forecast?[index].hour[0].conditionIcon}',
            '${weatherViewModel.forecast?[index].hour[11].tempC}',
            '${weatherViewModel.forecast?[index].hour[0].tempC}',
            '${weatherViewModel.forecast![index].dailyChanceOfRain > weatherViewModel.forecast![index].dailyChanceOfSnow ? weatherViewModel.forecast![index].dailyChanceOfRain : weatherViewModel.forecast![index].dailyChanceOfSnow}',
          );
        },
      ),
    );
  }

  String convertDate(int? date){
    if (date == null) return '';
    if (date < 10) {
      return '0$date';
    }
    return date.toString();
  }


  Widget _dayForecastRow(String day, String icon, String iconNight, String high, String low, String rain) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(day, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Image.network(icon,
                  width: 32,),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Image.network(iconNight,
                  width: 32,),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                children: [
                  Text('$high / $low', style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(rain, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
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
                context,
              );
            }).toList(),
          ),
        );
      },
    );
  }


  Widget _infoButton(String label, IconData icon, double size, BuildContext context) {
    // wind
    int windSpeed = 22;
    int windGusts = 44;
    int direction = 320;

    // uv_index
    int uvIndex = 3;

    // humidity data
    int humidity = 65; // Пример значения влажности
    double dewPoint = 14.5; // Пример значения точки росы

    // sunrise
    String sunriseTime = '06:30'; // Пример времени восхода
    String sunsetTime = '18:45'; // Пример времени заката
    DateTime sunrise = _parseTime(sunriseTime);
    DateTime sunset = _parseTime(sunsetTime);

    double illuminationPercentage = 0.11;

    Widget content;

    // rainfall
    int sizeRainfall=3;

    // Условие для замены на компас, если метка - "Ветер"
    if (label == 'Ветер') {
      content = WindInfoWidget(
        windSpeed: windSpeed,
        windGusts: windGusts,
        direction: direction,
        size: size,
      );
    } else if (label == 'УФ-индекс') {
      content = UVIndexWidget( // Используйте новый виджет для УФ-индекса
        uvIndex: uvIndex,
        size: size,
      );
    }else if (label == 'Влажность') {
      content = HumidityWidget(
        humidity: humidity,
        dewPoint: dewPoint,
        size: size,
      );
    }else if (label == 'Осадки') {
      content = RainfallWidget(
        sizeRainfall: sizeRainfall,
        size: size,
      );
    }
    else{
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => _showBottomSheet(context, label),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Основной контент
            Center(child: content),
            // Иконка и текст в левом верхнем углу
            Positioned(
              left: 8,
              top: 8,
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 20), // Иконка в левом верхнем углу
                  const SizedBox(width: 4), // Пробел между иконкой и текстом
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 12), // Лейбл в левом верхнем углу
                  ),
                ],
              ),
            ),
          ],
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
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Облачность: ', style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('${weatherViewModel.weatherInfo?.cloud}%', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Порывы ветра:', style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('до ${weatherViewModel.weatherInfo?.gustKph} км/ч', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Давление:', style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('${weatherViewModel.weatherInfo?.pressureMb} гПа', style: TextStyle(color: Colors.white, fontSize: 20)),
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
                const SizedBox(height: 8),
                ComparisonBarWidget(
                  value1: 5.4,
                  value2: 2.2,
                  label1: 'Сегодня',
                  label2: 'Завтра',
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
                const SizedBox(height: 8),
                ComparisonBarWidget(
                  value1: 5.4,
                  value2: 2.2,
                  label1: 'Сегодня',
                  label2: 'Завтра',
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
                const SizedBox(height: 8),
                ComparisonBarWidget(
                  value1: 5.4,
                  value2: 2.2,
                  label1: 'Сегодня',
                  label2: 'Завтра',
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
                const SizedBox(height: 8),
                ComparisonBarWidget(
                  value1: 5.4,
                  value2: 2.2,
                  label1: 'Сегодня',
                  label2: 'Завтра',
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
        const SizedBox(height: 8),
        Column(
          children: List.generate(levels.length, (index) {
            final level = levels[index];
            final color = level['color'] as Color;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$index',
                      style: TextStyle(
                        color: (index == 0 || index == 1 || index == 7) ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level['label'] as String,
                          style: const TextStyle(color: Colors.white),
                        ),

                      ],
                    ),
                  ),
                  Text(
                    level['speed'] as String,
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}


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
          children: [Text(label1, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 18 )), Text(value1.toString(), style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 18,  fontWeight: FontWeight.bold, ))],
        ),
        LinearProgressIndicator(
          value: value1 / max,
          minHeight: 8,
          color: Color(0xFF145D91),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label2, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 18 )), Text(value2.toString(), style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 18,  fontWeight: FontWeight.bold, ))],
        ),
        LinearProgressIndicator(
          value: value2 / max,
          minHeight: 8,
          color: Color(0xFF145D91),
        ),
      ],
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

