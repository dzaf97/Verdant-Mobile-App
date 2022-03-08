import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:verdant_solar/screens/add-user.dart';
import 'package:verdant_solar/screens/customer-view/compare.dart';
import 'package:verdant_solar/screens/customer-view/cust-overview.dart';
import 'package:verdant_solar/screens/customer-view/notification.dart';
import 'package:verdant_solar/screens/customer-view/my-profile.dart';
import 'package:verdant_solar/screens/customer-view/premium.dart';
import 'package:verdant_solar/screens/customer-view/report.dart';
import 'package:verdant_solar/screens/device.dart';
import 'package:verdant_solar/screens/forgot-password.dart';
import 'package:verdant_solar/screens/map.dart';
import 'package:verdant_solar/screens/performance.dart';
import 'package:verdant_solar/screens/power-plant.dart';
import 'package:verdant_solar/screens/profile.dart';
import 'package:verdant_solar/screens/user.dart';
import 'package:verdant_solar/screens/login.dart';
import 'package:verdant_solar/screens/overview.dart';

routes() => [
      GetPage(
        name: '/login',
        page: () => Login(),
      ),
      GetPage(
        name: '/forgot-password',
        page: () => ForgotPassword(),
        transition: Transition.rightToLeft,
      ),

      // ADMIN VIEW
      GetPage(
        name: '/map',
        page: () => MapLatLng(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/power-plant',
        page: () => PowerPlant(),
      ),
      GetPage(
        name: '/overview',
        page: () => Overview(),
      ),
      GetPage(
        name: '/device',
        page: () => Device(),
      ),
      GetPage(
        name: '/profile',
        page: () => Profile(),
      ),
      GetPage(
        name: '/performance',
        page: () => Performance(),
      ),
      GetPage(
        name: '/user-management',
        page: () => User(),
      ),
      GetPage(
        name: '/add-user',
        page: () => AddUser(),
      ),
      GetPage(
        name: '/edit-user/:userid',
        page: () => AddUser(),
      ),

      // CUSTOMER VIEW
      GetPage(
        name: '/cust-overview',
        page: () => CustOverview(),
      ),
      GetPage(
        name: '/notification/:notiCount',
        page: () => NotificationPage(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: '/premium',
        page: () => Premium(),
      ),
      GetPage(
        name: '/compare',
        page: () => Compare(),
      ),
      GetPage(
        name: '/report',
        page: () => Report(),
      ),
      GetPage(
        name: '/my-profile',
        page: () => MyProfile(),
      ),
    ];
