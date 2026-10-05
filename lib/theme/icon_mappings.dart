import 'package:flutter/material.dart';

/// Icon mappings for medical specialties, body regions, and other clinical domains.
/// Uses Material 3 outlined icons for consistency with app theme.
abstract final class IconMappings {
  /// Maps doctor specialty names (German) to appropriate Material icons.
  static IconData specialtyIcon(String specialty) {
    return _specialtyMap[specialty] ?? Icons.medical_services_outlined;
  }

  /// Maps body region names (German) to appropriate Material icons.
  static IconData bodyRegionIcon(String region) {
    return _bodyRegionMap[region] ?? Icons.accessibility;
  }

  static const Map<String, IconData> _specialtyMap = {
    // Primary care
    'Allgemeinmedizin (Hausarzt)': Icons.home_health_outlined,
    'Innere Medizin (hausärztlich)': Icons.home_health_outlined,
    'Kinder- und Jugendmedizin': Icons.child_care,

    // Internal medicine specialties
    'Innere Medizin': Icons.medical_services_outlined,
    'Kardiologie': Icons.favorite_outlined,
    'Gastroenterologie': Icons.fastfood_outlined,
    'Pneumologie (Lungenheilkunde)': Icons.air_outlined,
    'Nephrologie (Nierenheilkunde)': Icons.water_drop_outlined,
    'Endokrinologie und Diabetologie': Icons.biotech_outlined,
    'Diabetologie': Icons.bloodtype_outlined,
    'Hämatologie und Onkologie': Icons.science_outlined,
    'Rheumatologie': Icons.rheumatology_outlined,
    'Angiologie (Gefäßmedizin)': Icons.favorite_outlined,
    'Infektiologie': Icons.virus_outlined,
    'Geriatrie': Icons.elderly,

    // Surgical specialties
    'Allgemeinchirurgie': Icons.healing_outlined,
    'Viszeralchirurgie': Icons.healing_outlined,
    'Gefäßchirurgie': Icons.favorite_outlined,
    'Herzchirurgie': Icons.favorite_outlined,
    'Thoraxchirurgie': Icons.air_outlined,
    'Kinderchirurgie': Icons.child_care,
    'Plastische und Ästhetische Chirurgie': Icons.face_retouching_natural,
    'Handchirurgie': Icons.pan_tool_outlined,
    'Neurochirurgie': Icons.neurology_outlined,
    'Orthopädie und Unfallchirurgie': Icons.sports_medicine_outlined,
    'Orthopädie': Icons.sports_medicine_outlined,
    'Unfallchirurgie': Icons.crisis_alert_outlined,
    'Mund-Kiefer-Gesichtschirurgie': Icons.dentistry_outlined,
    'Urologie': Icons.wc_outlined,
    'Frauenheilkunde und Geburtshilfe (Gynäkologie)': Icons.pregnant_woman,

    // Sensory and skin
    'Augenheilkunde': Icons.visibility_outlined,
    'Hals-Nasen-Ohrenheilkunde (HNO)': Icons.hearing_outlined,
    'Phoniatrie und Pädaudiologie': Icons.hearing_outlined,
    'Dermatologie (Haut- und Geschlechtskrankheiten)': Icons.spa_outlined,
    'Allergologie': Icons.allergy_outlined,

    // Neurology and psychiatry
    'Neurologie': Icons.neurology_outlined,
    'Psychiatrie und Psychotherapie': Icons.psychology_outlined,
    'Kinder- und Jugendpsychiatrie': Icons.psychology_outlined,
    'Psychosomatische Medizin': Icons.psychology_outlined,
    'Psychotherapie': Icons.psychology_outlined,
    'Psychologische Psychotherapie': Icons.psychology_outlined,

    // Diagnostics
    'Radiologie': Icons.image_search_outlined,
    'Nuklearmedizin': Icons.nuclear_mobiledata,
    'Laboratoriumsmedizin': Icons.science_outlined,
    'Pathologie': Icons.lab_research_outlined,
    'Humangenetik': Icons.dna_outlined,

    // Other specialties
    'Anästhesiologie': Icons.medical_services_outlined,
    'Schmerzmedizin': Icons.health_and_safety_outlined,
    'Physikalische und Rehabilitative Medizin': Icons.sports_medicine_outlined,
    'Sportmedizin': Icons.sports_medicine_outlined,
    'Arbeitsmedizin': Icons.construction_outlined,
    'Palliativmedizin': Icons.medical_services_outlined,
    'Schlafmedizin': Icons.bedtime_outlined,
    'Strahlentherapie': Icons.radiation_outlined,
    'Transfusionsmedizin': Icons.bloodtype_outlined,
    'Notfallmedizin': Icons.emergency_outlined,
    'Naturheilverfahren': Icons.eco_outlined,
    'Homöopathie': Icons.eco_outlined,

    // Dentistry
    'Zahnmedizin': Icons.dentistry_outlined,
    'Kieferorthopädie': Icons.dentistry_outlined,
    'Oralchirurgie': Icons.dentistry_outlined,
    'Parodontologie': Icons.dentistry_outlined,

    // Health professions
    'Physiotherapie': Icons.sports_medicine_outlined,
    'Ergotherapie': Icons.sports_medicine_outlined,
    'Logopädie': Icons.hearing_outlined,
    'Osteopathie': Icons.sports_medicine_outlined,
    'Heilpraktiker': Icons.eco_outlined,
    'Hebamme': Icons.pregnant_woman,
    'Ernährungsberatung': Icons.restaurant_outlined,
    'Podologie': Icons.pedicab_outlined,
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
    'Mund': Icons.dentistry_outlined,
    'Kiefer': Icons.dentistry_outlined,
    'Zähne': Icons.dentistry_outlined,
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
    'Bauch': Icons.fastfood_outlined,
    'Oberbauch': Icons.fastfood_outlined,
    'Unterbauch': Icons.fastfood_outlined,
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
