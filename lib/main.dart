import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleep_universe/l10n/app_localizations.dart';
import 'sleep_entry.dart';
import 'sleep_store.dart';

void main() => runApp(const SleepUniverseApp());

class SleepUniverseApp extends StatelessWidget {
  const SleepUniverseApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5756A5)), useMaterial3: true),
    home: const SleepHome(),
  );
}

class SleepHome extends StatefulWidget {
  const SleepHome({super.key});
  @override
  State<SleepHome> createState() => _SleepHomeState();
}

class _SleepHomeState extends State<SleepHome> {
  final store = SleepStore();
  final hours = TextEditingController(text: '8');
  final minutes = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    store.addListener(_refresh);
    store.load();
  }

  void _refresh() { if (mounted) setState(() {}); }

  @override
  void dispose() {
    store.removeListener(_refresh);
    store.dispose();
    hours.dispose();
    minutes.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l) async {
    final duration = parseSleepDuration(hours.text, minutes.text);
    if (duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.invalid)));
      return;
    }
    await store.add(duration);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(title: Text(l.appTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(l.heading, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l.privacy),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: TextField(
            controller: hours,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l.hours, border: const OutlineInputBorder()),
          )),
          const SizedBox(width: 12),
          Expanded(child: TextField(
            controller: minutes,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l.minutes, border: const OutlineInputBorder()),
          )),
        ]),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: () => _save(l), icon: const Icon(Icons.bedtime), label: Text(l.save)),
        const SizedBox(height: 24),
        Text(l.history, style: Theme.of(context).textTheme.titleMedium),
        if (store.entries.isEmpty) Padding(padding: const EdgeInsets.all(12), child: Text(l.empty)),
        ...store.entries.map((entry) {
          final duration = '${entry.minutes ~/ 60}h ${entry.minutes % 60}m';
          return ListTile(
            title: Text(l.total(duration)),
            subtitle: Text(DateFormat.yMMMd(locale).add_Hm().format(entry.endedAt.toLocal())),
            trailing: IconButton(
              tooltip: l.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: () => store.remove(entry.id),
            ),
          );
        }),
      ]),
    );
  }
}
