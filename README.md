# APP-004 — Sleep Universe

Private, offline-first sleep duration journal for Flutter Android and iOS.

## Initial implemented source
- Enter hours and minutes (validated 1–1440 total minutes).
- View and delete timestamped sleep records.
- Persist entries locally using shared_preferences; malformed JSON cannot partially replace memory.
- ARB files: English (en), Turkish (tr), Arabic (ar).
- GitHub Actions workflow and unit tests committed.

## Local verification
```sh
flutter create --platforms=android,ios .
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

Native Android/iOS scaffolding is not committed. Tests, CI and device builds are not yet verified.

## Privacy and planned work
Data is local and **not encrypted**. No login, telemetry or network sync is implemented. Future: locale-aware Unicode numeric input, sleep charts, reminders, export/delete-all, accessibility audit, consent, region-specific privacy disclosures, translated store screenshots, and optional premium features.

Not a medical device and not a diagnostic sleep assessment.
