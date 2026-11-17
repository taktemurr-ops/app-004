import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sleep_entry.dart';

class SleepStore extends ChangeNotifier {
  static const storageKey = 'sleep_entries_v1';
  final List<SleepEntry> _entries = [];
  List<SleepEntry> get entries => List.unmodifiable(_entries);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null) return;
    try {
      final restored = (jsonDecode(raw) as List<dynamic>)
          .map((item) => SleepEntry.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList()
        ..sort((a, b) => b.endedAt.compareTo(a.endedAt));
      _entries
        ..clear()
        ..addAll(restored);
      notifyListeners();
    } catch (_) {
      // Preserve malformed stored data for recovery.
    }
  }

  Future<void> add(int minutes) async {
    if (minutes < 1 || minutes > 1440) throw ArgumentError.value(minutes, 'minutes');
    final now = DateTime.now();
    _entries.insert(0, SleepEntry(
      id: '${now.microsecondsSinceEpoch}-${_entries.length}',
      minutes: minutes,
      endedAt: now,
    ));
    notifyListeners();
    await _persist();
  }

  Future<void> remove(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setString(storageKey, jsonEncode(_entries.map((e) => e.toJson()).toList()));
    if (!ok) throw StateError('Could not persist sleep data');
  }
}
