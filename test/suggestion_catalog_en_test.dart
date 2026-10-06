import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/repositories/suggestion_repository.dart';
import 'package:mai_doctor_hub/data/suggestion_catalog.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/theme/icon_mappings.dart';

void main() {
  tearDown(() => AppLocale.update(AppLocale.german));

  test('English and German catalogs are paired one-to-one', () {
    for (final (de, en) in [
      (bodyRegionCatalog, bodyRegionCatalogEn),
      (specialtyCatalog, specialtyCatalogEn),
      (symptomCatalog, symptomCatalogEn),
      (vaccineCatalog, vaccineCatalogEn),
    ]) {
      expect(en, hasLength(de.length));
      expect(en.toSet(), hasLength(en.length), reason: 'no duplicates');
    }
  });

  test('German device gets German catalogs', () {
    expect(SuggestionCatalog.specialties, same(specialtyCatalog));
    expect(SuggestionCatalog.bodyRegions, contains('Kopf'));
  });

  test('English device gets English catalogs and icons', () {
    AppLocale.update(AppLocale.english);

    expect(SuggestionCatalog.bodyRegions, same(bodyRegionCatalogEn));
    expect(SuggestionCatalog.bodyRegions, contains('Head'));
    expect(SuggestionCatalog.specialties,
        contains('General practice (Primary care)'));
    expect(SuggestionCatalog.symptoms, contains('Headache'));
    expect(SuggestionCatalog.vaccines, contains('Influenza (Flu)'));
    expect(
      SuggestionRepository.filter(SuggestionCatalog.specialties, 'ent'),
      contains('Ear, Nose and Throat (ENT)'),
    );

    expect(IconMappings.specialtyIcon('Cardiology'), Icons.favorite_outlined);
    expect(
      IconMappings.specialtyIcon('Cardiology'),
      IconMappings.specialtyIcon('Kardiologie'),
    );
    expect(IconMappings.bodyRegionIcon('Eye'), Icons.visibility_outlined);
    expect(
      IconMappings.specialtyIcon('Unknown specialty'),
      Icons.medical_services_outlined,
    );
    expect(IconMappings.bodyRegionIcon('Unknown'), Icons.accessibility);
  });

  test('default reminder texts follow the app language', () {
    AppLocale.update(AppLocale.english);
    expect(AppLocale.strings.catalogReminderMorningTitle, 'Morning check-in');
    AppLocale.update(AppLocale.german);
    expect(AppLocale.strings.catalogReminderMorningTitle, 'Morgen-Check-in');
  });
}
