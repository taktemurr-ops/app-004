import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_universe/privacy_export.dart';
import 'package:sleep_universe/sleep_entry.dart';

void main() {
  test('export round-trips duration, UTC timestamp and Unicode identifier', () {
    final at = DateTime.utc(2026, 11, 17, 6, 30);
    final entry = SleepEntry(id: 'uyku-١-🌙', minutes: 480, endedAt: at);
    final payload = jsonDecode(exportSleepEntries([entry])) as Map<String, dynamic>;
    final records = payload['sleepEntries'] as List<dynamic>;
    expect(records.length, 1);
    final restored = SleepEntry.fromJson(Map<String, dynamic>.from(records.single as Map));
    expect(restored.id, entry.id);
    expect(restored.minutes, 480);
    expect(restored.endedAt, at);
  });

  test('export uses a minimal versioned offline JSON schema', () {
    final payload = jsonDecode(exportSleepEntries([])) as Map<String, dynamic>;
    expect(payload.keys.toSet(), {'schemaVersion', 'exportedAtUtc', 'sleepEntries'});
    expect(payload['schemaVersion'], 1);
    expect(payload['sleepEntries'], isEmpty);
  });
}
