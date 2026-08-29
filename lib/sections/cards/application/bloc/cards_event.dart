sealed class CardsEvent {
  const CardsEvent();
}

final class CardsEventInit extends CardsEvent {
  const CardsEventInit();
}

final class CardsEventStartReadyRoom extends CardsEvent {
  const CardsEventStartReadyRoom({this.cardCount});

  /// Numero di carte del mazzo da memorizzare (max 52, un mazzo reale non
  /// ha ripetizioni). `null` = usa il valore salvato nelle Settings, poi il
  /// default.
  final int? cardCount;
}

final class CardsEventTick extends CardsEvent {
  const CardsEventTick();
}

final class CardsEventReadyRoomFinished extends CardsEvent {
  const CardsEventReadyRoomFinished();
}

final class CardsEventNextCard extends CardsEvent {
  const CardsEventNextCard();
}

final class CardsEventPreviousCard extends CardsEvent {
  const CardsEventPreviousCard();
}

final class CardsEventRestartSequence extends CardsEvent {
  const CardsEventRestartSequence();
}

final class CardsEventRecallTick extends CardsEvent {
  const CardsEventRecallTick();
}

final class CardsEventSkipPlaying extends CardsEvent {
  const CardsEventSkipPlaying();
}

final class CardsEventPlaceCard extends CardsEvent {
  const CardsEventPlaceCard({required this.card, required this.slotIndex});
  final int card;
  final int slotIndex;
}

final class CardsEventReturnCardToDeck extends CardsEvent {
  const CardsEventReturnCardToDeck({required this.slotIndex});
  final int slotIndex;
}

final class CardsEventConfirmRecall extends CardsEvent {
  const CardsEventConfirmRecall();
}

/// Nuovo: termina la sessione dopo la conferma del recall e porta lo stato
/// a [CardsPhaseFinished]. Prima non esisteva nessun evento che facesse
/// questa transizione: il tasto "End" in `_RecallView` chiamava
/// `context.pop()` direttamente, uscendo dalla schermata invece di mostrare
/// la fase "Finished" con il tempo totale.
final class CardsEventFinishRecall extends CardsEvent {
  const CardsEventFinishRecall();
}