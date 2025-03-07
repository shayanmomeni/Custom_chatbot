import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/core/utils/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  print("Initializing local cache...");
  await AppRepo().localCache.init();
  print("Local cache initialized successfully!");

  // Initialize timezone data and set location to Germany
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

  // Initialize local notifications
  await NotificationService().init();

  // Request notification permission for Android (for API level 33+)
  await _requestNotificationPermission();

  // Schedule your notifications (example)
  await scheduleDailyReminders();

  runApp(const MyApp());
}

Future<void> _requestNotificationPermission() async {
  // Only request if not granted
  if (await Permission.notification.status != PermissionStatus.granted) {
    await Permission.notification.request();
  }
}

Future<void> scheduleDailyReminders() async {
  final notificationService = NotificationService();

  // Example notifications at 10:00 AM, 4:00 PM, and 6:00 PM
  await notificationService.scheduleDailyNotification(
    id: 0,
    title: 'Daily Reminder',
    body: 'It\'s 10:00 AM! Time to check in with Reflecto Chatbot.',
    hour: 10,
    minute: 0,
  );
  await notificationService.scheduleDailyNotification(
    id: 1,
    title: 'Daily Reminder',
    body: 'It\'s 4:00 PM! How about a quick chat?',
    hour: 16,
    minute: 0,
  );
  await notificationService.scheduleDailyNotification(
    id: 2,
    title: 'Daily Reminder',
    body: 'It\'s 6:00 PM! Wrap up your day with a chat.',
    hour: 18,
    minute: 0,
  );

  // For testing: schedule a notification 5 minutes from now
  final now = tz.TZDateTime.now(tz.local);
  final testReminderTime = now.add(const Duration(minutes: 1));

  await notificationService.flutterLocalNotificationsPlugin.zonedSchedule(
    3,
    'Test Reminder',
    'This is a test reminder scheduled 1 minutes from now.',
    testReminderTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel_id',
        'Test Notifications',
        channelDescription: 'Test reminder notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    androidAllowWhileIdle: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: AppConfig().routes.pages,
          initialRoute: AppConfig().routes.splash,
          theme: AppConfig().theme.light(),
        ),
      ),
    );
  }
}
