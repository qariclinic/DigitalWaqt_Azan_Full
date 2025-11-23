import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:adhan/adhan.dart';  // For prayer times
import '../utils/constants.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  Future<void> scheduleAdhan(PrayerTimes prayers, String prayerName) async {
    final now = tz.TZDateTime.now(tz.local);
    final prayerTime = prayers.timeForPrayer(prayerName as Prayer.prayers);  // e.g., Prayer.fajr
    if (prayerTime.isAfter(now)) {
      await _notifications.zonedSchedule(
        prayerName.hashCode,
        'آذان کا وقت: $prayerName',
        'اللہ اکبر... (Adhan starting)',
        tz.TZDateTime.from(prayerTime, tz.local),
        const NotificationDetails(android: AndroidNotificationDetails('adhan', 'Adhan')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,  // Daily repeat
      );
    }
  }
}
