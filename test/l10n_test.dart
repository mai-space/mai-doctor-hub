import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';

void main() {
  test('system language picks German or English, otherwise English', () {
    expect(AppLocale.resolve(const [Locale('de', 'AT')]), AppLocale.german);
    expect(AppLocale.resolve(const [Locale('en', 'US')]), AppLocale.english);
    expect(AppLocale.resolve(const [Locale('fr'), Locale('de')]), AppLocale.german);
    expect(AppLocale.resolve(const [Locale('fr')]), AppLocale.english);
    expect(AppLocale.resolve(const []), AppLocale.english);
  });
}
