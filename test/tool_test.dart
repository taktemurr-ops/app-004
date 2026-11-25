import 'package:flutter_test/flutter_test.dart';
import 'package:uyg_uyku_gunlugu/uyg_uyku_gunlugu.dart';

void main() {
  test('33 dilde ad ve açıklama, doğru kimlik', () {
    expect(uykuGunluguTool.id, uykuGunluguId);
    expect(uykuGunluguTool.title.length, 33);
    expect(uykuGunluguTool.tagline.length, 33);
  });
}
