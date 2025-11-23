import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';

class ApiService {
  static const String baseUrl = 'http://api.aladhan.com/v1';

  Future<PrayerTime> getPrayerTimes(double lat, double lon) async {
    final response = await http.get(Uri.parse('$baseUrl/timingsByAddress?latitude=$lat&longitude=$lon&method=5'));  // Method 5: Umm Al-Qura
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final times = data['timings'];
      final hijri = data['date']['hijri'];

      bool isRamadan = hijri['month']['number'] == 9;
      bool isEidFitr = hijri['month']['number'] == 10 && hijri['day'] == 1;
      bool isEidAdha = hijri['month']['number'] == 12 && hijri['day'] == 10;

      return PrayerTime(
        fajr: times['Fajr'],
        dhuhr: times['Dhuhr'],
        asr: times['Asr'],
        maghrib: times['Maghrib'],
        isha: times['Isha'],
        hijriDate: HijriDate(
          day: int.parse(hijri['day']),
          month: hijri['month']['number'],
          year: int.parse(hijri['year']),
          monthName: hijri['month']['en'],
        ),
        isRamadan: isRamadan,
        isEidFitr: isEidFitr,
        isEidAdha: isEidAdha,
      );
    }
    throw Exception('Failed to load prayer times');
  }

  // Gregorian to Hijri
  Future<HijriDate> gToH(String gregDate) async {  // e.g., "23-11-2025"
    final response = await http.get(Uri.parse('$baseUrl/gToH?date=$gregDate'));
    if (response.statusCode == 200) {
      final hijri = json.decode(response.body)['data']['hijri'];
      return HijriDate(
        day: int.parse(hijri['day']),
        month: hijri['month']['number'],
        year: int.parse(hijri['year']),
        monthName: hijri['month']['en'],
      );
    }
    throw Exception('Conversion failed');
  }
}
