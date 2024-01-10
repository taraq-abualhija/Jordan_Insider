abstract class ShowEventStates {}

class ShowEventInitialStates extends ShowEventStates {}

class ShowEventLoadingStates extends ShowEventStates {}

class ShowEventSuccessStates extends ShowEventStates {}

class GetEventSuccessStates extends ShowEventStates {}

class GetEventByIDSuccessStates extends ShowEventStates {}

class ShowEventErrorStates extends ShowEventStates {
  final String error;
  ShowEventErrorStates(this.error);
}
