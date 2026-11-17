/// Parses a positive whole number from ASCII, Arabic-Indic, Eastern Arabic,
/// Devanagari or full-width digits without accepting signs or separators.
/// Bounds are checked before conversion to avoid oversized input.
int? parseLocalizedWholeNumber(String input, {required int min, required int max}) {
  final text = input.trim();
  if (text.isEmpty || text.runes.length > 32 || min > max) return null;
  var value = 0;
  for (final rune in text.runes) {
    int? digit;
    for (final base in [0x30, 0x0660, 0x06F0, 0x0966, 0xFF10]) {
      if (rune >= base && rune <= base + 9) { digit = rune - base; break; }
    }
    if (digit == null) return null;
    value = value * 10 + digit;
    if (value > max) return null;
  }
  return value >= min ? value : null;
}
