sealed class CardsEvent {
  const CardsEvent();
}

final class CardsEventInit extends CardsEvent {
  const CardsEventInit();
}

final class CardsEventStartReadyRoom extends CardsEvent {
  const CardsEventStartReadyRoom();
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