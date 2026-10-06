import 'package:flutter/material.dart';

import '../data/suggestion_catalog.dart';

/// Icon mappings for medical specialties, body regions, and other clinical domains.
/// Uses Material 3 outlined icons for consistency with app theme.
abstract final class IconMappings {
  /// Maps doctor specialty names (German or English catalog terms) to
  /// appropriate Material icons.
  static IconData specialtyIcon(String specialty) {
    return _specialtyIcons[specialty] ?? Icons.medical_services_outlined;
  }

  /// Maps body region names (German or English catalog terms) to
  /// appropriate Material icons.
  static IconData bodyRegionIcon(String region) {
    return _bodyRegionIcons[region] ?? Icons.accessibility;
  }

  // English names are derived from the paired catalog lists (entry i in the
  // German list ↔ entry i in the English list), so they cannot drift.
  static final Map<String, IconData> _specialtyIcons = _withEnglish(
    _specialtyMap,
    specialtyCatalog,
    specialtyCatalogEn,
  );

  static final Map<String, IconData> _bodyRegionIcons = _withEnglish(
    _bodyRegionMap,
    bodyRegionCatalog,
    bodyRegionCatalogEn,
  );

  static Map<String, IconData> _withEnglish(
    Map<String, IconData> german,
    List<String> germanNames,
    List<String> englishNames,
  ) {
    assert(germanNames.length == englishNames.length);
    return {
      ...german,
      for (var i = 0; i < germanNames.length; i++)
        englishNames[i]: ?german[germanNames[i]],
    };
  }

  static const Map<String, IconData> _specialtyMap = {
    // Primary care
    'Allgemeinmedizin (Hausarzt)': Icons.medical_services_outlined,
    'Innere Medizin (hausärztlich)': Icons.medical_services_outlined,
    'Kinder- und Jugendmedizin': Icons.accessibility,

    // Internal medicine specialties
    'Innere Medizin': Icons.medical_services_outlined,
    'Kardiologie': Icons.favorite_outlined,
    'Gastroenterologie': Icons.restaurant_outlined,
    'Pneumologie (Lungenheilkunde)': Icons.air_outlined,
    'Nephrologie (Nierenheilkunde)': Icons.water_drop_outlined,
    'Endokrinologie und Diabetologie': Icons.biotech_outlined,
    'Diabetologie': Icons.bloodtype_outlined,
    'Hämatologie und Onkologie': Icons.science_outlined,
    'Rheumatologie': Icons.healing_outlined,
    'Angiologie (Gefäßmedizin)': Icons.favorite_outlined,
    'Infektiologie': Icons.coronavirus_outlined,
    'Geriatrie': Icons.accessibility,

    // Surgical specialties
    'Allgemeinchirurgie': Icons.healing_outlined,
    'Viszeralchirurgie': Icons.healing_outlined,
    'Gefäßchirurgie': Icons.favorite_outlined,
    'Herzchirurgie': Icons.favorite_outlined,
    'Thoraxchirurgie': Icons.air_outlined,
    'Kinderchirurgie': Icons.accessibility,
    'Plastische und Ästhetische Chirurgie': Icons.face_outlined,
    'Handchirurgie': Icons.pan_tool_outlined,
    'Neurochirurgie': Icons.psychology_outlined,
    'Orthopädie und Unfallchirurgie': Icons.healing_outlined,
    'Orthopädie': Icons.healing_outlined,
    'Unfallchirurgie': Icons.healing_outlined,
    'Mund-Kiefer-Gesichtschirurgie': Icons.mood_outlined,
    'Urologie': Icons.wc_outlined,
    'Frauenheilkunde und Geburtshilfe (Gynäkologie)': Icons.favorite_outlined,

    // Sensory and skin
    'Augenheilkunde': Icons.visibility_outlined,
    'Hals-Nasen-Ohrenheilkunde (HNO)': Icons.hearing_outlined,
    'Phoniatrie und Pädaudiologie': Icons.hearing_outlined,
    'Dermatologie (Haut- und Geschlechtskrankheiten)': Icons.spa_outlined,
    'Allergologie': Icons.local_florist_outlined,

    // Neurology and psychiatry
    'Neurologie': Icons.psychology_outlined,
    'Psychiatrie und Psychotherapie': Icons.psychology_outlined,
    'Kinder- und Jugendpsychiatrie': Icons.psychology_outlined,
    'Psychosomatische Medizin': Icons.psychology_outlined,
    'Psychotherapie': Icons.psychology_outlined,
    'Psychologische Psychotherapie': Icons.psychology_outlined,

    // Diagnostics
    'Radiologie': Icons.image_search_outlined,
    'Nuklearmedizin': Icons.science_outlined,
    'Laboratoriumsmedizin': Icons.science_outlined,
    'Pathologie': Icons.science_outlined,
    'Humangenetik': Icons.biotech_outlined,

    // Other specialties
    'Anästhesiologie': Icons.medical_services_outlined,
    'Schmerzmedizin': Icons.health_and_safety_outlined,
    'Physikalische und Rehabilitative Medizin': Icons.healing_outlined,
    'Sportmedizin': Icons.healing_outlined,
    'Arbeitsmedizin': Icons.construction_outlined,
    'Palliativmedizin': Icons.medical_services_outlined,
    'Schlafmedizin': Icons.medical_services_outlined,
    'Strahlentherapie': Icons.medical_services_outlined,
    'Transfusionsmedizin': Icons.bloodtype_outlined,
    'Notfallmedizin': Icons.healing_outlined,
    'Naturheilverfahren': Icons.eco_outlined,
    'Homöopathie': Icons.eco_outlined,

    // Dentistry
    'Zahnmedizin': Icons.mood_outlined,
    'Kieferorthopädie': Icons.mood_outlined,
    'Oralchirurgie': Icons.mood_outlined,
    'Parodontologie': Icons.mood_outlined,

    // Health professions
    'Physiotherapie': Icons.healing_outlined,
    'Ergotherapie': Icons.healing_outlined,
    'Logopädie': Icons.hearing_outlined,
    'Osteopathie': Icons.healing_outlined,
    'Heilpraktiker': Icons.eco_outlined,
    'Hebamme': Icons.favorite_outlined,
    'Ernährungsberatung': Icons.restaurant_outlined,
    'Podologie': Icons.accessibility,
  };

