import 'package:flutter/material.dart';

import '../data/database_provider.dart';
import '../data/repositories/suggestion_repository.dart';

/// Textfeld, das früher eingegebene Werte des [field] als Autovervollständigung
/// anbietet. Beim Fokussieren eines leeren Feldes erscheinen die häufigsten.
class SuggestionTextField extends StatefulWidget {
  const SuggestionTextField({
    super.key,
    required this.controller,
    required this.field,
    this.decoration = const InputDecoration(),
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.sentences,
  });

  final TextEditingController controller;
  final SuggestionField field;
  final InputDecoration decoration;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  @override
  State<SuggestionTextField> createState() => _SuggestionTextFieldState();
}

class _SuggestionTextFieldState extends State<SuggestionTextField> {
  final _focusNode = FocusNode();
  Future<List<String>>? _values;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Async-Optionen: auch ein per autofocus fokussiertes Feld wartet so auf
    // die geladenen Werte, statt leer zu bleiben.
    _values ??= SuggestionRepository(DatabaseScope.of(context))
        .valuesFor(widget.field);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Kein LayoutBuilder: bricht in AlertDialog (intrinsische Größen);
    // RawAutocomplete gibt dem Options-Overlay ohnehin die Feldbreite.
    return RawAutocomplete<String>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (value) async =>
          SuggestionRepository.filter(await _values!, value.text),
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: widget.autofocus,
          textCapitalization: widget.textCapitalization,
          decoration: widget.decoration,
          onSubmitted: (_) => onSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final theme = Theme.of(context);
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  for (final option in options)
                    ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.history,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      title: Text(option),
                      onTap: () => onSelected(option),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
