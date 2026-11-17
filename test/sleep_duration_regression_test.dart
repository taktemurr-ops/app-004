import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_universe/sleep_entry.dart';

void main() {
  test('sleep duration enforces minute bounds', () {
    expect(parseSleepDuration('8', '30'), 510);
    expect(parseSleepDuration('0', '1'), 1);
    expect(parseSleepDuration('24', '0'), 1440);
    expect(parseSleepDuration('0', '0'), isNull);
    expect(parseSleepDuration('24', '1'), isNull);
    expect(parseSleepDuration('2', '60'), isNull);
    expect(parseSleepDuration('-1', '30'), isNull);
    expect(parseSleepDuration('x', '30'), isNull);
  });

  test('sleep entry roundtrips with its timestamp', () {
    final entry = SleepEntry(id: 'one', minutes: 480, endedAt: DateTime.utc(2026, 11, 17));
    final restored = SleepEntry.fromJson(entry.toJson());
    expect(restored.id, entry.id);
    expect(restored.minutes, 480);
    expect(restored.endedAt, entry.endedAt);
    expect(() => SleepEntry.fromJson({...entry.toJson(), 'minutes': 0}), throwsFormatException);
  });
}
