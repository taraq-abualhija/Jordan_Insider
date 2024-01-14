abstract class TicketStates {}

class TicketInitialState extends TicketStates {}

class GetUserTicketLoadingState extends TicketStates {}

class GetUserTicketSuccessState extends TicketStates {}

class GetUserTicketErrorState extends TicketStates {}

class DeleteTicketLoadingState extends TicketStates {}

class DeleteTicketSuccessState extends TicketStates {}

class DeleteTicketErrorState extends TicketStates {}
