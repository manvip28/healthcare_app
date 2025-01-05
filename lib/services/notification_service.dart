import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';  // For logging and exception handling

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);

    try {
      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          // Handle notification tap
        },
      );
    } on PlatformException catch (e) {
      // Handle platform-specific errors
      print('Error initializing notifications: ${e.message}');
    }
  }

  Future<void> scheduleAppointmentNotification(
      String patientName,
      DateTime appointmentTime,
      String purpose,
      ) async {
    // Schedule notification for 1 hour before the appointment
    final scheduledTime = appointmentTime.subtract(const Duration(hours: 1));

    if (scheduledTime.isBefore(DateTime.now())) {
      return; // Don't schedule if the time has already passed
    }

    const androidDetails = AndroidNotificationDetails(
      'appointment_channel',
      'Appointment Notifications',
      channelDescription: 'Notifications for upcoming appointments',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    try {
      await _notificationsPlugin.zonedSchedule(
        appointmentTime.millisecondsSinceEpoch ~/ 1000,
        'Upcoming Appointment',
        'You have an appointment with $patientName in 1 hour.\nPurpose: $purpose',
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    } on PlatformException catch (e) {
      print('Error scheduling notification: ${e.message}');
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } on PlatformException catch (e) {
      print('Error canceling notification: ${e.message}');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
    } on PlatformException catch (e) {
      print('Error canceling all notifications: ${e.message}');
    }
  }
}
