import 'package:bs/base/domain/repository/base_repository.dart';

/// Repository condiviso che tiene le impostazioni (per ora: il numero di
/// elementi da memorizzare) per ciascuna categoria di allenamento
/// (numbers, cards, images, ...). Non è specifico di una sezione: vive in
/// `core` proprio perché la UI che lo consuma (`CategorySettingsScreen`) è
/// centralizzata e riusata da tutte le categorie.
abstract class CategorySettingsRepository extends BaseRepository {
  /// Numero di elementi impostato per [categoryId], oppure `null` se
  /// l'utente non ha mai cambiato l'impostazione (in quel caso va usato il
  /// default della sezione).
  int? getItemCount(String categoryId);

  void setItemCount(String categoryId, int? value);
}
