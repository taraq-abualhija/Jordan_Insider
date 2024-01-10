abstract class EventManagementStates {}

class EventManagementInitialStates extends EventManagementStates {}

class EventManagementLoadingStates extends EventManagementStates {}

class EventManagementSuccessStates extends EventManagementStates {}

class EventManagementErrorStates extends EventManagementStates {
  final String error;
  EventManagementErrorStates(this.error);
}
