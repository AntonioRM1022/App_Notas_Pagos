import 'package:isar/isar.dart';
import 'card_transaction.dart';
import 'card_subscription.dart';

part 'credit_card.g.dart';

@collection
class CreditCard {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String alias; // Ej: "Nu", "Amex Oro"
  
  late int cutoffDay; // Día de corte (1-31)
  
  late int paymentLimitDay; // Día límite de pago (1-31)

  // Relaciones
  final transactions = IsarLinks<CardTransaction>();
  final subscriptions = IsarLinks<CardSubscription>();
}
