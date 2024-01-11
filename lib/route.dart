import 'package:jordan_insider/Views/Admin/AddCoor/add_coor_screen.dart';
import 'package:jordan_insider/Views/Admin/Home/home_page.dart';
import 'package:jordan_insider/Views/Admin/SIteManagement/AcceptNewSite/accept_new_sites.dart';
import 'package:jordan_insider/Views/Admin/SIteManagement/AcceptSiteScreen/accept_site_screen.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/camera_screen.dart';
import 'package:jordan_insider/Views/Tourist_Views/Drawer%20Pages/Profile/change_pass.dart';
import 'package:jordan_insider/Views/Tourist_Views/Drawer%20Pages/Profile/editprofile.dart';
import 'package:jordan_insider/Views/Tourist_Views/Drawer%20Pages/Profile/profile.dart';
import 'package:jordan_insider/Views/Tourist_Views/Attraction%20Screen/attractionscreen.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/loginpage.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/signuppage.dart';
import 'package:jordan_insider/Views/Shared_Views/Welcome%20Pages/welcomepage.dart';
import 'package:jordan_insider/Views/Tourist_Views/Drawer%20Pages/user_reviews.dart';
import 'Views/Coordinator_Views/AddSite/addsitepage.dart';
import 'Views/Coordinator_Views/AddEventScreen/addeventscreen.dart';
import 'Views/Coordinator_Views/HomePage/coorhomepage.dart';
import 'Views/Tourist_Views/Home Page/homepage.dart';
import 'Views/Tourist_Views/Search_Screen/searchscreen.dart';

getRouts() {
  return {
    /*Pages*/
    //----------Shared------------//
    WelcomePage.route: (context) => WelcomePage(),
    LoginPage.route: (context) => LoginPage(),
    SignUp.route: (context) => SignUp(),
    Profile.route: (context) => Profile(),
    EditProfile.route: (context) => EditProfile(),
    ChangePassScreen.route: (context) => ChangePassScreen(),
    UserReviews.route: (context) => UserReviews(),
    CameraScreen.route: (context) => CameraScreen(),
    //-.-.-.-.-.-.-.-.-.-.-.-.-.-.//
    //----------Tourist-----------//
    TouristHomePage.route: (context) => TouristHomePage(),
    AttractionScreen.route: (context) => AttractionScreen(),
    SearchScreen.route: (context) => SearchScreen(),
    //-.-.-.-.-.-.-.-.-.-.-.-.-.-.//
    //-----------Admin------------//
    AdminHomePage.route: (context) => AdminHomePage(),
    AcceptNewSite.route: (context) => AcceptNewSite(),
    AddCoordinatorScreen.route: (context) => AddCoordinatorScreen(),
    AcceptSiteScreen.route: (context) => AcceptSiteScreen(),
    //-.-.-.-.-.-.-.-.-.-.-.-.-.-.//
    //------------Coor------------//
    CoorHomePage.route: (context) => CoorHomePage(),
    AddSitePage.route: (context) => AddSitePage(),
    AddEventScreen.route: (context) => AddEventScreen(),
    //-.-.-.-.-.-.-.-.-.-.-.-.-.-.//
  };
}
