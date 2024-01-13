abstract class ShowAttractionStates {}

class ShowAttractionInitialStates extends ShowAttractionStates {}

class ShowAttractionLoadingStates extends ShowAttractionStates {}

class ShowAttractionSuccessStates extends ShowAttractionStates {}

class GetAttractionSuccessStates extends ShowAttractionStates {}

class GetReviewByIdSuccessStates extends ShowAttractionStates {}

class GetReviewByIdErrorStates extends ShowAttractionStates {
  final String error;
  GetReviewByIdErrorStates(this.error);
}

class GetAttractioErrorStates extends ShowAttractionStates {
  final String error;
  GetAttractioErrorStates(this.error);
}

class GetReviewsByTouristSiteIdSuccessStates extends ShowAttractionStates {}

class ShowAttractionErrorStates extends ShowAttractionStates {
  final String error;
  ShowAttractionErrorStates(this.error);
}

//-Fav.
class AddToFavoriteLoadingState extends ShowAttractionStates {}

class AddToFavoriteSuccessState extends ShowAttractionStates {}

class AddToFavoriteErrorState extends ShowAttractionStates {}

//-Ticket
class BuyTicketLoadingState extends ShowAttractionStates {}

class BuyTicketSuccessState extends ShowAttractionStates {}

class BuyTicketErrorState extends ShowAttractionStates {}

//-----
class GetUserTicketLoadingState extends ShowAttractionStates {}

class GetUserTicketSuccessState extends ShowAttractionStates {}

class GetUserTicketErrorState extends ShowAttractionStates {}
