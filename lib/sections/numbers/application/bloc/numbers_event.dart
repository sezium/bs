sealed class NumbersEvent {
  const NumbersEvent();
}

final class NumbersEventInit extends NumbersEvent {
  const NumbersEventInit();
}

class NumbersEventStartReadyRoom extends NumbersEvent {
  const NumbersEventStartReadyRoom({this.numberCount = 100});
  final int numberCount;
}

final class NumbersEventTick extends NumbersEvent {
  const NumbersEventTick();
}

final class NumbersEventReadyRoomFinished extends NumbersEvent {
  const NumbersEventReadyRoomFinished();
}

final class NumbersEventNextNumber extends NumbersEvent {
  const NumbersEventNextNumber();
}

final class NumbersEventPreviousNumber extends NumbersEvent {
  const NumbersEventPreviousNumber();
}

final class NumbersEventRestartSequence extends NumbersEvent {
  const NumbersEventRestartSequence();
}

final class NumbersEventRecallTick extends NumbersEvent {
  const NumbersEventRecallTick();
}

final class NumbersEventSkipPlaying extends NumbersEvent {
  const NumbersEventSkipPlaying();
}

final class NumbersEventPlaceNumber extends NumbersEvent {
  const NumbersEventPlaceNumber({required this.number, required this.slotIndex});
  final int? number;
  final int slotIndex;
}

final class NumbersEventReturnNumberToDeck extends NumbersEvent {
  const NumbersEventReturnNumberToDeck({required this.slotIndex});
  final int slotIndex;
}

final class NumbersEventConfirmRecall extends NumbersEvent {
  const NumbersEventConfirmRecall();
}

final class NumbersEventFinishRecall extends NumbersEvent {
  const NumbersEventFinishRecall();
}