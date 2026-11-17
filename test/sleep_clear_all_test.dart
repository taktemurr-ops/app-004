import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_universe/sleep_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('clearAll deletes persisted data and memory', () async {
    final store = SleepStore();
    await store.add(480);
    expect(store.entries, isNotEmpty);
    await store.clearAll();
    expect(store.entries, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey(SleepStore.storageKey), isFalse);
    final reloaded = SleepStore();
    await reloaded.load();
    expect(reloaded.entries, isEmpty);
  });
}
