abstract class SiteManagementStates {}

class SiteManagementInitialStates extends SiteManagementStates {}

class SiteManagementLoadingStates extends SiteManagementStates {}

class SiteManagementSuccessStates extends SiteManagementStates {}

class SiteManagementErrorStates extends SiteManagementStates {
  final String error;
  SiteManagementErrorStates(this.error);
}
