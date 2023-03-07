import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat_firebase/services/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'firebase_options.dart';
import 'services/init.dart';
import 'views/screens/splash_screen/splash_screen.dart';

List<CameraDescription> cameras = <CameraDescription>[];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Init().initialize();
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    log("${e.code} ${e.description}");
  }
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  initPlatForm() {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(""); //---------------------ADD ONESIGNAL APPID

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      if (kDebugMode) {
        print("Accepted permission: $accepted");
      }
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {});

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {});

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {});

    OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {});
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      initPlatForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ResponsiveSizer(
        maxMobileWidth: 599,
        maxTabletWidth: 1200,
        builder: (context, orientation, screenType) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: "Chat App",
            themeMode: ThemeMode.light,
            // theme: CustomTheme.dark,
            theme: ThemeData(
              colorSchemeSeed: primaryColor,
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: primaryColor,
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
