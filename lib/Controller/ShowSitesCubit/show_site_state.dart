abstract class ShowSiteStates {}

class ShowSiteInitialStates extends ShowSiteStates {}

class ShowSiteLoadingStates extends ShowSiteStates {}

class ShowSiteSuccessStates extends ShowSiteStates {}

class GetSiteSuccessStates extends ShowSiteStates {}

class GetSiteByIDSuccessStates extends ShowSiteStates {}

class ShowSiteErrorStates extends ShowSiteStates {
  final String error;
  ShowSiteErrorStates(this.error);
}
