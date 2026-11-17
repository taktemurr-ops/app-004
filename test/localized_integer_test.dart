import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_universe/localized_integer.dart';

void main() {
  test('accepts international decimal digit systems', () {
    expect(parseLocalizedWholeNumber('٢٥٠', min: 1, max: 2000), 250);
    expect(parseLocalizedWholeNumber('۲۵۰', min: 1, max: 2000), 250);
    expect(parseLocalizedWholeNumber('२५०', min: 1, max: 2000), 250);
    expect(parseLocalizedWholeNumber('２５０', min: 1, max: 2000), 250);
  });
  test('rejects separators, signs, overflow and out-of-range values', () {
    for (final value in ['-1', '+2', '1.5', '1,000', 'abc', '999999999999999999999999999999999']) {
      expect(parseLocalizedWholeNumber(value, min: 1, max: 2000), isNull);
    }
    expect(parseLocalizedWholeNumber('0', min: 1, max: 2000), isNull);
    expect(parseLocalizedWholeNumber('2001', min: 1, max: 2000), isNull);
  });
}
