import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../services/adhan_player.dart';
import '../models/prayer_time.dart';

class PrayerClockWidget extends StatefulWidget {
  final double latitude, longitude;
  const PrayerClockWidget({super.key, required this.latitude, required this.longitude});

  @override
  State<PrayerClockWidget> createState() => _PrayerClockWidgetState();
}

class _PrayerClockWidgetState extends State<PrayerClockWidget> {
  final ApiService _api = ApiService();
  final NotificationService _notif = NotificationService();
  final AdhanPlayer _player = AdhanPlayer();
  PrayerTime? _prayerData;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
    _updateTime();
  }

  Future<void> _loadPrayerTimes() async {
    _prayerData = await _api.getPrayerTimes(widget.latitude, widget.longitude);
    // Schedule notifications for all prayers
    final prayers = PrayerTimes.today(Coordinates(widget.latitude, widget.longitude), madhab: Madhab.shafi);
    _notif.scheduleAdhan(prayers, 'Fajr');
    // Repeat for other prayers...
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
    Future.delayed(Duration(seconds: 1), _updateTime);
  }

  Color _getHighlightColor() {
    if (_prayerData?.isRamadan == true) return Colors.orange;
    if (_prayerData?.isEidFitr == true || _prayerData?.isEidAdha == true) return Colors.green;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Clock
            Text(_currentTime, style: TextStyle(fontSize: 48, color: _getHighlightColor())),
            // Prayer Times
            if (_prayerData != null) ...[
              Text('فجر: ${_prayerData!.fajr}', style: TextStyle(fontSize: 18)),
              Text('ظہر: ${_prayerData!.dhuhr}', style: TextStyle(fontSize: 18)),
              Text('عصر: ${_prayerData!.asr}', style: TextStyle(fontSize: 18)),
              Text('مغرب: ${_prayerData!.maghrib}', style: TextStyle(fontSize: 18)),
              Text('عشاء: ${_prayerData!.isha}', style: TextStyle(fontSize: 18)),
              // Hijri Date with Highlight
              Container(
                padding: EdgeInsets.all(8),
                color: _prayerData!.hijriDate.isSpecialDay ? Colors.yellow : null,
                child: Text(
                  '${_prayerData!.hijriDate.day} ${_prayerData!.hijriDate.monthName} ${_prayerData!.hijriDate.year} ہجری',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              if (_prayerData!.hijriDate.isSpecialDay) Text('خاص اسلامی دن: ${_prayerData!.hijriDate.monthName}!', style: TextStyle(color: Colors.red)),
            ],
            // Adhan Button (for testing)
            ElevatedButton(onPressed: () => _player.playAdhan('fajr'), child: Text('ٹیسٹ آذان')),
          ],
        ),
      ),
    );
  }
}
