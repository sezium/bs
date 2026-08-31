import 'package:bs/base/domain/repository/base_repository_manager.dart';
import 'package:bs/core/settings/category_settings_repository.dart';
import 'package:bs/core/widgets/button.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Parametri passati a [CategorySettingsScreen] tramite `extra` di GoRouter.
/// Un solo widget/una sola rotta serve tutte le categorie: ognuna passa
/// solo id, titolo, colore, etichetta del campo e i limiti/il default del
/// conteggio ("numero di carte"/"numero di immagini"/"numero di numeri"...).
class CategorySettingsArgs {
  const CategorySettingsArgs({
    required this.categoryId,
    required this.title,
    required this.color,
    required this.countLabel,
    required this.defaultCount,
    this.minCount = 1,
    this.maxCount = 999,
    this.secondaryCategoryId,
    this.secondaryCountLabel,
    this.secondaryDefaultCount,
    this.secondaryMinCount = 1,
    this.secondaryMaxCount = 999,
  });

  final String categoryId;
  final String title;
  final Color color;

  /// Es. "Numero di carte", "Numero di immagini", "Numero di numeri".
  final String countLabel;

  final int defaultCount;
  final int minCount;
  final int maxCount;

  /// Seconda impostazione opzionale della categoria (es. per Cards:
  /// "Numero di carte attive" durante la memorizzazione). Se
  /// [secondaryCategoryId] è `null`, il secondo campo non viene mostrato:
  /// questo lascia Numbers e le altre categorie invariate.
  final String? secondaryCategoryId;
  final String? secondaryCountLabel;
  final int? secondaryDefaultCount;
  final int secondaryMinCount;
  final int secondaryMaxCount;
}

/// Pagina Settings comune a tutte le categorie di allenamento. Ogni
/// categoria vi accede passando i propri [CategorySettingsArgs]: la UI e la
/// logica di salvataggio sono centralizzate qui, non duplicate per ognuna.
class CategorySettingsScreen extends StatefulWidget {
  const CategorySettingsScreen({super.key, required this.args});

  static const String routeName = '/settings';

  final CategorySettingsArgs args;

  @override
  State<CategorySettingsScreen> createState() => _CategorySettingsScreenState();
}

class _CategorySettingsScreenState extends State<CategorySettingsScreen> {
  late final CategorySettingsRepository _repository =
      BaseRepositoryManager.get<CategorySettingsRepository>();
  late final TextEditingController _controller;
  TextEditingController? _secondaryController;

  bool get _hasSecondary => widget.args.secondaryCategoryId != null;

  @override
  void initState() {
    super.initState();
    final stored = _repository.getItemCount(widget.args.categoryId);
    _controller = TextEditingController(text: stored?.toString() ?? '');

    if (_hasSecondary) {
      final storedSecondary = _repository.getItemCount(widget.args.secondaryCategoryId!);
      _secondaryController = TextEditingController(text: storedSecondary?.toString() ?? '');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _secondaryController?.dispose();
    super.dispose();
  }

  void _save() {
    _saveField(
      controller: _controller,
      categoryId: widget.args.categoryId,
      minCount: widget.args.minCount,
      maxCount: widget.args.maxCount,
    );
    if (_hasSecondary) {
      _saveField(
        controller: _secondaryController!,
        categoryId: widget.args.secondaryCategoryId!,
        minCount: widget.args.secondaryMinCount,
        maxCount: widget.args.secondaryMaxCount,
      );
    }
    if (context.canPop()) {
      context.pop();
    }
  }

  void _saveField({
    required TextEditingController controller,
    required String categoryId,
    required int minCount,
    required int maxCount,
  }) {
    final text = controller.text.trim();
    if (text.isEmpty) {
      // Campo vuoto = torna al default della sezione.
      _repository.setItemCount(categoryId, null);
    } else {
      final parsed = int.tryParse(text);
      if (parsed != null) {
        final clamped = parsed.clamp(minCount, maxCount);
        _repository.setItemCount(categoryId, clamped);
      }
    }
  }

  void _resetToDefault() {
    setState(() {
      _controller.clear();
      _secondaryController?.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.args.color;

    return Scaffold(
      backgroundColor: BsColors.white,
      appBar: AppBar(
        backgroundColor: BsColors.white,
        foregroundColor: BsColors.black,
        elevation: 0,
        title: Text(
          '${widget.args.title} settings',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: BsColors.black),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.args.countLabel,
                    style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: BsColors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lascia vuoto per usare il default (${widget.args.defaultCount}).',
                    style: GoogleFonts.lato(fontSize: 13, color: BsColors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    cursorColor: BsColors.black,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '${widget.args.defaultCount}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: BsColors.grey, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: BsColors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: color, width: 1),
                      ),
                    ),
                  ),
                  if (_hasSecondary) ...[
                    const SizedBox(height: 24),
                    Text(
                      widget.args.secondaryCountLabel!,
                      style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: BsColors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lascia vuoto per usare il default (${widget.args.secondaryDefaultCount}).',
                      style: GoogleFonts.lato(fontSize: 13, color: BsColors.grey),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _secondaryController,
                      cursorColor: BsColors.black,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: '${widget.args.secondaryDefaultCount}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: BsColors.grey, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: BsColors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: color, width: 1),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _resetToDefault,
                        child: Text('Usa default', style: GoogleFonts.lato(color: BsColors.grey)),
                      ),
                      bsButton(title: 'Save', color: color, onTap: _save),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
