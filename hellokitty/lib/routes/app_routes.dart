import 'package:hellokitty/screens/%20camera_page.dart';
import 'package:hellokitty/screens/login_screen.dart';
import 'package:hellokitty/screens/profile_page.dart';
import 'package:hellokitty/widgets/linechart.dart';

import '../screens/home_page.dart';
import '../screens/auto_feeding.dart';
import '../screens/manual_feeding.dart';
import '../screens/feeding_records.dart';
import '../screens/feeding_records.dart';

/// contains a list of route names.
// made separately to make it easier to manage route naming
class _Paths {
  static const home = '/';
  static const login = '/login';
  static const petProfile = '/petprofile';
  static const autoFeeding = '/autofeeding';
  static const manualFeeding = '/manualfeeding';
  static const feedingRecords = '/feedingrecords';
  static const camera = '/camera';
}

/// used to switch pages
class Routes {
  static const home = _Paths.home;
  static const login = _Paths.login;
  static const petProfile = _Paths.petProfile;
  static const autoFeeding = _Paths.autoFeeding;
  static const manualFeeding = _Paths.manualFeeding;
  static const feedingRecords = _Paths.feedingRecords;
  static const camera = _Paths.camera;
}

/// contains all configuration pages
class AppPages {
  /// when the app is opened, this page will be the first to be shown
  static const initial = Routes.login;

  static final routes = {
    Routes.home: (context) => const HomePage(),
    Routes.login: (context) => LoginPage(),
    Routes.petProfile: (context) => ProfilePage(),
    // Routes.petProfile: (context) => const LineChartSample2(),
    Routes.autoFeeding: (context) => const AutoFeeding(),
    Routes.manualFeeding: (context) => ManualFeeding(),
    Routes.feedingRecords: (context) => FeedingRecords(),
    Routes.camera: (context) => const CameraPage(),
  };
}
