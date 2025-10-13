import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sunfireworks/services/ApiClient.dart';
import 'package:sunfireworks/services/SecureStorageService.dart';
import 'package:sunfireworks/utils/media_query_helper.dart';
import 'app_routes/StateInjector.dart';
import 'app_routes/router.dart';
import 'package:provider/provider.dart';
import 'utils/AppLogger.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
);

Future<void> main() async {
  ApiClient.setupInterceptors();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized");
  } catch (e) {
    print("❌ Error initializing Firebase: $e");
  }

  await _requestPushPermissions();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  // if (Platform.isIOS) {
  //   String? apnsToken = await messaging.getAPNSToken();
  //   AppLogger.log("📱 APNs Token: $apnsToken");
  // }
  //
  // String? fcmToken = await messaging.getToken();
  // AppLogger.log("🔥 FCM Token: $fcmToken");
  // if (fcmToken != null) {
  //   SecureStorageService.instance.setString("fb_token", fcmToken);
  // }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  const DarwinInitializationSettings iosInitSettings =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: iosInitSettings,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (resp) async {
      final p = resp.payload;
      if (p?.isNotEmpty == true) {
        final data = jsonDecode(p!) as Map<String, dynamic>;
      }
    },
  );

  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📥 Foreground message received:");
    print("  ▶ Title: ${message.notification?.title}");
    print("  ▶ Body: ${message.notification?.body}");
    print("  ▶ Data: ${message.data}");

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      showNotification(notification, android, message.data);
    }
  });

  // 1) Background → user tapped push and app was in background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("📲 Notification opened (background): ${message.data}");
  });

  // 2) Killed → user tapped push and app cold-started
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print(
      "🧊 App opened from terminated state via notif: ${initialMessage.data}",
    );
    // Schedule navigation after first frame so context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _navigateFromPushData(initialMessage.data);
    });
  }

  // Background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

/// Background handler (must be a top-level function or static)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🌙 Background message received:");
  print("  ▶ Title: ${message.notification?.title}");
  print("  ▶ Body: ${message.notification?.body}");
  print("  ▶ Data: ${message.data}");
}

Future<void> _requestPushPermissions() async {
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  } else if (Platform.isAndroid) {
    // Android 13+ runtime permission
    final plugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await plugin?.requestNotificationsPermission();
  }
}

// Function to display local notifications
void showNotification(
  RemoteNotification notification,
  AndroidNotification android,
  Map<String, dynamic> data,
) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformChannelSpecifics,
    payload: jsonEncode(data),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MultiProvider(
        providers: StateInjector.blocProviders,
        child: MaterialApp.router(
          builder: (BuildContext context, Widget? child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(textScaleFactor: 1.0),
              child: child ?? Container(),
            );
          },
          title: 'Sun FireWorks',
          theme: ThemeData(
            visualDensity: VisualDensity.compact,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.white,
            dialogBackgroundColor: Colors.white,
            cardColor: Colors.white,
            searchBarTheme: const SearchBarThemeData(),
            tabBarTheme: const TabBarThemeData(),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: const TextStyle(
                color: Colors.black,
                fontFamily: "roboto",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              labelStyle: const TextStyle(
                color: Colors.black,
                fontFamily: "roboto",
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              errorStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Colors.red,
              ),
            ),
            dialogTheme: const DialogThemeData(
              shadowColor: Colors.white,
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            buttonTheme: const ButtonThemeData(),
            popupMenuTheme: const PopupMenuThemeData(
              color: Colors.white,
              shadowColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              shadowColor: Colors.white,
              foregroundColor: Colors.white,
            ),
            cardTheme: CardThemeData(
              shadowColor: Colors.white,
              surfaceTintColor: Colors.white,
              color: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(style: ButtonStyle()),
            elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle()),
            outlinedButtonTheme: OutlinedButtonThemeData(style: ButtonStyle()),
            bottomSheetTheme: const BottomSheetThemeData(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
            ),
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              background: Colors.black,
            ).copyWith(background: Colors.black),
            // Optionally, set directly as fallback
            primaryColor: Colors.black,
            fontFamily: 'roboto',
            textTheme: TextTheme(
              displayLarge: TextStyle(
                color: Colors.black,
                fontFamily: 'roboto',
              ),
              displayMedium: TextStyle(
                color: Colors.black,
                fontFamily: 'roboto',
              ),
              displaySmall: TextStyle(
                color: Colors.black,
                fontFamily: 'roboto',
              ),
              headlineLarge: TextStyle(
                color: Colors.black,
                fontFamily: 'roboto',
              ),
              headlineMedium: TextStyle(
                color: Colors.black,
                fontFamily: 'roboto',
              ),
              headlineSmall: TextStyle(
                color: Colors.black,
                fontFamily: 'roboto',
              ),
              titleLarge: TextStyle(color: Colors.black, fontFamily: 'roboto'),
              titleMedium: TextStyle(color: Colors.black, fontFamily: 'roboto'),
              titleSmall: TextStyle(color: Colors.black, fontFamily: 'roboto'),
              bodyLarge: TextStyle(color: Colors.black, fontFamily: 'roboto'),
              bodyMedium: TextStyle(color: Colors.black, fontFamily: 'roboto'),
              bodySmall: TextStyle(color: Colors.black, fontFamily: 'roboto'),
              labelLarge: TextStyle(color: Colors.black, fontFamily: 'roboto'),
              labelMedium: TextStyle(color: Colors.black, fontFamily: 'roboto'),
              labelSmall: TextStyle(color: Colors.black, fontFamily: 'roboto'),
            ),
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
