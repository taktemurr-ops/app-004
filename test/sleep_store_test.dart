import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_universe/sleep_entry.dart';
import 'package:sleep_universe/sleep_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('duration validation', () {
    expect(parseSleepDuration('8', '30'), 510);
    expect(parseSleepDuration('0', '0'), isNull);
    expect(parseSleepDuration('24', '0'), 1440);
    expect(parseSleepDuration('24', '1'), isNull);
    expect(parseSleepDuration('2', '60'), isNull);
    expect(parseSleepDuration('-1', '10'), isNull);
  });

  test('serialization round trip', () {
    final original = SleepEntry(id: '1', minutes: 480, endedAt: DateTime.utc(2026, 11, 17));
    final decoded = SleepEntry.fromJson(original.toJson());
    expect(decoded.minutes, 480);
    expect(decoded.endedAt, original.endedAt);
  });

  test('persist and delete entries', () async {
    final store = SleepStore();
    await store.add(480);
    final restored = SleepStore();
    await restored.load();
    expect(restored.entries.single.minutes, 480);
    await restored.remove(restored.entries.single.id);
    final empty = SleepStore();
    await empty.load();
    expect(empty.entries, isEmpty);
  });

  test('malformed data does not partially restore', () async {
    SharedPreferences.setMockInitialValues({SleepStore.storageKey: '[{"id":"invalid"}]'});
    final store = SleepStore();
    await store.load();
    expect(store.entries, isEmpty);
  });
}
