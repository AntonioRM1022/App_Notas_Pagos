import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

import 'core/notifications/local_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/cards_vault/domain/credit_card.dart';
import 'features/cards_vault/domain/card_transaction.dart';
import 'features/cards_vault/domain/card_subscription.dart';
import 'features/important_dates/domain/profile_event.dart';
import 'features/important_dates/domain/love_note.dart';
import 'features/important_dates/domain/personal_note.dart';
import 'features/cards_vault/data/repository/cards_repository.dart';
import 'package:intl/date_symbol_data_local.dart';

late Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('es_ES', null);
  
  // Inicializar Isar
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [
      CreditCardSchema, 
      CardTransactionSchema, 
      CardSubscriptionSchema, 
      ProfileEventSchema, 
      QuickNoteSchema,
      LoveNoteSchema,
      PersonalNoteSchema,
    ],
    directory: dir.path,
  );

  // Inicializar notificaciones
  await LocalNotificationService().initialize();

  // Sincronizar suscripciones para generar cargos automáticos
  try {
    final repo = CardsRepository(isar);
    await repo.syncSubscriptionsToTransactions();
  } catch (e) {
    debugPrint('Error syncing subscriptions: $e');
  }

  runApp(
    const ProviderScope(
      child: NotaPremiumApp(),
    ),
  );
}

class NotaPremiumApp extends StatelessWidget {
  const NotaPremiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nota Premium',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
