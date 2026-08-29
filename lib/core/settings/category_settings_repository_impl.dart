import 'package:bs/core/settings/category_settings_repository.dart';

/// Implementazione in-memory: le impostazioni restano valide per tutta la
/// sessione dell'app (grazie alla cache singleton in
/// `BaseRepositoryManager`), ma vengono perse alla chiusura dell'app. Se in
/// futuro si vuole la persistenza su disco basta aggiungere qui la lettura/
/// scrittura (es. con `shared_preferences`) senza toccare chi la usa.
class CategorySettingsRepositoryImpl implements CategorySettingsRepository {
  final Map<String, int> _itemCounts = {};

  @override
  int? getItemCount(String categoryId) => _itemCounts[categoryId];

  @override
  void setItemCount(String categoryId, int? value) {
    if (value == null) {
      _itemCounts.remove(categoryId);
    } else {
      _itemCounts[categoryId] = value;
    }
  }
}
