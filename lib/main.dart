import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'widgets/prayer_clock.dart';
import 'services/notification_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();  // Init notifications for Adhan
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islamic Prayer Clock',
      theme: ThemeData.dark(),  // Dark mode for clock-like feel
      home: FutureBuilder<Position>(
        future: Geolocator.getCurrentPosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PrayerClockWidget(latitude: snapshot.data!.latitude, longitude: snapshot.data!.longitude);
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Footer Credit
class FooterCredit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('میڈ بائے مفتی حافظ محمد شعیب خان آلائی', style: TextStyle(fontSize: 12, color: Colors.white70)),
    );
  }
}
