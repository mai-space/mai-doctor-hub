/// Best-effort PDF-Text ohne Legacy-Plugin (AGP-9-/jcenter-frei).
///
/// Vollständige Extraktion folgt später mit einem AGP-9-kompatiblen Paket.
/// Bis dahin bleiben Titel/Metadaten und manuelle Notizen in der FTS suchbar.
Future<({String? text, int? pageCount})> extractPdfText(String path) async {
  return (text: null, pageCount: null);
}
