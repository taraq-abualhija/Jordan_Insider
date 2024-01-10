abstract class AcceptSiteStates {}

class AcceptSiteInitialStates extends AcceptSiteStates {}

class AcceptSiteLoadingStates extends AcceptSiteStates {}

class AcceptSiteSuccessStates extends AcceptSiteStates {}

class AcceptSiteErrorStates extends AcceptSiteStates {
  final String error;
  AcceptSiteErrorStates(this.error);
}
