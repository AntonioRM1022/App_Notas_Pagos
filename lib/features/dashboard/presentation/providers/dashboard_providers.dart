import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cards_vault/presentation/providers/cards_providers.dart';
import '../../../cards_vault/domain/card_calculations.dart';
import '../../../cards_vault/domain/credit_card.dart';

class UpcomingEventInfo {
  final String title;
  final DateTime date;
  final int daysRemaining;
  final CreditCard card;

  UpcomingEventInfo({
    required this.title,
    required this.date,
    required this.daysRemaining,
    required this.card,
  });
}

final upcomingEventsProvider = FutureProvider<List<UpcomingEventInfo>>((ref) async {
  final repo = ref.watch(cardsRepositoryProvider);
  final cards = await repo.getCards();
  
  List<UpcomingEventInfo> events = [];
  final now = DateTime.now();

  for (var card in cards) {
    UpcomingEventInfo? nearestForCard;
    int minDays = 999;
    
    final subs = await repo.getSubscriptionsForCard(card.id);
    for (var sub in subs) {
      if (sub.isActive) {
        DateTime nextChargeDate;
        if (now.day <= sub.billingDay) {
          nextChargeDate = DateTime(now.year, now.month, sub.billingDay);
        } else {
          int nextMonth = now.month == 12 ? 1 : now.month + 1;
          int nextYear = now.month == 12 ? now.year + 1 : now.year;
          nextChargeDate = DateTime(nextYear, nextMonth, sub.billingDay);
        }
        
        int daysLeft = nextChargeDate.difference(DateTime(now.year, now.month, now.day)).inDays;
        
        if (daysLeft >= 0 && daysLeft < minDays) {
          minDays = daysLeft;
          nearestForCard = UpcomingEventInfo(
            title: sub.serviceName,
            date: nextChargeDate,
            daysRemaining: daysLeft,
            card: card,
          );
        }
      }
    }
    
    if (nearestForCard != null) {
      events.add(nearestForCard);
    }
  }

  return events;
});

class FinancialAlertInfo {
  final String cardAlias;
  final String statusText;
  final double amount;
  final bool isOverdue;

  FinancialAlertInfo({
    required this.cardAlias,
    required this.statusText,
    required this.amount,
    required this.isOverdue,
  });
}

class CardFinancialSummary {
  final CreditCard card;
  final CardStatement statement;
  final FinancialAlertInfo? alert;

  CardFinancialSummary({
    required this.card,
    required this.statement,
    this.alert,
  });
}

final cardSummariesProvider = FutureProvider<List<CardFinancialSummary>>((ref) async {
  final repo = ref.watch(cardsRepositoryProvider);
  final cards = await repo.getCards();
  final now = DateTime.now();
  List<CardFinancialSummary> summaries = [];

  for (var card in cards) {
    final txs = await repo.getTransactionsForCard(card.id);
    final statement = calculateCardStatement(card, txs);

    FinancialAlertInfo? alert;
    
    DateTime nextLimitDate;
    if (now.day <= card.paymentLimitDay) {
      nextLimitDate = DateTime(now.year, now.month, card.paymentLimitDay);
    } else {
      int nextMonth = now.month == 12 ? 1 : now.month + 1;
      int nextYear = now.month == 12 ? now.year + 1 : now.year;
      nextLimitDate = DateTime(nextYear, nextMonth, card.paymentLimitDay);
    }
    
    int daysLeft = nextLimitDate.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (statement.previousCutoffDue > 0) {
      alert = FinancialAlertInfo(
        cardAlias: card.alias,
        statusText: daysLeft == 0 ? 'VENCE HOY' : (daysLeft < 0 ? 'VENCIDA' : 'Límite de pago en $daysLeft días'),
        amount: statement.previousCutoffDue,
        isOverdue: daysLeft <= 1,
      );
    }

    summaries.add(CardFinancialSummary(
      card: card,
      statement: statement,
      alert: alert,
    ));
  }

  return summaries;
});
