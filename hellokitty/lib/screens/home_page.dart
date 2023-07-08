import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/option_box.dart';
import '../routes/app_routes.dart';
import '../components/path_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  // const HomePage({super.key});
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // app bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // menu icon
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.camera);
                    }, // Image tapped
                    // child: Image.asset(
                    //   'assets/icons/menu.png',
                    //   height: 45,
                    //   color: Colors.grey[800],
                    // ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 45,
                      color: Colors.grey[800],
                    ),
                  ),

                  // logout icon
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.login);
                    }, // Image tapped
                    child: Icon(
                      Icons.exit_to_app_rounded,
                      size: 45,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // welcome home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Home,",
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                  InkWell(
                    child: Text(
                      'Pooki',
                      style: GoogleFonts.bebasNeue(fontSize: 72),
                    ),
                    onTap: () {
                      showNotification();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),

            const SizedBox(height: 10),

            // grid
            Expanded(
              child: GridView.builder(
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        print("index 0 is tapped");
                        Navigator.pushNamed(context, Routes.petProfile);
                      }

                      if (index == 1) {
                        print("index 1 is tapped");
                        Navigator.pushNamed(context, Routes.autoFeeding);
                      }

                      if (index == 2) {
                        print("index 2 is tapped");
                        Navigator.pushNamed(context, Routes.manualFeeding);
                      }

                      if (index == 3) {
                        print("index 3 is tapped");
                        Navigator.pushNamed(context, Routes.feedingRecords);
                      }
                    },
                    child: CustomOptionBox(
                      optionName: IconPath.customOptions[index][0],
                      iconPath: IconPath.customOptions[index][1],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  showNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high channel',
      'Very important notification!!',
      description: 'Too little cat food, please add it in time!',
      importance: Importance.max,
    );

    const androidNotificationDetail = AndroidNotificationDetails(
        '0', // channel Id
        'general' // channel Name
        );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      'Hello Kitty',
      'Too little cat food, please add it in time!',
      notificationDetails,
    );
  }
}
