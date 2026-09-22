import 'package:isar/isar.dart';
import 'credit_card.dart';

part 'card_subscription.g.dart';

@collection
class CardSubscription {
  Id id = Isar.autoIncrement;

  late String serviceName; // Netflix, Spotify, etc.
  late double amount; // Cost per cycle
  late int billingDay; // 1-31
  bool isActive = true;
  DateTime? lastProcessedDate;

  @Backlink(to: 'subscriptions')
  final card = IsarLink<CreditCard>();

  bool isDeleted = false;
}
