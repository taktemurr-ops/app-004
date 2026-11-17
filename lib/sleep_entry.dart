import 'localized_integer.dart';
class SleepEntry {
  const SleepEntry({required this.id, required this.minutes, required this.endedAt});
  final String id;
  final int minutes;
  final DateTime endedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'minutes': minutes,
    'endedAt': endedAt.toIso8601String(),
  };

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    final minutes = json['minutes'];
    if (minutes is! int || minutes < 1 || minutes > 1440) {
      throw const FormatException('Invalid sleep duration');
    }
    return SleepEntry(
      id: json['id'] as String,
      minutes: minutes,
      endedAt: DateTime.parse(json['endedAt'] as String),
    );
  }
}

int? parseSleepDuration(String hoursText, String minutesText) {
  final hours = parseLocalizedWholeNumber(hoursText, min: 0, max: 24);
  final minutes = parseLocalizedWholeNumber(minutesText, min: 0, max: 59);
  if (hours == null || minutes == null || hours < 0 || minutes < 0 || minutes > 59) return null;
  final total = hours * 60 + minutes;
  return total >= 1 && total <= 1440 ? total : null;
}
