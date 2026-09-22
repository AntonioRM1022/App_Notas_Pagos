import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../features/cards_vault/domain/credit_card.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin plugin;

  NotificationService(this.plugin);

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await plugin.initialize(settings: settings);
  }

  /// Calculates the exact date and time (10:00 AM, 1 day before payment limit)
  DateTime calculateReminderDate(int paymentLimitDay, DateTime now) {
    DateTime nextLimitDate;
    if (now.day <= paymentLimitDay) {
      nextLimitDate = DateTime(now.year, now.month, paymentLimitDay);
    } else {
      int nextMonth = now.month == 12 ? 1 : now.month + 1;
      int nextYear = now.month == 12 ? now.year + 1 : now.year;
      nextLimitDate = DateTime(nextYear, nextMonth, paymentLimitDay);
    }
    
    // 1 day before
    final reminderDate = nextLimitDate.subtract(const Duration(days: 1));
    // Set to 10:00 AM
    return DateTime(reminderDate.year, reminderDate.month, reminderDate.day, 10, 0);
  }

  Future<void> schedulePaymentReminder(CreditCard card, {DateTime? now}) async {
    final currentTime = now ?? DateTime.now();
    final reminderDate = calculateReminderDate(card.paymentLimitDay, currentTime);
    
    // Only schedule if it's in the future
    if (reminderDate.isBefore(currentTime)) return;

    await plugin.zonedSchedule(
      id: card.id.hashCode,
      title: 'Pago próximo: ${card.alias}',
      body: 'Mañana es tu límite de pago. ¡No olvides pagar a tiempo para evitar intereses!',
      scheduledDate: tz.TZDateTime.from(reminderDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'payment_reminders',
          'Recordatorios de Pago',
          channelDescription: 'Avisos de límite de pago',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime, // Make it recurring monthly!
    );
  }
}
