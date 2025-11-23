class PrayerTime {
  final String fajr, dhuhr, asr, maghrib, isha;
  final HijriDate hijriDate;
  final bool isRamadan;  // Highlight for Ramadan
  final bool isEidFitr;  // Eid al-Fitr
  final bool isEidAdha;  // Eid al-Adha

  PrayerTime({required this.fajr, required this.dhuhr, required this.asr, required this.maghrib, required this.isha,
              required this.hijriDate, required this.isRamadan, required this.isEidFitr, required this.isEidAdha});
}

class HijriDate {
  final int day, month, year;
  final String monthName;  // e.g., "Ramadan", "Shawwal"

  HijriDate({required this.day, required this.month, required this.year, required this.monthName});

  bool get isSpecialDay {
    // Highlight logic
    if (month == 9) return true;  // Ramadan
    if (month == 10 && day == 1) return true;  // Eid al-Fitr
    if (month == 12 && day == 10) return true;  // Eid al-Adha
    // Add more: e.g., Muharram 1 (Islamic New Year)
    return false;
  }
}
