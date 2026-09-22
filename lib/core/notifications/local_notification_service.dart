import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsIOS = 
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
            
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  void _onNotificationTap(NotificationResponse notificationResponse) {
    // Manejar redirección al tocar la notificación
  }

  Future<void> scheduleCardPaymentReminder({
    required int cardId,
    required String alias,
    required DateTime paymentLimitDate,
  }) async {
    final scheduleDate = paymentLimitDate.subtract(const Duration(days: 2));
    
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: cardId, // Usamos el ID de la tarjeta como ID de notificación
      title: 'Pago próximo: $alias',
      body: 'Faltan 2 días para tu límite de pago.',
      scheduledDate: tz.TZDateTime.from(scheduleDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'card_reminders_channel',
          'Recordatorios de Tarjetas',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime, // Repetición mensual
    );
  }

  Future<void> scheduleEventReminders({
    required int eventId,
    required String profileName,
    required String eventType,
    required DateTime eventDate,
  }) async {
    // 7 días antes
    await _scheduleZonedReminder(
      id: int.parse('${eventId}7'),
      title: '$eventType de $profileName se acerca',
      body: 'Faltan 7 días. Revisa tus notas rápidas.',
      scheduledDate: eventDate.subtract(const Duration(days: 7)),
    );
    
    // 3 días antes
    await _scheduleZonedReminder(
      id: int.parse('${eventId}3'),
      title: '¡Faltan 3 días para el $eventType de $profileName!',
      body: 'No olvides preparar el regalo.',
      scheduledDate: eventDate.subtract(const Duration(days: 3)),
    );

    // Mismo día
    await _scheduleZonedReminder(
      id: int.parse('${eventId}0'),
      title: '¡Hoy es el $eventType de $profileName!',
      body: '¡Felicítal@!',
      scheduledDate: eventDate,
    );
  }

  Future<void> _scheduleZonedReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'event_reminders_channel',
          'Recordatorios de Eventos',
          importance: Importance.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime, // Repetición anual
    );
  }
}