  static const Map<String, IconData> _bodyRegionMap = {
    'Kopf': Icons.psychology_outlined,
    'Stirn': Icons.psychology_outlined,
    'Schläfe': Icons.psychology_outlined,
    'Hinterkopf': Icons.psychology_outlined,
    'Gesicht': Icons.face_outlined,
    'Auge': Icons.visibility_outlined,
    'Ohr': Icons.hearing_outlined,
    'Nase': Icons.air_outlined,
    'Mund': Icons.mood_outlined,
    'Kiefer': Icons.mood_outlined,
    'Zähne': Icons.mood_outlined,
    'Hals': Icons.air_outlined,
    'Nacken': Icons.psychology_outlined,
    'Halswirbelsäule': Icons.psychology_outlined,
    'Schulter': Icons.pan_tool_outlined,
    'Oberarm': Icons.pan_tool_outlined,
    'Ellenbogen': Icons.pan_tool_outlined,
    'Unterarm': Icons.pan_tool_outlined,
    'Handgelenk': Icons.pan_tool_outlined,
    'Hand': Icons.pan_tool_outlined,
    'Finger': Icons.pan_tool_outlined,
    'Brust': Icons.favorite_outlined,
    'Brustkorb': Icons.favorite_outlined,
    'Brustwirbelsäule': Icons.psychology_outlined,
    'Rücken': Icons.psychology_outlined,
    'Lendenwirbelsäule': Icons.psychology_outlined,
    'Bauch': Icons.restaurant_outlined,
    'Oberbauch': Icons.restaurant_outlined,
    'Unterbauch': Icons.restaurant_outlined,
    'Leiste': Icons.pan_tool_outlined,
    'Becken': Icons.accessibility,
    'Hüfte': Icons.accessibility,
    'Gesäß': Icons.accessibility,
    'Oberschenkel': Icons.accessibility,
    'Knie': Icons.accessibility,
    'Unterschenkel': Icons.accessibility,
    'Wade': Icons.accessibility,
    'Sprunggelenk': Icons.accessibility,
    'Fuß': Icons.accessibility,
    'Ferse': Icons.accessibility,
    'Fußsohle': Icons.accessibility,
    'Zehen': Icons.accessibility,
    'Haut': Icons.spa_outlined,
    'Ganzer Körper': Icons.accessibility,
  };

  /// Returns a color appropriate for medical context icons.
  /// Used to visually distinguish different types of medical items.
  static Color? iconColor(BuildContext context, {String? type}) {
    final scheme = Theme.of(context).colorScheme;
    return switch (type) {
      'doctor' => scheme.primary,
      'appointment' => scheme.secondary,
      'medication' => scheme.tertiary,
      'symptom' => scheme.outline,
      'vaccine' => scheme.primary,
      _ => null,
    };
  }
}
