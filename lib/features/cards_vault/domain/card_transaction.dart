import 'package:isar/isar.dart';
import 'credit_card.dart';

part 'card_transaction.g.dart';

enum TransactionType { purchase, payment, subscriptionCharge }

@collection
class CardTransaction {
  Id id = Isar.autoIncrement;

  late String concept; // Name of the purchase/store
  late double amount; // Total amount
  late DateTime date;

  @Enumerated(EnumType.name)
  late TransactionType type;

  bool isDeleted = false;
  int deferredCycles = 0;

  // For Meses Sin Intereses (MSI)
  int installments = 1; // Default to 1 (normal purchase)
  
  // Link to the credit card it belongs to
  @Backlink(to: 'transactions')
  final card = IsarLink<CreditCard>();
}
